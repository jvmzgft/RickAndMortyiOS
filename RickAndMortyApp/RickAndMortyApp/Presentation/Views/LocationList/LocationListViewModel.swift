//
//  LocationListViewModel.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI
import Combine

class LocationListViewModel: ViewModel<LocationsCoordinatorProtocol>, ViewStateUpdatable {
    @Published var state: ViewState = .loading
    @Published private(set) var locations: [Location] = []
    @Published private(set) var isLoadingNextPage = false

    private let apiClient: APIClient
    private var currentPage = 1
    private var hasNextPage = false

    init(coordinator: Coordinator, apiClient: APIClient = DependencyInjector.getURLSessionAPIClient()) {
        self.apiClient = apiClient
        super.init(coordinator: coordinator)
    }

    func loadLocations() async {
        await updateViewState(.loading)

        do {
            let response: LocationListResponse = try await apiClient.send(RickAndMortyAPI.locationList(page: currentPage))
            locations = response.results
            hasNextPage = response.info.next != nil
            await updateViewState(.ready)
        } catch {
            await updateViewState(.error)
        }
    }

    func loadNextPageIfNeeded(currentItem: Location) async {
        guard state == .ready else { return }
        guard hasNextPage, !isLoadingNextPage else { return }
        guard currentItem.id == locations.last?.id else { return }

        isLoadingNextPage = true
        currentPage += 1

        do {
            let response: LocationListResponse = try await apiClient.send(RickAndMortyAPI.locationList(page: currentPage))
            locations.append(contentsOf: response.results)
            hasNextPage = response.info.next != nil
        } catch {
            hasNextPage = false
        }

        isLoadingNextPage = false
    }

    func selectLocation(_ location: Location) {
        getCoordinator()?.navigateToDetail(location: location)
    }
}
