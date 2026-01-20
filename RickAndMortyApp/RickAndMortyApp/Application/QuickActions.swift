//
//  QuickActions.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import UIKit

enum AppShortcut: String, CaseIterable {
    case characters
    case episodes
    case locations

    var type: String {
        "com.rickandmortyapp.shortcut.\(rawValue)"
    }

    var title: String {
        switch self {
        case .characters:
            String(localized: "shortcut_characters_title")
        case .episodes:
            String(localized: "shortcut_episodes_title")
        case .locations:
            String(localized: "shortcut_locations_title")
        }
    }

    var icon: UIApplicationShortcutIcon {
        switch self {
        case .characters:
            UIApplicationShortcutIcon(systemImageName: "person.2.fill")
        case .episodes:
            UIApplicationShortcutIcon(systemImageName: "play.square.stack.fill")
        case .locations:
            UIApplicationShortcutIcon(systemImageName: "mountain.2.fill")
        }
    }

    var destination: NavigationDestionation {
        switch self {
        case .characters:
            .characters
        case .episodes:
            .episodes
        case .locations:
            .locations
        }
    }

    var item: UIApplicationShortcutItem {
        UIApplicationShortcutItem(
            type: type,
            localizedTitle: title,
            localizedSubtitle: nil,
            icon: icon,
            userInfo: nil
        )
    }

    static func from(type: String) -> AppShortcut? {
        allCases.first { $0.type == type }
    }
}

enum QuickActionCenter {
    private static var pendingDestination: NavigationDestionation?
    static var handler: ((NavigationDestionation) -> Void)?

    static func updateAppShortcuts() {
        UIApplication.shared.shortcutItems = AppShortcut.allCases.map { $0.item }
    }

    static func handle(shortcutItem: UIApplicationShortcutItem) -> Bool {
        guard let shortcut = AppShortcut.from(type: shortcutItem.type) else {
            return false
        }

        if let handler {
            handler(shortcut.destination)
        } else {
            pendingDestination = shortcut.destination
        }
        return true
    }

    static func consumePendingDestinationIfExists() {
        guard let destination = pendingDestination, let handler else {
            return
        }
        pendingDestination = nil
        handler(destination)
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        QuickActionCenter.updateAppShortcuts()
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}

final class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let shortcutItem = connectionOptions.shortcutItem {
            _ = QuickActionCenter.handle(shortcutItem: shortcutItem)
        }
    }

    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        let handled = QuickActionCenter.handle(shortcutItem: shortcutItem)
        completionHandler(handled)
    }
}
