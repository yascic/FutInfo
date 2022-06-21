//
//  NetworkManager.swift
//  FutInfo
//
//  Created by Yahya Aščić on 15.05.22.
//

import UIKit
import SVGKit

class NetworkManager {
    private let baseURL = "https://api.football-data.org/v2/"
    private let apiKey = "e1b7cc7d3aa14cf19dd9845458d4b503"
    private let session = URLSession.shared
    private let cache = NSCache<NSString, UIImage>()
    
    static let shared = NetworkManager()

    private init() {}
    
    func getLatestStandings(withId id: Int, completed: @escaping (Result<[TeamStanding], Error>) -> ()) {
        let endpoint = baseURL + "/competitions/\(id)/standings"
        let request = URLRequest(url: URL(string: endpoint)!)
        
        fetchData(request: request) { (result: Result<StandingResponse, Error>) in
            switch result {
            case .success(let response):
                if let standing = response.standings?.first {
                    completed(.success(standing.table))
                } else {
                    completed(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Not found"])))
                }
            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
    
    func getTeamDetails(fromId id: Int, completed: @escaping (Result<Team, Error>) -> ()) {
        let endpoint = baseURL + "/teams/\(id)"
        let request = URLRequest(url: URL(string: endpoint)!)

        fetchData(request: request, completion: completed)
    }
    
    private func fetchData<D: Decodable>(request: URLRequest, completion: @escaping(Result<D, Error>) -> ()) {
        var urlRequest = request
        urlRequest.addValue(apiKey, forHTTPHeaderField: "X-Auth-Token")
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data not found"])
                completion(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let d = try decoder.decode(D.self, from: data)
                completion(.success(d))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func downloadImage(from stringUrl: String, completed: @escaping (UIImage?) -> ()) {
        let cacheKey = NSString(string: stringUrl)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: stringUrl) else {
            completed(nil)
            return
        }
        
        session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data else {
                completed(nil)
                return
            }
            
            var image: UIImage?
            if url.absoluteString.hasSuffix("svg") {
                image = SVGKImage(data: data).uiImage
            } else {
                image = UIImage(data: data)
            }
            
            guard let logo = image else {
                return
            }
            
            self.cache.setObject(logo, forKey: cacheKey)
            completed(image)
        }.resume()
    }
}
