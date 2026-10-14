//
//  LocationDetailsViewModel.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 15/1/26.
//

import Foundation
import Observation

@Observable
class LocationDetailsViewModel: ViewModel<NavigatingProtocol>, ViewStateUpdatable {
    var state: ViewState = .loading
    private(set) var location: Location?

    private let useCase: GetLocationDetailUseCase?
    private let locationId: String?

    init(location: Location, coordinator: NavigatingCoordinator) {
        self.location = location
        self.locationId = nil
        self.useCase = nil
        super.init(coordinator: coordinator)
        self.state = .ready
    }
    
    init(
        id: String?,
        coordinator: NavigatingCoordinator,
        useCase: GetLocationDetailUseCase = DependencyInjector.getLocationDetailUseCase()
    ) {
        self.location = nil
        self.locationId = id
        self.useCase = useCase
        super.init(coordinator: coordinator)
    }

    func loadLocationIfNeeded() async {
        guard location == nil else {
            await updateViewState(.ready)
            return
        }

        await updateViewState(.loading)

        guard let useCase, let locationId else {
            await updateViewState(.error)
            return
        }

        do {
            let response = try await useCase.handle(locationId)
            location = response
            await updateViewState(.ready)
        } catch {
            await updateViewState(.error)
        }
    }

    func handleResidentTap(_ characterId: String) {
        getCoordinator()?.navigateTo(.characterDetail(nil, id: characterId))
    }

    func handleSeeAllCharacters() {
        getCoordinator()?.handleDeeplink(destination: .characters)
    }
    
    func clearPath() {
        getCoordinator()?.clearPath()
    }
}
