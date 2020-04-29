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
    var powers = [Powers] (){ //array of power struct objects that will load into the table view
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
        powerTable.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    
    
    /** Method used to initialise the search term from a different VC before current VC loads*/
    func initSearchTerm(title: String){
        self.searchTerm = title
    }
    
    
    /** Helper method to make JSON request  and handle the results */
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
                
                //get contents of dictionary and put in array for table view
                for (key,value) in powerstats {
                    self.powers.append(Powers(powerName: key, powerAbility: value))
                }

                self.displayHero()
            case .failure(let err):
                print("failed to fetch hero", err)
            }
        }
        
        
    }
    
    
    /** Displays the title and image of the superhero */
    func displayHero(){
        DispatchQueue.main.async {
            self.name.text = self.hero.name
            self.name.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            if let url = self.hero.image["url"] {
                self.image.loadImageFromURL(urlString: url) //extension to image that loads image from URL
                self.image.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                self.image.layer.borderWidth = 10
            }
         
        }
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return powers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PowerCell", for: indexPath) as? PowerCell {
            let power = powers[indexPath.row]
            cell.updateViews(power: power.powerName, level: power.powerAbility)
            return cell
        }
        return PowerCell()
    }
    
    
    
}



let imageCache = NSCache<NSString, UIImage>()

/** Extension class that allows you to download and cache images from URL*/
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



