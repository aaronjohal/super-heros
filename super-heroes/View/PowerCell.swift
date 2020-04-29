//
//  PowerCell.swift
//  super-heroes
//
//  Created by Aaron Johal on 28/04/2020.
//  Copyright © 2020 Aaron Johal. All rights reserved.
//

import UIKit

class PowerCell: UITableViewCell {
    
    @IBOutlet weak var power:UILabel!
     @IBOutlet weak var level:UILabel!
    
    
    func updateViews(power: String, level: String){
        self.power.text = power
        self.level.text = level
        
        colourOfPower(level: level)
       
        
        
    }
    
    
    /** method to change text colour based on level*/
    
    func colourOfPower(level: String){
        if let powerInt = Int(level) {
           
            switch powerInt {
            case (90...100):
                self.level.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            case (70...89):
                self.level.textColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
            case (40...69):
                self.level.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            case (0...39):
                self.level.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            default:
                self.level.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            }
        
        }
    }



}
