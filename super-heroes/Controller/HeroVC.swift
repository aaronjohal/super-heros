//
//  HeroVC.swift
//  super-heroes
//
//  Created by Aaron Johal on 24/04/2020.
//  Copyright © 2020 Aaron Johal. All rights reserved.
//

import UIKit

class HeroVC: UIViewController {
    
    var searchTerm = ""
    var hero: Hero!

    override func viewDidLoad() {
        super.viewDidLoad()
        
      makeJSONrequest(searchTerm: searchTerm)
    }
    
    
    func initSearchTerm(title: String){
        self.searchTerm = title
    }
    
    func makeJSONrequest(searchTerm: String){
        
       let request =  SuperHeroRequest.init(searchTerm: searchTerm)
    
        
        request.requestHeroJSON { (res) in
            switch res {
            case .success(let hero): //would use a for-Each if we were dealing with arrays
                self.hero = hero[0] //only want the first result returned
            case .failure(let err):
                 print("failed to fetch hero", err)
                }
        }
    
        
        
    }
   


}
