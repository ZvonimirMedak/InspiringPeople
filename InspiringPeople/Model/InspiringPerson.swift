//
//  InspiringPerson.swift
//  InspiringPeople
//
//  Created by Zvonimir Medak on 01.04.2021..
//

import Foundation
import UIKit
public class InspiringPerson: NSObject, NSCoding {
    public func encode(with coder: NSCoder) {
        coder.encode(image, forKey: "image")
        coder.encode(birth, forKey: "birth")
        coder.encode(personDescription, forKey: "personDescription")
        coder.encode(death, forKey: "death")
        coder.encode(quotes, forKey: "quotes")
    }
    
    init(image: Data?, description: String?, birth: String?, death: String?, quotes: [String]) {
        self.image = image
        self.death = death
        self.personDescription = description
        self.birth = birth
        self.quotes = quotes
    }
    
    public required convenience init?(coder: NSCoder) {
        let image = coder.decodeObject(forKey: "image") as! Data
        let birth = coder.decodeObject(forKey: "birth") as! String
        let death = coder.decodeObject(forKey: "death") as! String
        let quotes = coder.decodeObject(forKey: "quotes") as! [String]
        let personDescription = coder.decodeObject(forKey: "personDescription") as! String
        self.init(image: image, description: personDescription, birth: birth, death: death, quotes: quotes)
    }
    
    
    var image: Data?
    var personDescription: String?
    var birth: String?
    var death: String?
    var quotes: [String]
    
    
    
    override init() {
        self.image = nil
        self.death = nil
        self.personDescription = nil
        self.birth = nil
        self.quotes = []
    }
    
    func getImageFromData() -> UIImage? {
        guard let safeData = image else {return nil}
        return UIImage(data: safeData)
    }
}
