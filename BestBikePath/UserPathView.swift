//
//  UserBikePathView.swift
//  BestBikePath
//
//  Created by Lorenzo Fiamingo on 06/11/25.
//

import SwiftUI
import MapKit

struct UserPathView: View {

    @Environment(BestBikePathModel.self) private var appModel

    @State private var rate: Double = 4

    @State private var sharePublicly = true

    @State private var hasChanged = false

    var isUserPath: Bool = false

    let distance = Measurement<UnitLength>(value: 16342, unit: .meters)

    let averageSpeed = Measurement<UnitSpeed>(value: 68, unit: .kilometersPerHour)

    let peakSpeed = Measurement<UnitSpeed>(value: 103, unit: .kilometersPerHour)

    let temperature = Measurement<UnitTemperature>(value: 38, unit: .celsius)

    let humidity = Measurement<UnitPercent>(value: 38, unit: .percent)

    let windSpeed = Measurement<UnitSpeed>(value: 14, unit: .metersPerSecond)

    var rateSlider: some View {
        LabeledContent {
            ZStack(alignment: .trailing) {
                Text("Impassable")
                    .hidden()
                switch rate {
                case ..<2:
                    Text("Impassable")
                case 2..<3:
                    Text("Poor")
                case 3..<4:
                    Text("Fair")
                case 4..<5:
                    Text("Good")
                case 5...:
                    Text("Excellent")
                default:
                    Text("Error")
                }
            }
        } label: {
            HStack {
                Text("Path Status")
                    .padding(.trailing)
                    .padding(.trailing)

                Slider(value: $rate, in: 1...5) {
                    Text("Path Status")
                } ticks: {
                    SliderTickContentForEach(
                        stride(from: 1.0, through: 5.0, by: 1).map { $0 },
                        id: \.self
                    ) { value in
                        SliderTick(value)
                    }
                }
            }
        }
    }

    var body: some View {
        List {
            if isUserPath {
                Section {
                    rateSlider
                        .onChange(of: rate) {
                            hasChanged = true
                        }

                    Toggle("Share Pubblicly", isOn: $sharePublicly)
                        .onChange(of: sharePublicly) {
                            hasChanged = true
                        }
                }
            } else {
                Section {
                    LabeledContent {
                        Text("Excellent")
                    } label: {
                        Text("Status")
                    }

                }
            }

            if isUserPath {
                Section("Performance") {
                    LabeledContent("Covered Distance", value: distance.formatted())
                    LabeledContent("Average Speed", value: averageSpeed.formatted())
                    LabeledContent("Peak Speed", value: peakSpeed.formatted())
                }

                Section("Weather") {
                    LabeledContent("Temperature", value: temperature.formatted())
                    LabeledContent("Humidity", value: humidity.formatted())
                    LabeledContent("Wind Speed", value: windSpeed.formatted())
                }
            }



            Section("Path") {
                DisclosureGroup("Locations") {
                    ForEach(appModel.mapItems, id: \.description) { item in
                        VStack(alignment: .leading) {
                            Text(item.name ?? "Undefined")

                            if let fullAddress = item.addressRepresentations?.fullAddress(includingRegion: false, singleLine: true) {
                                Text(fullAddress)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                DisclosureGroup("Directions") {
                    ForEach(appModel.routes.flatMap { $0.route.steps }.enumerated(), id: \.1.description) { (order: Int, step: MKRoute.Step) in
                        VStack(alignment: .leading) {
                            Text(step.instructions)

                            if let notice = step.notice {
                                Label(notice, systemImage: "exclamationmark.triangle")
                                    .font(.caption)
                                    .foregroundStyle(.red.secondary)
                            }
                        }
                    }
                }
            }

            Section {
                Button("Record New Path", systemImage: "record.circle") {
                    appModel.openRecordingView()
                }
                .tint(.red)
            }

            if isUserPath {
                Button(role: .destructive) {

                }
                .tint(.red)
                .foregroundStyle(.red)
            }
        }
        .animation(.default, value: appModel.mapItems)
        .scrollContentBackground(.hidden)
        .toolbarTitleDisplayMode(.inline)
        .navigationTitle("Bike Path")
        .toolbar {
            if isUserPath {
                ToolbarItem(placement: .primaryAction) {
                    Button("Confirm", systemImage: "checkmark") {
                        Task { @MainActor in
                            //appModel.updateManualPath(isPublic: sharePublicly)
                            appModel.cleanMap()
                            appModel.presentedSheetItem = .pathBrowsing
                        }
                    }
                    .fontWeight(.semibold)
                    .buttonStyle(.glassProminent)
                    .disabled(!hasChanged)
                    .animation(.default, value: hasChanged)
                }
            }

            ToolbarItem(placement: .cancellationAction) {
                Button(role: .cancel) {
                    Task { @MainActor in
                        appModel.cleanMap()
                        appModel.presentedSheetItem = .pathBrowsing
                    }
                }
            }
        }
        .presentationBackground(.thinMaterial)
        .interactiveDismissDisabled()

    }
}
