//
//  AppDelegate.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 21/01/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        startAppCoordinator()
        return true
    }
    
    private func startAppCoordinator() {
        let requestManager = RequestManager()
        appCoordinator = AppCoordinator(requestManager: requestManager)
        appCoordinator.start()
        
    }
}

