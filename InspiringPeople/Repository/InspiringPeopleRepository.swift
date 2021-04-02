//
//  InspiringPeopleRepository.swift
//  InspiringPeople
//
//  Created by Zvonimir Medak on 01.04.2021..
//

import Foundation

public protocol InspiringPeopleRepository {
    func getInspiringPeople() -> [InspiringPerson]
    func addInspiringPerson(person: InspiringPerson)
    func editInspiringPerson(person: InspiringPerson, at index: Int)
    func deleteInspiringPerson(at index: Int)
    
}
public class InspiringPeopleRepositoryImpl: InspiringPeopleRepository {
    
    private var inspiringPeople: [InspiringPerson]
    
    public init(inspiringPeople: [InspiringPerson]) {
        self.inspiringPeople = inspiringPeople
    }
    
    public func getInspiringPeople() -> [InspiringPerson] {
        return inspiringPeople
    }
    
    public func addInspiringPerson(person: InspiringPerson) {
        inspiringPeople.append(person)
    }
    
    public func editInspiringPerson(person: InspiringPerson, at index: Int) {
        if index < inspiringPeople.count {
            inspiringPeople[index] = person
        }
    }
    
    public func deleteInspiringPerson(at index: Int) {
        if index < inspiringPeople.count {
            inspiringPeople.remove(at: index)
        }
    }
}
