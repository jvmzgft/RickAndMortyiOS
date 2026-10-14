//
//  LocationListViewModel.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 13/1/26.
//

import SwiftUI
import Observation

@Observable
class LocationListViewModel: ViewModel<NavigatingProtocol>, ViewStateUpdatable {
    var state: ViewState = .loading
    private(set) var locations: [Location] = []
    private(set) var isLoadingNextPage = false

    private let useCase: GetLocationListUseCase
    private var currentPage = 1
    private var hasNextPage = false

    init(
        coordinator: NavigatingCoordinator,
        useCase: GetLocationListUseCase = DependencyInjector.getLocationListUseCase()
    ) {
        self.useCase = useCase
        super.init(coordinator: coordinator)
    }

    func loadLocations() async {
        await updateViewState(.loading)

        do {
            let response = try await useCase.handle(currentPage)
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
            let response = try await useCase.handle(currentPage)
            locations.append(contentsOf: response.results)
            hasNextPage = response.info.next != nil
        } catch {
            hasNextPage = false
        }

        isLoadingNextPage = false
    }

    func selectLocation(_ location: Location) {
        getCoordinator()?.navigateTo(.locationDetail(location, id: nil))
    }
}
