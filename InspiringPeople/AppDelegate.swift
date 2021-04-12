//
//  AppDelegate.swift
//  InspiringPeople
//
//  Created by Zvonimir Medak on 01.04.2021..
//

import UIKit
import RxCocoa
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else {return false}
        let landingViewController = LandingViewController(viewModel: LandingViewModel(loadDataSubject: ReplaySubject.create(bufferSize: 1), inspiringPeopleRelay: BehaviorRelay.init(value: []), userInteractionSubject: PublishSubject(), showQuoteSubject: PublishSubject(), databaseManager: DatabaseRepositoryImpl()))
        let addPersonViewController = AddPersonViewController(viewModel: AddPersonViewModel(inspiringPerson: InspiringPerson(), userInteractionSubject: PublishSubject(), showAlertSubject: PublishSubject(), type: .add, databaseManager: DatabaseRepositoryImpl()))
        let pagerViewController = PagerViewController(viewControllers: [landingViewController, addPersonViewController])
        addPersonViewController.viewModel.successDelegate = pagerViewController
        let initialViewController = UINavigationController(rootViewController: pagerViewController)
        initialViewController.isNavigationBarHidden = true
        window.rootViewController = initialViewController
        window.makeKeyAndVisible()
        return true
    }


}

