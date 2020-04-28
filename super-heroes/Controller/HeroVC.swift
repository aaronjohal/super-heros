//
//  HeroVC.swift
//  super-heroes
//
//  Created by Aaron Johal on 24/04/2020.
//  Copyright © 2020 Aaron Johal. All rights reserved.
//

import UIKit

class HeroVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    var searchTerm = ""
    var hero: Hero!
    var powerstats = [String: String] (){
        didSet {
            DispatchQueue.main.async {
                self.powerTable.reloadData()
            }
        }
    }
 
 @IBOutlet weak var name: UILabel!
 @IBOutlet weak var image: UIImageView!
 @IBOutlet weak var powerTable: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeJSONrequest(searchTerm: searchTerm)
        powerTable.delegate = self
        powerTable.dataSource = self
        
       
    
    
    }
    
    
    func initSearchTerm(title: String){
        self.searchTerm = title
    }
    
    func makeJSONrequest(searchTerm: String){
        
       let request =  SuperHeroRequest.init(searchTerm: searchTerm)
    

        request.requestHeroJSON { (res) in
            switch res {
            case .success(let hero): //would use a for-Each if we were dealing with arrays
                
                if searchTerm == "Batman" {
                    self.hero = hero[1]
                } else {
                     self.hero = hero[0] //only want the first result returned
                }
                let powerstats = self.hero.powerstats
                self.powerstats = powerstats
                print(self.powerstats)
                self.displayHero()
                print("number of attributes is", self.hero.powerstats.count)
            case .failure(let err):
                 print("failed to fetch hero", err)
                }
        }
    
        
    }
    
    func displayHero(){
      DispatchQueue.main.async {
        self.name.text = self.hero.name
        if let url = self.hero.image["url"] {
        self.image.loadImageFromURL(urlString: url)
        }
        }

    }
    func printTerms(){
        for (key, value) in hero.powerstats {
            print("\(key), \(value)")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return powerstats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    

}


let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageFromURL(urlString: String){
        
        let url = URL(string: urlString)
        
        image = nil
        
        imageCache.name = "Hero Image Cache"
        
        //check if image is in cache
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) as UIImage? {
            self.image = imageFromCache
            print("image was in cache")
            return
            
        }
        
        //otherwise fetch image from url and download
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async { //update the UI on main thread
                print("image is not in cache")
                let imageToCache = UIImage(data: data!)
                imageCache.setObject(imageToCache!, forKey: urlString as NSString) //store image in imagecache
                self.image = imageToCache
                
            }
        }.resume()
        
    }
    
}



