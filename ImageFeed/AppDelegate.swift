//
//  AppDelegate.swift
//  ImageFeed
//
//  Created by Maksim  on 02.05.2024.
//

import UIKit
import ProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Стилизуем ProgressHUD
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.colorHUD = .black
        ProgressHUD.colorAnimation = .lightGray
        
        return true
    }
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(
            name: "Main",
            sessionRole: connectingSceneSession.role
        )
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
}
