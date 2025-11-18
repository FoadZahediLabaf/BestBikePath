//
//  RecordBikePathView.swift
//  BestBikePath
//
//  Created by Lorenzo Fiamingo on 06/11/25.
//

import MapKit
import SwiftUI
import Combine

struct RecordBikePathView: View {

    @Environment(BestBikePathModel.self) private var appModel

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var duration: Duration = .seconds(0)

    @State private var isStarted: Bool = false

    @State private var isRecording: Bool = false

    @State private var isCompleted: Bool = false

    @State private var confirmingObstacles: [UUID] = []

    @State private var isPublic = true

    let distance = Measurement<UnitLength>(value: 16342, unit: .meters)

    let averageSpeed = Measurement<UnitSpeed>(value: 68, unit: .kilometersPerHour)

    let peakSpeed = Measurement<UnitSpeed>(value: 103, unit: .kilometersPerHour)

    let temperature = Measurement<UnitTemperature>(value: 38, unit: .celsius)

    let humidity = Measurement<UnitPercent>(value: 38, unit: .percent)

    let windSpeed = Measurement<UnitSpeed>(value: 14, unit: .metersPerSecond)

    let buttonFontPointSize: CGFloat = 40

    var needsHours: Bool {
        duration >= .seconds(60*60)
    }

    var isTimerLarge: Bool {
        confirmingObstacles.isEmpty && (isRecording || !isStarted)
    }

    var body: some View {
            ScrollView {
                VStack {
                    Text(duration, format: .time(pattern: needsHours ? .hourMinuteSecond : .minuteSecond))
                        .monospaced()
                        .contentTransition(.numericText(countsDown: false))
                        .onReceive(timer) { input in
                            if isRecording {
                                duration += .seconds(1)
                            }
                        }
                        .font(.largeTitle.pointSize(isTimerLarge ? 64 : 24))
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .onTapGesture {
                            confirmingObstacles.append(UUID())
                        }

                    if confirmingObstacles.isEmpty {
                        Group {
                            if isStarted {
                                VStack {
                                    LabeledContent("Covered Distance", value: distance.formatted())
                                    Divider()
                                    LabeledContent("Average Speed", value: averageSpeed.formatted())
                                    Divider()
                                    LabeledContent("Peak Speed", value: peakSpeed.formatted())
                                }
                            }
//
//                            VStack {
//                                LabeledContent("Temperature", value: temperature.formatted())
//                                Divider()
//                                LabeledContent("Humidity", value: humidity.formatted())
//                                Divider()
//                                LabeledContent("Wind Speed", value: windSpeed.formatted())
//                            }

                            if isCompleted {
                                VStack {
                                    LabeledContent("Path Status", value: "Good")
                                    Divider()
                                    Toggle("Share Publicly", isOn: $isPublic)
                                }
                            }
                        }
                        .padding()
                        .background(.background)
                        .cornerRadius(32)
                        .transition(.blurReplace)
                    }

                    ForEach(confirmingObstacles, id: \.self) { obstacle in
                        VStack {
                            Label("An obstacle was detected", systemImage: "alert")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding()

                            ControlGroup {
                                Button("Confirm", systemImage: "checkmark") {
                                    confirmingObstacles = confirmingObstacles.filter { $0 != obstacle }
                                }
                                .buttonStyle(AutomaticPerformingButtonStyle())

                                Button("Cancel", systemImage: "xmark", role: .destructive) {
                                    confirmingObstacles = confirmingObstacles.filter { $0 != obstacle }
                                }
                                .buttonStyle(.bordered)
                            }
                            .controlSize(.extraLarge)
                            .buttonSizing(.flexible)
                            .font(.title2)
                            .fontWeight(.medium)
                            .controlGroupStyle(.navigation)
                        }
                        .padding()
                        .background(.background.secondary, in: .containerRelative)
                        .transition(.blurReplace)
                    }
                }
                .scenePadding()
            }
            .defaultScrollAnchor(.center)
            .scrollBounceBehavior(.basedOnSize)
            .safeAreaInset(edge: .bottom) {
                VStack {
                    if isCompleted {
                        Button {
                            // Save to disk the trip
                            appModel.presentedRootModal = .searchCommunityPaths
                        } label: {
                            Label {
                                Text("Save")
                                    .fixedSize()
                                    .frame(width: 172)
                            } icon: {
                                Image(systemName: "checkmark.circle.fill")
                            }

                        }
                        .labelReservedIconWidth(buttonFontPointSize)
                        .controlSize(.extraLarge)
                        .buttonStyle(.glassProminent)
                        .buttonSizing(.flexible)
                        .font(.largeTitle.pointSize(buttonFontPointSize))
                    } else {
                        if isStarted && !isRecording {
                            Button {
                                isCompleted = true
                            } label: {
                                Label {
                                    Text("Stop")
                                        .fixedSize()
                                        .frame(width: 172)
                                } icon: {
                                    Image(systemName: "stop.fill")
                                }

                            }
                            .labelReservedIconWidth(buttonFontPointSize)
                            .controlSize(.extraLarge)
                            .buttonStyle(.glassProminent)
                            .buttonSizing(.flexible)
                            .tint(.red)
                            .font(.largeTitle.pointSize(buttonFontPointSize))
                        }

                        Button {
                            isStarted = true
                            isRecording.toggle()
                        } label: {
                            Label {
                                Text(isRecording ? "Pause" : isStarted ? "Resume" : "Start")
                                    .fixedSize()
                                    .frame(width: 172)
                            } icon: {
                                Image(systemName: isRecording ? "pause.fill" : "play.fill")
                            }

                        }
                        .contentTransition(.symbolEffect(.replace))
                        .labelReservedIconWidth(buttonFontPointSize)
                        .controlSize(.extraLarge)
                        .buttonStyle(.glassProminent)
                        .buttonSizing(.flexible)
                        .tint(isRecording ? .orange : .green)
                        .font(.largeTitle.pointSize(buttonFontPointSize))
                    }
                }
                .scenePadding()
            }
            .navigationTitle("Record Bike Path")
            .toolbarTitleDisplayMode(.inline)
            .animation(.default, value: isRecording)
            .animation(.default, value: isStarted)
            .animation(.default, value: isCompleted)
            .animation(.default, value: duration)
            .animation(.default, value: needsHours)
            .animation(.default, value: confirmingObstacles)
            .toolbar {
                Button(role: .cancel) {
                    appModel.presentedRootModal = .searchCommunityPaths
                }
            }
    }
}

#Preview {
    NavigationStack {
        RecordBikePathView()
    }
}

struct AutomaticPerformingButtonStyle: PrimitiveButtonStyle {
    @State private var isActive: Bool = false
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Button(configuration)
                .buttonStyle(.borderedProminent)
                .tint(Color.accentColor.opacity(0.25))

            Button(configuration)
                .buttonStyle(.borderedProminent)
                .mask {
                    Rectangle()
                        .animation(.linear(duration: 5)) { content in
                            let isActive = self.isActive

                            content
                                .visualEffect { content, geometryProxy in
                                    content
                                        .offset(x: isActive ? 0 : -geometryProxy.size.width)
                                }
                        }
                }
        }
        .onAppear {
            withAnimation(.linear(duration: 5)) {
                isActive = true
            } completion: {
                configuration.trigger()
            }
        }
    }
}

final class UnitPercent: Dimension, @unchecked Sendable {
    static let percent = UnitPercent(symbol: "%", converter: UnitConverterLinear(coefficient: 0.01))
    override class func baseUnit() -> UnitPercent { .percent }
}
