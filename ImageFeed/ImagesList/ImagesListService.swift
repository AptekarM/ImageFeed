//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Maksim  on 16.07.2024.
//

import Foundation

final class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    var photos: [Photo] = []
    private var currentPage = 1
    private var isLoading = false
    
    func fetchPhotosNextPage() {
        guard !isLoading else { return }
        
        isLoading = true
        
        let urlString = "\(Constants.defaultBaseURL)/photos?page=\(currentPage)&per_page=10"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(Constants.accessKey)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            self.isLoading = false
            
            if let data = data, let response = try? JSONDecoder().decode([PhotoResult].self, from: data) {
                let newPhotos = response.map { Photo(from: $0) }
                
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: newPhotos)
                    self.currentPage += 1
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                }
            }
        }
        
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = OAuth2TokenStorage.shared.getToken() else {
            let error = NSError(domain: "OAuth2TokenStorage Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "No token available"])
            completion(.failure(error))
            return
        }
        
        let endpoint = "/photos/\(photoId)/like"
        let url = Constants.defaultBaseURL.appendingPathComponent(endpoint)
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else {return}
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "Invalid response", code: -1, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            // Update photo in the array with inverted isLiked value
            if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                var updatedPhotos = self.photos
                updatedPhotos[index].isLiked = !self.photos[index].isLiked
                
                DispatchQueue.main.async {
                    self.photos = updatedPhotos
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                }
            }
            
            completion(.success(()))
        }.resume()
    }
    
    func getPhotos() -> [Photo] {
        return photos
    }
}
