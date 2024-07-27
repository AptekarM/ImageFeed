//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Maksim  on 23.07.2024.
//

import Foundation

protocol ProfileServiceProtocol {
    var profile: Profile? { get }
    func setProfile(_ profile: Profile)
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
}

protocol ProfileImageServiceProtocol {
    var avatarURL: String? { get }
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void)
}

protocol ProfileLogoutServiceProtocol {
    func logout()
}
