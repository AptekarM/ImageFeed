//
//  ImageListMock.swift
//  ImageFeedTests
//
//  Created by Maksim  on 25.07.2024.
//

import XCTest
@testable import ImageFeed
import Foundation


class MockImagesListService: ImagesListService {
    var mockPhotos: [Photo] = []

    override func fetchPhotosNextPage() {
        self.photos = mockPhotos
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
    }

    override func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        if let index = photos.firstIndex(where: { $0.id == photoId }) {
            photos[index].isLiked.toggle()
            NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "Photo not found", code: -1, userInfo: nil)))
        }
    }
}
