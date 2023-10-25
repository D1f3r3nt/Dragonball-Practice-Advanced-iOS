//
//  ApiProvider.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 11/10/23.
//

import Foundation

// MARK: - Delegate -
protocol ApiProviderProtocol {
    func login(for user: String, with password: String)
    func getHeroes(by name: String?, token: String, completion: ((Heroes) -> Void)?)
    func getLocations(by heroId: String?, token: String, completion: ((HeroLocations) -> Void)?)
}

class ApiProvider: ApiProviderProtocol {
    
    private let apiBaseURL = "https://dragonball.keepcoding.education/api"
    
    private enum Endpoint {
        static let login = "/auth/login"
        static let heroes = "/heros/all"
        static let heroLocations = "/heros/locations"
    }
    
    // MARK: - Login -
    func login(for user: String, with password: String) {
        guard let url = URL(string: "\(apiBaseURL)\(Endpoint.login)") else {
            return
        }
        
        guard let loginData = String(format: "%@:%@", user, password)
            .data(using: .utf8)?.base64EncodedString() else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let data,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                NotificationCenter.default.post(
                    name: NotificationCenter.apiProviderNotification,
                    object: nil,
                    userInfo: [NotificationCenter.tokenKey: nil]
                )
                return
            }
            
            guard let responseData = String(data: data, encoding: .utf8) else {
                return
            }
            
            NotificationCenter.default.post(
                name: NotificationCenter.apiProviderNotification,
                object: nil,
                userInfo: [NotificationCenter.tokenKey: responseData]
            )
        }.resume()
    }
    
    // MARK: - Get Heroes -
    func getHeroes(by name: String?, token: String, completion: ((Heroes) -> Void)?) {
        guard let url = URL(string: "\(apiBaseURL)\(Endpoint.heroes)") else {
            return
        }
        
        let jsonData: [String: Any] = ["name": name ?? ""]
        let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        urlRequest.httpBody = jsonParameters
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion?([])
                return
            }
            
            guard let data,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion?([])
                return
            }
            
            guard let heroes = try? JSONDecoder().decode(Heroes.self, from: data) else {
                completion?([])
                return
            }
            
            completion?(heroes)
            
        }.resume()
    }
    
    // MARK: - Get Locations -
    func getLocations(by heroId: String?, token: String, completion: ((HeroLocations) -> Void)?) {
        guard let url = URL(string: "\(apiBaseURL)\(Endpoint.heroLocations)") else {
            return
        }
        
        let jsonData: [String: Any] = ["id": heroId ?? ""]
        let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        urlRequest.httpBody = jsonParameters
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion?([])
                return
            }
            
            guard let data,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion?([])
                return
            }
            
            guard let heroes = try? JSONDecoder().decode(HeroLocations.self, from: data) else {
                completion?([])
                return
            }
            
            completion?(heroes)
            
        }.resume()
    }
}

extension NotificationCenter {
    static let apiProviderNotification = Notification.Name("NotificationApiProvider")
    static let tokenKey = "TOKEN"
}
