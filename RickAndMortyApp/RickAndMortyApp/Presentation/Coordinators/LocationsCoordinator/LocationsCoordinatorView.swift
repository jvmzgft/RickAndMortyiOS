//
//  LocationsCoordinatorView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI

struct LocationsCoordinatorView: View {
    @StateObject var coordinator: LocationsCoordinator
    @StateObject private var path: LocationsPath

    init(coordinator: LocationsCoordinator) {
        _coordinator = StateObject(wrappedValue: coordinator)
        _path = StateObject(wrappedValue: coordinator.myCharacterPath)
    }

    var body: some View {
        NavigationStack(path: $path.path) {
            locationListView()
                .navigationDestination(for: LocationsViewSpec.self) { spec in
                    switch spec {
                    case .list:
                        locationListView()
                    case let .detail(location):
                        LocationDetailsView(location: location)
                    }
                }
        }
    }

    @ViewBuilder
    private func locationListView() -> some View {
        LocationListView(viewModel: LocationListViewModel(coordinator: coordinator))
    }
}
