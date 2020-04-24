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
    let file =  "search-terms"
    
    var keySearchTerms = [String]()
    var searchInput = [String]()
    var searching = false
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        tableView.isHidden = true
        

        keySearchTerms = keyTerms()
        print(keySearchTerms.count)
        
        searchBar.showsCancelButton = false
    
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
        
        let resourceURL = "https://superheroapi.com/api/\(apiToken)/70"
        
          let urlString = resourceURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! //allows empty spaces for adding the %20
        
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
    
    
   
    func keyTerms() -> [String]{
        
        let path = Bundle.main.path(forResource: file, ofType: "txt")
        
        do {
            let file = try String(contentsOfFile: path!)
            let text: [String] = file.components(separatedBy:.newlines)
            let trimmedArray = text.map { $0.trimmingCharacters(in: .whitespaces)}
            print(trimmedArray)

            return trimmedArray
            
        } catch let err {
            print(err)
        }
        return [String]()

    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchInput.count
        } 
        return 0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if searching {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SuperHeroCell", for: indexPath) as? SuperHeroCell {
                let name = searchInput [indexPath.row]
                cell.updateView(name: name)
                return cell
            }
            
        }
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "SuperHeroCell", for: indexPath) as? SuperHeroCell{
//            let name = keySearchTerms[indexPath.row]
//            cell.updateView(name: name)
//
//
//
//        }
        
           return UITableViewCell()
    
        
       }
   
}












extension HomeVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //set the auto complete here https://www.youtube.com/watch?v=wVeX68Iu43E
        
         searchBar.showsCancelButton = true
        searching = true
        searchInput = keySearchTerms.filter({
            $0.prefix(searchText.count) == searchText
        })
        
           tableView.isHidden = false
        tableView.reloadData()
     
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true
        
        if let searchText = searchBar.text {
            searchQuery = searchText
            print(searchQuery)
            
        
        }
        searchBar.endEditing(true)
        
        tableView.isHidden = false
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        tableView.reloadData()
        searching = false
        searchBar.showsCancelButton = false
        tableView.isHidden = true
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    
   
    
    
  
    
  
    
}
