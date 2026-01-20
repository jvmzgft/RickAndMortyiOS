//
//  String+Extension.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 15/1/26.
//

import Foundation

extension String {
    func asLastPathComponent() -> String? {
        let trimmed = self.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return trimmed.split(separator: "/").last.map(String.init)
    }

    var localized: String {
        String(localized: .init(self))
    }
}
