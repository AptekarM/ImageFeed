//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Maksim  on 04.07.2024.
//

import Foundation

final class OAuth2TokenStorage {
    var token: String?
    
    static let shared = OAuth2TokenStorage()

    private init() {}

    func saveToken(_ token: String) {
            UserDefaults.standard.set(token, forKey: "oauth2_token")
    }

    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: "oauth2_token")
    }
}


