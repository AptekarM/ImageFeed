//
//  Constants.swift
//  ImageFeed
//
//  Created by Maksim  on 13.06.2024.
//

import Foundation

enum Constants {
    static let accessKey = "GdTlxG2sJeSXUFOe2mCXKp5DJfNNZV9qXl66UGLeB84"
    static let secretKey = "FJkBVPX13fFoQbmICnUp-OJOLTdZQg7HMMP93qYXhE4"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            authURLString: Constants.UnsplashAuthorizeURLString,
            defaultBaseURL: Constants.defaultBaseURL
        )
    }
}
