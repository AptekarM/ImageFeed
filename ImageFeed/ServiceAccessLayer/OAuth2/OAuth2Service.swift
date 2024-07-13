//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Maksim  on 04.07.2024.
//

import Foundation

class OAuth2Service {
    static let shared = OAuth2Service()

    private let operationQueue = OperationQueue()
    private var currentTokenRequest: TokenRequestOperation?

    private init() {
        operationQueue.maxConcurrentOperationCount = 1
    }

    func fetchAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        cancelTokenRequest()
        
        let newRequest = TokenRequestOperation(code: code) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        currentTokenRequest = newRequest
        operationQueue.addOperation(newRequest)
    }

    func objectTask<T: Codable>(for request: URLRequest, objectType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "Invalid response", code: -1, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "HTTP error", code: httpResponse.statusCode, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "No data", code: -1, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func cancelTokenRequest() {
        currentTokenRequest?.cancel()
    }
}
class TokenRequestOperation: Operation {
    private let code: String
    private let completion: (Result<String, Error>) -> Void
    
    init(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        self.code = code
        self.completion = completion
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        guard let url = URL(string: "https://unsplash.com/oauth/token") else {
            let error = NSError(domain: "Invalid URL", code: -1, userInfo: nil)
            completion(.failure(error))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyParameters = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": Constants.redirectURI,
            "client_id": Constants.accessKey,
            "client_secret": Constants.secretKey
        ]
        
        guard let httpBody = bodyParameters
            .map({ "\($0.key)=\($0.value)" })
            .joined(separator: "&")
            .data(using: .utf8) else {
                let error = NSError(domain: "Invalid HTTP body", code: -1, userInfo: nil)
                completion(.failure(error))
                return
        }
        request.httpBody = httpBody

        OAuth2Service.shared.objectTask(for: request, objectType: OAuthTokenResponseBody.self) { (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let responseBody):
                self.completion(.success(responseBody.accessToken))
            case .failure(let error):
                self.completion(.failure(error))
            }
        }
    }
}
