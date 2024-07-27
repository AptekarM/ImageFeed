//
//  ProfileMock.swift
//  ImageFeedTests
//
//  Created by Maksim  on 25.07.2024.
//

import XCTest
@testable import ImageFeed

final class MockProfileService: ProfileServiceProtocol {
    var profile: Profile?
    
    func setProfile(_ profile: Profile) {
        self.profile = profile
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        if let profile = profile {
            completion(.success(profile))
        } else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Profile not set"])
            completion(.failure(error))
        }
    }
}

final class MockProfileImageService: ProfileImageServiceProtocol {
    var avatarURL: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        if let url = avatarURL {
            completion(.success(url))
        } else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL not set"])
            completion(.failure(error))
        }
    }
}

final class MockProfileLogoutService: ProfileLogoutServiceProtocol {
    var didLogout = false
    
    func logout() {
        didLogout = true
    }
}
