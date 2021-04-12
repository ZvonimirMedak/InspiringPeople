//
//  LandingViewModel.swift
//  InspiringPeople
//
//  Created by Zvonimir Medak on 01.04.2021..
//

import Foundation
import RxSwift
import RxCocoa

public enum LandingUserInteractionType {
    case quote(index: Int)
    case delete(index: Int)
}

public class LandingViewModel {
    public let loadDataSubject: ReplaySubject<()>
    public let inspiringPeopleRelay: BehaviorRelay<[InspiringPerson]>
    public let userInteractionSubject: PublishSubject<LandingUserInteractionType>
    public let showQuoteSubject: PublishSubject<String>
    public let databaseManager: DatabaseRepository
    
    
    public init(loadDataSubject: ReplaySubject<()>, inspiringPeopleRelay: BehaviorRelay<[InspiringPerson]>, userInteractionSubject: PublishSubject<LandingUserInteractionType>, showQuoteSubject: PublishSubject<String>, databaseManager: DatabaseRepository) {
        self.loadDataSubject = loadDataSubject
        self.inspiringPeopleRelay = inspiringPeopleRelay
        self.userInteractionSubject = userInteractionSubject
        self.showQuoteSubject = showQuoteSubject
        self.databaseManager = databaseManager
    }
    
    public func initializeObservables() -> [Disposable] {
        var disposables: [Disposable] = []
        disposables.append(initializeLoadDataObservable(for: loadDataSubject))
        disposables.append(initializeUserInteractionObservable(for: userInteractionSubject))
        return disposables
    }
}

private extension LandingViewModel {
    
    func initializeLoadDataObservable(for subject: ReplaySubject<()>) -> Disposable {
        return subject
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.instance)
            .map { [unowned self] (_) -> [InspiringPerson] in
                getScreenData()
            }
            .subscribe(onNext: { [unowned self] (people) in
                inspiringPeopleRelay.accept(people)
                
            })
    }
    
    func getScreenData() -> [InspiringPerson] {
        return databaseManager.getPeople()
    }
}

private extension LandingViewModel {
    
    func initializeUserInteractionObservable(for subject: PublishSubject<LandingUserInteractionType>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (row) in
                handleUserInteraction(for: row)
            })
    }
    
    func handleUserInteraction(for type: LandingUserInteractionType) {
        switch type {
        case .quote(let index):
            let currentPerson = databaseManager.getPeople()[index]
            guard let quote = currentPerson.quotes.randomElement() else {return}
            showQuoteSubject.onNext(quote)
        case .delete(let index):
            databaseManager.personDeleted(index: index)
            loadDataSubject.onNext(())
        }
        
    }
}
