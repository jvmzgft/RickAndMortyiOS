//
//  RickAndMortyApp.swift
//  RickAndMortyApp
//
//  Created by Martinez Montilla, Javier on 12/1/26.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    @State private var appCoordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(coordinator: appCoordinator)
                .onAppear {
                    let handleShortcut: (NavigationDestionation) -> Void = { destination in
                        Task { @MainActor in
                            appCoordinator.handleShortcut(destination: destination)
                        }
                    }
                    QuickActionCenter.handler = handleShortcut
                    QuickActionCenter.consumePendingDestinationIfExists()
                }
                .onDisappear() {
                    QuickActionCenter.handler = nil
                }
                .onChange(of: scenePhase) { _, newPhase in
                    guard newPhase == .active else {
                        return
                    }
                    QuickActionCenter.updateAppShortcuts()
                }
        }
    }
}
