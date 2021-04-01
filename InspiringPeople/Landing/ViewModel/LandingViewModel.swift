//
//  LandingViewModel.swift
//  InspiringPeople
//
//  Created by Zvonimir Medak on 01.04.2021..
//

import Foundation
import RxSwift
import RxCocoa

public class LandingViewModel {
    public let loadDataSubject: ReplaySubject<()>
    public let inspiringPeopleRelay: BehaviorRelay<[InspiringPerson]>
    public let userInteractionSubject: PublishSubject<Int>
    public let showQuoteSubject: PublishSubject<String>
    public let inspiringPeopleRepository: InspiringPeopleRepository
    
    
    public init(loadDataSubject: ReplaySubject<()>, inspiringPeopleRelay: BehaviorRelay<[InspiringPerson]>, inspiringPeopleRepository: InspiringPeopleRepository, userInteractionSubject: PublishSubject<Int>, showQuoteSubject: PublishSubject<String>) {
        self.loadDataSubject = loadDataSubject
        self.inspiringPeopleRelay = inspiringPeopleRelay
        self.inspiringPeopleRepository = inspiringPeopleRepository
        self.userInteractionSubject = userInteractionSubject
        self.showQuoteSubject = showQuoteSubject
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
        return inspiringPeopleRepository.getInspiringPeople()
    }
}

private extension LandingViewModel {
    
    func initializeUserInteractionObservable(for subject: PublishSubject<Int>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (row) in
                handleUserInteraction(for: row)
            })
    }
    
    func handleUserInteraction(for row: Int) {
        let currentPerson = inspiringPeopleRelay.value[row]
        guard let quote = currentPerson.quotes?.randomElement() else {return}
        showQuoteSubject.onNext(quote)
    }
}
