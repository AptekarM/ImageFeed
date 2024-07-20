//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Maksim  on 04.07.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private init() {}
    
    func saveToken(_ token: String) {
        let isSuccess = KeychainWrapper.standard.set(token, forKey: "oauth2_token")
        guard isSuccess else {
            print("Ошибка сохранения токена в Keychain")
            return
        }
    }
    
    func getToken() -> String? {
        return KeychainWrapper.standard.string(forKey: "oauth2_token")
    }
    
    func deleteToken() {
        let removeSuccessful = KeychainWrapper.standard.removeObject(forKey: "oauth2_token")
        if !removeSuccessful {
            print("Ошибка удаления токена из Keychain")
        }
    }
}


