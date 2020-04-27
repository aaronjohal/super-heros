//
//  ViewController.swift
//  super-heroes
//
//  Created by Aaron Johal on 22/04/2020.
//  Copyright © 2020 Aaron Johal. All rights reserved.
//

import UIKit





class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var hero: Hero?
 
    
    let apiToken = "10156904415931574"
    var searchQuery = ""
    let file =  "search-terms"
    
    var herosSearchList = [String]()
    var searchInput = [String]()
    var isSearching = false
    var searchTermSelected = ""
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        tableView.isHidden = true
        

        herosSearchList = readHerosFromFile()
        
        searchBar.showsCancelButton = false


    }
    

    
   
    /** Reads in all the heros that can be searched from a text file*/
    func readHerosFromFile() -> [String]{
        
        let path = Bundle.main.path(forResource: file, ofType: "txt")
        
        do {
            let file = try String(contentsOfFile: path!)
            let text: [String] = file.components(separatedBy:.newlines)
            let trimmedArray = text.map { $0.trimmingCharacters(in: .whitespaces)}
            return trimmedArray
        } catch let err {
            print(err)
        }
        return [String]()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return searchInput.count
        } 
        return 0
       }
    
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if isSearching {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SuperHeroCell", for: indexPath) as? SuperHeroCell {
                let name = searchInput [indexPath.row]
                cell.updateView(name: name)
                return cell
            }
            
        }
        
           return UITableViewCell()
    
        
       }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedRow = tableView.cellForRow(at: indexPath) as? SuperHeroCell {
            
            let searchTerm = selectedRow.title.text!
            performSegue(withIdentifier: "HeroVC", sender: searchTerm)
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let heroVC = segue.destination as? HeroVC {
            heroVC.initSearchTerm(title: sender as! String)
        }
          
      }
      
   
}






extension HomeVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //set the auto complete here https://www.youtube.com/watch?v=wVeX68Iu43E
        
         searchBar.showsCancelButton = true
        isSearching = true
        searchInput = herosSearchList.filter({
            $0.prefix(searchText.count) == searchText
        })
        
        tableView.isHidden = false
        tableView.reloadData()
     
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true
        
        if let searchText = searchBar.text {
            searchQuery = searchText
        }
        searchBar.endEditing(true)
        
        tableView.isHidden = false
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        tableView.reloadData()
        isSearching = false
        searchBar.showsCancelButton = false
        tableView.isHidden = true
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    
   
    
    
  
  
    
}
