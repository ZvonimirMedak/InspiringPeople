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
}
