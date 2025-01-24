//
//  AppDelegate.swift
//  Earworm
//
//  Created by Hugo Pinheiro  on 24/01/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let networkService = NetworkService()
        networkService.fetchRSS(from: "https://feeds.megaphone.fm/la-cotorrisa") { result in
            switch result {
            case .success(let feed):
                print("Title: \(feed.title)")
                print("Description: \(feed.description)")
                print("Episodes: \(feed.episodes.map { $0.title })")
            case .failure(let error):
                print("Error fetching RSS: \(error.localizedDescription)")
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

