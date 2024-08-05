//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Maksim  on 13.07.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    private let imagesListService = ImagesListService()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        // Инициализация ImagesListViewController через Storyboard
        if let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController {
            // Здесь конфигурируем imagesListViewController
            imagesListViewController.imagesListService = imagesListService
            imagesListViewController.dateFormatter = dateFormatter
            
            imagesListViewController.tabBarItem = UITabBarItem(
                title: "",
                image: UIImage(named: "tab_editorial_active")?.withRenderingMode(.alwaysOriginal),
                selectedImage: nil
            )

            
            // Создание ProfileViewController с зависимостями
            let profileViewController = ProfileViewController(
                profileService: profileService,
                profileImageService: profileImageService,
                profileLogoutService: profileLogoutService
            )
            
            profileViewController.tabBarItem = UITabBarItem(
                title: "",
                image: UIImage(named: "tab_profile_active"),
                selectedImage: nil
            )
            
            // Установка viewControllers
            self.viewControllers = [imagesListViewController, profileViewController]
        }
    }
}
