//
//  LocationDetailsViewModel.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 15/1/26.
//

import Foundation
import Observation

@Observable
class LocationDetailsViewModel: ViewModel<DetailNavigatingProtocol>, ViewStateUpdatable {
    var state: ViewState = .loading
    private(set) var location: Location?

    private let apiClient: APIClient?
    private let locationId: String?

    init(location: Location, coordinator: Coordinator) {
        self.location = location
        self.locationId = nil
        self.apiClient = nil
        super.init(coordinator: coordinator)
        self.state = .ready
    }

    init(id: String?, coordinator: Coordinator, apiClient: APIClient = DependencyInjector.getURLSessionAPIClient()) {
        self.location = nil
        self.locationId = id
        self.apiClient = apiClient
        super.init(coordinator: coordinator)
    }

    func loadLocationIfNeeded() async {
        guard location == nil else {
            await updateViewState(.ready)
            return
        }

        await updateViewState(.loading)

        guard let apiClient, let locationId else {
            await updateViewState(.error)
            return
        }

        do {
            let response: Location = try await apiClient.send(RickAndMortyAPI.location(id: locationId))
            location = response
            await updateViewState(.ready)
        } catch {
            await updateViewState(.error)
        }
    }

    func handleResidentTap(_ characterId: String) {
        getCoordinator()?.navigateToDetail(.characterDetail(nil, id: characterId))
    }
}
