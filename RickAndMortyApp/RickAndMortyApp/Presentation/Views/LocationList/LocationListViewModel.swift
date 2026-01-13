//
//  LocationListViewModel.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI
import Combine

class LocationListViewModel: ViewModel<LocationsCoordinator>, ViewStateUpdatable {
    @Published var state: ViewState = .loading
    @Published private(set) var locations: [Location] = []

    private let apiClient: APIClient

    init(coordinator: Coordinator, apiClient: APIClient = DependencyInjector.getURLSessionAPIClient()) {
        self.apiClient = apiClient
        super.init(coordinator: coordinator)
    }

    func loadLocations() async {
        await updateViewState(.loading)

        do {
            let response: LocationListResponse = try await apiClient.send(RickAndMortyAPI.locationList())
            locations = response.results
            await updateViewState(.ready)
        } catch {
            await updateViewState(.error)
        }
    }
}
