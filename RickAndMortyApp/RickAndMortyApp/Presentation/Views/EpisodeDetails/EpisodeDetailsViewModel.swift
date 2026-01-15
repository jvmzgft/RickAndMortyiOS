//
//  EpisodeDetailsViewModel.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 15/1/26.
//

import Foundation
import Combine

class EpisodeDetailsViewModel: ViewModel<EpisodesCoordinatorProtocol> {
    let episode: Episode
    
    init(episode: Episode, coordinator: Coordinator) {
        self.episode = episode
        super.init(coordinator: coordinator)
    }

    func handleCharacterTap(_ characterId: String) {
        print("\(characterId) tapped")
        getCoordinator()?.navigateToCharacterDetail(id: characterId)
    }

}
