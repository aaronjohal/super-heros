//
//  SuperHeroCell.swift
//  super-heroes
//
//  Created by Aaron Johal on 23/04/2020.
//  Copyright © 2020 Aaron Johal. All rights reserved.
//

import UIKit

class SuperHeroCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    func updateView(name: String){
        self.title.text = name
    }

}
