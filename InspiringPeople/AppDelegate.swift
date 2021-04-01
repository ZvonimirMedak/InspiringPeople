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
        let inspiringPeople = [InspiringPerson(image: UIImage(named: "elon"), description: "Technoking of Tesla. Elon Reeve Musk FRS is a business magnate, industrial designer, and engineer. He is the founder, CEO, CTO, and chief designer of SpaceX.", birth: "June 28, 1971", death: "/", quotes: ["SpaceX is going to put a literal Dogecoin on the literal moon", "Nicheman — his superpower is appealing to small audiences", "If there’s ever a scandal about me, *please* call it Elongate", "Why are you so dogematic, they ask"]), InspiringPerson(image: UIImage(named: "bob"), description: "Robert Cecil Martin, colloquially called Uncle Bob, is an American software engineer, instructor, and best-selling author. He is most recognized for developing many software design principles and for being a founder of the influential Agile Manifesto.", birth: "1952", death: "/", quotes: ["Truth can only be found in one place: the code.", "Indeed, the ratio of time spent reading versus writing is well over 10 to 1. We are constantly reading old code as part of the effort to write new code. ...[Therefore,] making it easy to read makes it easier to write.", "It is not enough for code to work.", "So if you want to go fast, if you want to get done quickly, if you want your code to be easy to write, make it easy to read."]), InspiringPerson(image: UIImage(named: "jobs"), description: "Steven Paul Jobs was an American business magnate, industrial designer, investor, and media proprietor. He was the chairman, the chief executive officer (CEO), and a co-founder of Apple Inc., the chairman and majority shareholder of Pixar, a member of The Walt Disney Company's board of directors following its acquisition of Pixar, and the founder, chairman, and CEO of NeXT.", birth: "February 24, 1955", death: "October 5, 2011", quotes: ["Design is not just what it looks like and feels like. Design is how it works.", "I want to put a ding in the universe.", "Innovation distinguishes between a leader and a follower.", "Sometimes life is going to hit you in the head with a brick. Don't lose faith."]), InspiringPerson(image: UIImage(named: "sundell"), description: "John Sundell, former lead iOS developer at Spotify and now the brains and energy behind Swift by Sundell, shares his thoughts on going indie, time management and how you can never be too-prepared for any talk.", birth: "1987.", death: "/", quotes: ["True, but I've never really been a single quotes kind of guy", "Can I quote you on that? Only if you use double quotes.", "I've been so busy that I forgot to celebrate my 4-year anniversary of writing Swift articles in February"])]
        let initialViewController = UINavigationController(rootViewController: LandingViewController(viewModel: LandingViewModel(loadDataSubject: ReplaySubject.create(bufferSize: 1), inspiringPeopleRelay: BehaviorRelay.init(value: []), inspiringPeopleRepository: InspiringPeopleRepositoryImpl(inspiringPeople: inspiringPeople), userInteractionSubject: PublishSubject(), showQuoteSubject: PublishSubject())))
        window.rootViewController = initialViewController
        window.makeKeyAndVisible()
        return true
    }


}

