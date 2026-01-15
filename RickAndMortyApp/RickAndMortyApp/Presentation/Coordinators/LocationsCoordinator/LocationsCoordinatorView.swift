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
        _path = StateObject(wrappedValue: coordinator.myLocationsPath)
    }

    var body: some View {
        NavigationStack(path: $path.path) {
            ViewFactory.makeView(for: .locationList, coordinator: coordinator)
                .navigationDestination(for: AppViewSpec.self) { spec in
                    ViewFactory.makeView(for: spec, coordinator: coordinator)
                }
        }
    }
}
