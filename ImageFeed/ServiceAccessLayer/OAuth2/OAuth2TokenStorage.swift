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
    
    private let keychainWrapper = KeychainWrapper.standard
    private let tokenKey = "oauth2_token"
    
    private init() {}
    
    func saveToken(_ token: String) {
        keychainWrapper.set(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        return keychainWrapper.string(forKey: tokenKey)
    }
}
