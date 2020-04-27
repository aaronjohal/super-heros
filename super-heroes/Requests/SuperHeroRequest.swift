//
//  SuperHeroRequest.swift
//  super-heroes
//
//  Created by Aaron Johal on 27/04/2020.
//  Copyright © 2020 Aaron Johal. All rights reserved.
//

import Foundation

let apiToken = "10156904415931574"
private (set) public var searchedHero = ""


class SuperHeroRequest {
    
    init(searchTerm: String){
        searchedHero = searchTerm
        print(searchedHero)
    }
    
    
     //https://www.youtube.com/watch?v=9iazQQdNoNU
    func requestHeroJSON(completion: @escaping (Result<[Hero], Error>) -> ()){
        
        let resourceURL = "https://superheroapi.com/api/\(apiToken)/search/\(searchedHero)"
        print(resourceURL)
        let urlString = resourceURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! //allow empty spaces in query string
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            
            if let err = err {
                completion(.failure(err))
                return
            }
            
            // if successful
            
            do {
                let heroResults = try JSONDecoder().decode(SearchResults.self, from: data!)
                let hero = heroResults.results
                completion(.success(hero))
              
            } catch let jsonErr {
                completion(.failure(jsonErr))
            }
        }.resume()
        
        
    }
 
    
}

