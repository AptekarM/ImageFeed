//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Maksim  on 09.07.2024.
//

import Foundation

final class ProfileService: ProfileServiceProtocol {
    static let shared = ProfileService()
    
    private init() {}
    
    struct ProfileResult: Codable {
        let username: String
        let first_name: String
        let last_name: String?
        let bio: String?
    }
    
    private(set) var profile: Profile?
    
    func setProfile(_ profile: Profile) {
        self.profile = profile
    }
    
    private func createProfileRequest(with token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let request = createProfileRequest(with: token) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid request"])
            print("[fetchProfile]: InvalidRequest - Неверный запрос")
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[fetchProfile]: NetworkError - \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "Invalid response", code: -1, userInfo: nil)
                print("[fetchProfile]: InvalidResponse - Недопустимый ответ сервера")
                completion(.failure(error))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "HTTP error", code: httpResponse.statusCode, userInfo: nil)
                print("[fetchProfile]: HTTPError - Ошибка HTTP: \(httpResponse.statusCode)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "No data", code: -1, userInfo: nil)
                print("[fetchProfile]: NoData - Отсутствуют данные в ответе")
                completion(.failure(error))
                return
            }
            
            do {
                let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                let profile = Profile(from: profileResult)
                self.setProfile(profile)
                completion(.success(profile))
            } catch {
                print("[fetchProfile]: DecodingError - Ошибка декодирования: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
