//
//  Photo.swift
//  ImageFeed
//
//  Created by Maksim  on 17.07.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let description: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    let fullImageUrl: String
}

extension Photo {
    init(from result: PhotoResult) {
        let dateFormatter = ISO8601DateFormatter()
        self.id = result.id
        self.size = CGSize(width: result.width, height: result.height)
        self.createdAt = dateFormatter.date(from: result.createdAt)
        self.description = result.description
        self.thumbImageURL = result.urls.thumb
        self.largeImageURL = result.urls.full
        self.isLiked = result.likedByUser
        self.fullImageUrl = result.urls.full
    }
}
