//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Maksim  on 04.07.2024.
//

import Foundation

class OAuth2Service {
    static let shared = OAuth2Service()

    private init() {}

    func fetchAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://unsplash.com/oauth/token") else {
            let error = NSError(domain: "Invalid URL", code: -1, userInfo: nil)
            print("Error creating URL: \(error)")
            completion(.failure(error))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyParameters = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirectURI,
            "client_id": accessKey,
            "client_secret": secretKey
        ]
        
        guard let httpBody = bodyParameters
            .map({ "\($0.key)=\($0.value)" })
            .joined(separator: "&")
            .data(using: .utf8) else {
                let error = NSError(domain: "Invalid HTTP body", code: -1, userInfo: nil)
                print("Error creating HTTP body: \(error)")
                completion(.failure(error))
                return
        }
        request.httpBody = httpBody

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Network error: \(error)")
                    completion(.failure(error))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "Invalid response", code: -1, userInfo: nil)
                DispatchQueue.main.async {
                    print("Error casting response to HTTPURLResponse: \(error)")
                    completion(.failure(error))
                }
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "HTTP error", code: httpResponse.statusCode, userInfo: nil)
                DispatchQueue.main.async {
                    print("HTTP error with status code: \(httpResponse.statusCode), response: \(httpResponse)")
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                let error = NSError(domain: "No data", code: -1, userInfo: nil)
                DispatchQueue.main.async {
                    print("Error: No data received")
                    completion(.failure(error))
                }
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = json["access_token"] as? String {
                    DispatchQueue.main.async {
                        completion(.success(token))
                    }
                } else {
                    let error = NSError(domain: "Invalid token", code: -1, userInfo: nil)
                    DispatchQueue.main.async {
                        print("Error: Invalid token in response")
                        completion(.failure(error))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
}
