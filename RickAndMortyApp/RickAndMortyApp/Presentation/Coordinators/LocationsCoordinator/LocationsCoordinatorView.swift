//
//  LocationsCoordinatorView.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI

struct LocationsCoordinatorView: View {
    @StateObject var coordinator: LocationsCoordinator

    init(coordinator: LocationsCoordinator = LocationsCoordinator()) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }

    var body: some View {
        LocationListView(viewModel: LocationListViewModel(coordinator: coordinator))
    }
}
