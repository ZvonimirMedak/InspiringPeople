//
//  DatabseRepository.swift
//  InspiringPeople
//
//  Created by Zvonimir Medak on 11.04.2021..
//


import Foundation
import UIKit

enum DatabaseKeys: String {
    case people
}

public class DatabaseRepositoryImpl: DatabaseRepository {
    
     let defaults = UserDefaults.standard
    
    public func personDeleted(index: Int) {
        guard let people = defaults.data(forKey: DatabaseKeys.people.rawValue), var decodedPeople = NSKeyedUnarchiver.unarchiveObject(with: people) as? [InspiringPerson] else {return}
        decodedPeople.remove(at: index)
        let encodedPeople: Data = NSKeyedArchiver.archivedData(withRootObject: decodedPeople)
        defaults.setValue(encodedPeople, forKey: DatabaseKeys.people.rawValue)
    }
    
    public func getPeople() -> [InspiringPerson] {
        guard let people = defaults.data(forKey: DatabaseKeys.people.rawValue), let decodedPeople = NSKeyedUnarchiver.unarchiveObject(with: people) as? [InspiringPerson] else {return []}
        return decodedPeople
    }
    
    public func personAdded(person: InspiringPerson) {
        guard let people = defaults.data(forKey: DatabaseKeys.people.rawValue), var decodedPeople = NSKeyedUnarchiver.unarchiveObject(with: people) as? [InspiringPerson] else {
            var peopleArray = [person]
            let encodedPeople: Data = NSKeyedArchiver.archivedData(withRootObject: peopleArray)
            defaults.setValue(encodedPeople, forKey: DatabaseKeys.people.rawValue)
            return}
        decodedPeople.append(person)
        let encodedPeople: Data = NSKeyedArchiver.archivedData(withRootObject: decodedPeople)
        defaults.setValue(encodedPeople, forKey: DatabaseKeys.people.rawValue)
    }
    
    public func personChanged(at index: Int, newPerson: InspiringPerson) {
        guard let people = defaults.data(forKey: DatabaseKeys.people.rawValue), var decodedPeople = NSKeyedUnarchiver.unarchiveObject(with: people) as? [InspiringPerson] else {return}
        decodedPeople[index] = newPerson
        let encodedPeople: Data = NSKeyedArchiver.archivedData(withRootObject: decodedPeople)
        defaults.setValue(encodedPeople, forKey: DatabaseKeys.people.rawValue)
        
    }
}

public protocol DatabaseRepository {
    func personChanged(at index: Int, newPerson: InspiringPerson)
    func personDeleted(index: Int)
    func getPeople() -> [InspiringPerson]
    func personAdded(person: InspiringPerson)
}
