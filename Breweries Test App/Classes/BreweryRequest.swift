//
//  BreweryRequest.swift
//  Breweries Test App
//
//  Created by Dmytro Nechuyev on 08.06.2021.
//

import Foundation

enum RequestError: Error {
    case custom(errorMessage: String)
}

struct Breweries: Codable {
    let breweries: [Brewery]?
}

struct Brewery: Codable, Hashable {
    let id: Int?
    let name: String?
    let brewery_type: String?
    let street: String?
    let address_2: String?
    let address_3: String?
    let city: String?
    let state: String?
    let country_province: String?
    let postal_code: String?
    let country: String?
    let longitude: String?
    let latitude: String?
    let phone: String?
    let website_url: String?
    let updated_at: String?
    let created_at: String?
}

class BreweryRequest {
    
    func allBreweries(page: Int = 1, completion: @escaping (Result<[Brewery], RequestError>) -> Void) {
        
        guard let breweriesURL = URL(string: "https://api.openbrewerydb.org/breweries?page=\(page)") else {
            completion(.failure(.custom(errorMessage: "URL request error.")))
            return
        }
        
        var requestBreweries = URLRequest(url: breweriesURL)
        requestBreweries.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: requestBreweries) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(.custom(errorMessage: "Breweries request error.")))
                return
            }

            guard let breweriesArr = try? JSONDecoder().decode([Brewery].self, from: data) else {
                completion(.failure(.custom(errorMessage: "Json decode error.")))
                return
            }

            completion(.success(breweriesArr))

        }.resume()
        
    }
    
    func search(query: String, completion: @escaping (Result<[Brewery], RequestError>) -> Void) {
        
        guard let breweriesURL = URL(string: "https://api.openbrewerydb.org/breweries/search?query=\(query)") else {
            completion(.failure(.custom(errorMessage: "URL request error.")))
            return
        }
        
        var requestBreweries = URLRequest(url: breweriesURL)
        requestBreweries.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: requestBreweries) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(.custom(errorMessage: "Breweries request error.")))
                return
            }

            guard let breweriesArr = try? JSONDecoder().decode([Brewery].self, from: data) else {
                completion(.failure(.custom(errorMessage: "Json decode error.")))
                return
            }

            completion(.success(breweriesArr))

        }.resume()
        
    }
}
