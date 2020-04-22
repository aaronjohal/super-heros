//
//  ViewController.swift
//  super-heroes
//
//  Created by Aaron Johal on 22/04/2020.
//  Copyright © 2020 Aaron Johal. All rights reserved.
//

import UIKit



struct Hero: Codable {
    let id: String
    let name: String
    let powerstats: [String: String]
    let image: [String: String]

}

struct Powers: Codable {
    let intelligence: String
    let strength : String
    let speed: String
    let durability: String
    let power: String
    let combat: String
    
}

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var hero: Hero?
 
    
    let apiToken = "10156904415931574"
    var searchQuery = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
       //let x =  arrayFromContentsOfFileWithName(fileName: "search-terms")

       // print(x)
        

        fetchHeroJSON { (res) in
            switch res {
            case .success(let hero): //would use a for-Each if we were dealing with arrays
                self.hero = hero
                    print(self.hero!)


            case .failure(let err):
                print("failed to fetch hero", err)
            }
        }

    }
    
    
    //https://www.youtube.com/watch?v=9iazQQdNoNU
    func fetchHeroJSON(completion: @escaping (Result<Hero, Error>) -> ()){
        
        let urlString = "https://superheroapi.com/api/\(apiToken)/70"
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
           
            if let err = err {
                completion(.failure(err)) //call completion method with nil for no Hero object
                return
            }
            //successful
            
            do {
                 let hero = try JSONDecoder().decode(Hero.self, from: data!)
                completion(.success(hero))
            } catch let jsonErr{
                completion(.failure(jsonErr))
            }
            
        }.resume()
    }
    
//    func arrayFromContentsOfFileWithName(fileName: String) -> [String]? {
//        guard let path = Bundle.main.path(forResource: fileName, ofType: "txt") else {
//            return nil
//        }
//
//        do {
//            let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
//            return content.components(separatedBy: "/n")
//        } catch _ as NSError {
//            return nil
//        }
//    }
    
    func keyTerms(){
    
        do {
            let path: String = "/Users/aaron.johal/Desktop/search-terms"
            let file = try String(contentsOfFile: path)
            let text: [String] = file.components(separatedBy: "\n")

            for line in text {
                Swift.print(line)
            }
        } catch let error {
            Swift.print("Fatal Error: \(error.localizedDescription)")
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 3
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           return UITableViewCell()
       }
   
}



extension HomeVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //set the auto complete here https://www.youtube.com/watch?v=wVeX68Iu43E
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let searchText = searchBar.text {
            searchQuery = searchText
            print(searchQuery)
        
        }
        
    }

    
}
