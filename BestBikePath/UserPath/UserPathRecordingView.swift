//
//  UserPathRecordingView.swift
//  BestBikePath
//
//  Created by Lorenzo Fiamingo on 06/11/25.
//

import MapKit
import SwiftUI
import Combine
import AsyncButton
import WeatherKit
import CoreMotion

struct UserPathRecordingView: View {

    @Environment(BestBikePathModel.self) private var appModel

    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @State private var duration: Duration = .seconds(0)

    @State private var isStarted: Bool = false

    @State private var isRecording: Bool = false

    @State private var isCompleted: Bool = false

    @State private var confirmingObstacles: [UUID] = []

    @State private var isPublic = true

    @State private var obstacleCount = 0

    @State private var performance = UserPath.Performance(
        time: Measurement<UnitDuration>(value: 0, unit: .seconds),
        distance: Measurement<UnitLength>(value: 0, unit: .meters),
        averageSpeed: Measurement<UnitSpeed>(value: 0, unit: .kilometersPerHour),
        peakSpeed: Measurement<UnitSpeed>(value: 0, unit: .kilometersPerHour)
    )

    @State var currentSpeed = Measurement<UnitSpeed>(value: 0, unit: .kilometersPerHour)

    @State private var weather: UserPath.Weather?

    @State private var weatherSerice = WeatherService()

    let buttonFontPointSize: CGFloat = 40

    var needsHours: Bool {
        duration >= .seconds(60*60)
    }

    var isTimerLarge: Bool {
        confirmingObstacles.isEmpty && (isRecording || !isStarted)
    }

    @State private var locationMonitoringTask: Task<Void, Never>?

    @State private var isCycling: Bool = false
    @State private var activityMonitoringTask: Task<Void, Never>?

    @State private var obstacleMonitoringTask: Task<Void, Never>?

    var pathStatus: PathStatus {
        PathStatus(obstaclesCount: obstacleCount, distance: performance.distance)
    }

    var pathStatusText: Text {
        switch pathStatus {
        case .impassable:
            Text("Impassable")
        case .poor:
            Text("Poor")
        case .fair:
            Text("Fair")
        case .good:
            Text("Good")
        case .excellent:
            Text("Excellent")
        }
    }

