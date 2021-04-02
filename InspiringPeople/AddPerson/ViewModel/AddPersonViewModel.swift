//
//  AddPersonViewModel.swift
//  InspiringPeople
//
//  Created by Zvonimir Medak on 01.04.2021..
//

import Foundation
import RxSwift
import RxCocoa

public enum AddPersonUserInteractionType {
    case image(image: UIImage)
    case birth(birth: String)
    case death(death: String)
    case description(description: String)
    case quotes(quotes: String)
    case submit
}

public enum ModelType: Equatable {
    case add
    case edit(index: Int)
}

public protocol SuccessDelegate: class {
    func sendSuccess()
}

public class AddPersonViewModel {
    weak var successDelegate: SuccessDelegate?
    
    public var inspiringPerson: InspiringPerson
    public let userInteractionSubject: PublishSubject<AddPersonUserInteractionType>
    public let showAlertSubject: PublishSubject<()>
    private let inspiringPersonRepository: InspiringPeopleRepository
    public let type: ModelType
    
    public init(inspiringPerson: InspiringPerson, userInteractionSubject: PublishSubject<AddPersonUserInteractionType>, showAlertSubject: PublishSubject<()>, inspiringPersonRepository: InspiringPeopleRepository, type: ModelType) {
        self.inspiringPerson = inspiringPerson
        self.userInteractionSubject = userInteractionSubject
        self.showAlertSubject = showAlertSubject
        self.inspiringPersonRepository = inspiringPersonRepository
        self.type = type
    }
    
    public func initializeVM() -> [Disposable] {
        var disposables: [Disposable] = []
        disposables.append(initializeUserInteractionSubject(for: userInteractionSubject))
        return disposables
    }
}

private extension AddPersonViewModel {
    
    func initializeUserInteractionSubject(for subject: PublishSubject<AddPersonUserInteractionType>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (type) in
                handleUserInteractionType(for: type)
            })
    }
    
    func handleUserInteractionType(for type: AddPersonUserInteractionType) {
        switch type {
        case .birth(let text):
            inspiringPerson.birth = text
        case .death(let text):
            inspiringPerson.death = text
        case .description(let description):
            inspiringPerson.description = description
        case .image(let image):
            inspiringPerson.image = image
        case .quotes(let quotes):
            handleQuotes(for: quotes)
        case .submit:
            handlePersonSubmit()
        }
    }
    
    func handlePersonSubmit() {
        guard let safeBirth = inspiringPerson.birth, let safeDeath = inspiringPerson.death, let safeDescription = inspiringPerson.description,
              let safeImage = inspiringPerson.image, let safeQuotes = inspiringPerson.quotes else {
            showAlertSubject.onNext(())
            return
        }
        let person = InspiringPerson(image: safeImage, description: safeDescription, birth: safeBirth, death: safeDeath, quotes: safeQuotes)
        switch type {
        case .add:
            inspiringPersonRepository.addInspiringPerson(person: person)
        case .edit(let index):
            inspiringPersonRepository.editInspiringPerson(person: person, at: index)
        }        
        successDelegate?.sendSuccess()
    }
    
    func handleQuotes(for quotes: String) {
        let splitString = quotes.split(separator: ";")
        var quotes = [String]()
        for substring in splitString {
            quotes.append(String(substring))
        }
        inspiringPerson.quotes = quotes
    }
}
