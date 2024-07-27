//
//  Profile.swift
//  ImageFeed
//
//  Created by Maksim  on 24.07.2024.
//

import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String
    
    init(from profileResult: ProfileService.ProfileResult) {
        self.username = profileResult.username
        self.name = "\(profileResult.first_name) \(profileResult.last_name ?? "")"
        self.loginName = "@\(profileResult.username)"
        self.bio = profileResult.bio ?? ""
    }
}