    var weatherCard: some View {
        VStack {
            if let weather {
                LabeledContent("Condition", value: weather.condition.description)
                Divider()
                LabeledContent("Temperature", value: weather.temperature.formatted())
                Divider()
                LabeledContent("Humidity", value: weather.humidity.formatted())
                Divider()
                LabeledContent("Wind Speed", value: weather.windSpeed.formatted())
            }
        }
        .overlay(alignment: .bottomTrailing) {

        }
        .task {
            guard let location = appModel.locationManager.manager.location else { return }
            if let currentWeather = try? await weatherSerice.weather(for: location).currentWeather {
                self.weather = UserPath.Weather(
                    condition: currentWeather.condition,
                    temperature: currentWeather.temperature,
                    humidity: Measurement<UnitPercent>(value: currentWeather.humidity, unit: .percent),
                    windSpeed: currentWeather.wind.speed
                )
            }
        }
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
                        .onChange(of: isStarted, initial: true) {
                            if isStarted {
                                appModel.mapCoordinator.monitoredLocations.removeAll()
                                locationMonitoringTask = Task {
                                    for await locations in appModel.locationManager.locationsStream where isRecording {
                                        appModel.mapCoordinator.monitoredLocations += locations.filter { $0.horizontalAccuracy < 20 }
                                        updatePerformanceMetrics()
                                    }
                                }
                                activityMonitoringTask = Task {
                                    for await activity in appModel.motionManager.motionActivityStream {
                                        let wasCycling = isCycling
                                        isCycling = activity?.cycling == true
                                        if isCycling != wasCycling {
                                            isRecording = isCycling
                                        }
                                    }
                                }
                                obstacleMonitoringTask = Task {
                                    for await detection in appModel.motionManager.obstacleDetectionStream {
                                        confirmingObstacles.append(detection)
                                    }
                                }
                            }
                        }

                    if confirmingObstacles.isEmpty {
                        Group {
                            if isStarted {
                                VStack {
                                    LabeledContent("Covered Distance", value: performance.distance.formatted())
                                    if isRecording {
                                        Divider()
                                        LabeledContent("Current Speed", value: currentSpeed.formatted())
                                    }
                                    Divider()
                                    LabeledContent("Average Speed", value: performance.averageSpeed.formatted())
                                    Divider()
                                    LabeledContent("Peak Speed", value: performance.peakSpeed.formatted())
                                }
                                .animation(.default, value: isRecording)
                            }

                            weatherCard

                            if isCompleted {
                                VStack {
                                    LabeledContent("Path Status") { pathStatusText }
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
                                    obstacleCount += 1
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
            .customOpacityVisualEffect()
            .safeAreaInset(edge: .bottom) {
                VStack {
                    if isStarted && !isCompleted {
                        Button("Add obstacle") {
                            confirmingObstacles.append(UUID())
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.extraLarge)
                        .buttonSizing(.flexible)
                        .fontWeight(.semibold)
                    }

                    if isCompleted {
                        AsyncButton {
                            try await saveUserPath()
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
                                Task {
                                    isCompleted = true
                                    locationMonitoringTask?.cancel()
                                    activityMonitoringTask?.cancel()
                                    obstacleMonitoringTask?.cancel()
                                    var mapCoordinator = appModel.mapCoordinator
                                    try await mapCoordinator.setHighlightedRoutesFromMonitoredLocations()
                                    appModel.mapCoordinator = mapCoordinator
                                    appModel.mapCoordinator.mapCameraPosition = .automatic
                                }
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
                    appModel.presentedSheetItem = .communityPathSearch
                }
            }
    }

    func updatePerformanceMetrics() {
        let locations = appModel.mapCoordinator.monitoredLocations
        guard !locations.isEmpty else { return }
        let distance = locations.totalDistance()
        let speeds = appModel.mapCoordinator.monitoredLocations.map(\.speed)
        let currentSpeed = speeds.last!
        let maxSpeed = speeds.max() ?? 0
        let averageSpeed = speeds.reduce(0, +) / Double(speeds.count)

        performance.distance = Measurement(value: distance, unit: .meters)
        performance.peakSpeed = Measurement(value: maxSpeed, unit: .metersPerSecond)
        performance.averageSpeed = Measurement(value: averageSpeed, unit: .metersPerSecond)
        self.currentSpeed = Measurement(value: currentSpeed, unit: .metersPerSecond)
    }

    func saveUserPath() async throws {
        performance.time = Measurement(value: Double(duration.components.seconds), unit: .seconds)
        var mapCoordinator = self.appModel.mapCoordinator
        let path = mapCoordinator.makePathFromHighlightedRoutes()
        appModel.mapCoordinator = mapCoordinator
        guard let currentUserID = appModel.userSource.currentUser?.id else {
            throw UnauthenticatedCurrentUserError()
        }
        let userPath = UserPath(
            id: UUID().uuidString,
            userId: currentUserID,
            date: .now,
            isPublic: isPublic,
            path: path,
            status: pathStatus,
            performance: performance
        )
        try await appModel.userPathSource.saveUserPath(userPath)
        await appModel.syncCurrentUserPaths()
        appModel.mapCoordinator.reset()
        appModel.presentedSheetItem = .communityPathSearch
    }
}

private extension View {
    func customOpacityVisualEffect(isEnabled: Bool = true) -> some View {
        visualEffect { content, geometry in
            let height = geometry.size.height + geometry.safeAreaInsets.bottom
            let opacity: CGFloat = if height < 250 {
                0
            } else if height < 300 {
                (height-250)/50
            } else {
                1
            }
            return content
                .opacity(isEnabled ? opacity : 1)
        }
    }
}

#Preview {
    NavigationStack {
        UserPathRecordingView()
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

private extension Array where Element == CLLocation {

    func totalDistance() -> CLLocationDistance {
        var total: CLLocationDistance = 0

        // We iterate from the second element to the end
        for i in 1..<self.count {
            if i > 0 {
                let previousLocation = self[i-1]
                let currentLocation = self[i]
                total += currentLocation.distance(from: previousLocation)
            }
        }

        return total
    }
}
