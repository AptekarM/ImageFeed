//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Maksim  on 07.07.2024.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private init() {}
    
    private let tokenStorage = OAuth2TokenStorage.shared
    private var currentTask: URLSessionDataTask?
    
    struct UserResult: Codable {
        struct ProfileImage: Codable {
            let small: String
        }
        let profile_image: ProfileImage
    }
    
    private(set) var avatarURL: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        currentTask?.cancel()
        
        guard let token = tokenStorage.getToken() else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Token not found"])
            print("[fetchProfileImageURL]: TokenNotFound - Токен не найден")
            completion(.failure(error))
            return
        }
        
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            print("[fetchProfileImageURL]: InvalidURL - Недопустимый URL")
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[fetchProfileImageURL]: NetworkError - \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "Invalid response", code: -1, userInfo: nil)
                print("[fetchProfileImageURL]: InvalidResponse - Недопустимый ответ сервера")
                completion(.failure(error))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "HTTP error", code: httpResponse.statusCode, userInfo: nil)
                print("[fetchProfileImageURL]: HTTPError - Ошибка HTTP: \(httpResponse.statusCode)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "No data", code: -1, userInfo: nil)
                print("[fetchProfileImageURL]: NoData - Отсутствуют данные в ответе")
                completion(.failure(error))
                return
            }
            
            do {
                let userResult = try JSONDecoder().decode(UserResult.self, from: data)
                let profileImageURL = userResult.profile_image.small
                self.avatarURL = profileImageURL
                
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": profileImageURL]
                )
                
                completion(.success(profileImageURL))
            } catch {
                print("[fetchProfileImageURL]: DecodingError - Ошибка декодирования: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
        currentTask = task
    }
}
