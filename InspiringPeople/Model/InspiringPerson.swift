//
//  InspiringPerson.swift
//  InspiringPeople
//
//  Created by Zvonimir Medak on 01.04.2021..
//

import Foundation
import UIKit

public class InspiringPerson {
    var image: UIImage?
    var description: String?
    var birth: String?
    var death: String?
    var quotes: [String]?
    
    init(image: UIImage?, description: String?, birth: String?, death: String?, quotes: [String]?) {
        self.image = image
        self.death = death
        self.description = description
        self.birth = birth
        self.quotes = quotes
    }
}
