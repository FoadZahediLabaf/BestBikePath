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

    @State private var rate: Double = 1

    @State private var sharePublicly = true

    @State private var hasChanged = false

    var isUserPath: Bool = false

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

            Section {
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

            Section("Directions") {
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
                            appModel.presentedRootModal = .searchCommunityPaths
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
                        appModel.presentedRootModal = .searchCommunityPaths
                    }
                }
            }
        }
        .presentationBackground(.thinMaterial)
        .interactiveDismissDisabled()

    }
}
