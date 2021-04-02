//
//  PagerViewController.swift
//  InspiringPeople
//
//  Created by Zvonimir Medak on 02.04.2021..
//

import Foundation
import Tabman
import RxCocoa
import RxSwift
import UIKit
import Pageboy

public class PagerViewController: TabmanViewController {
    
    private let viewControllers: [UIViewController]
    
    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
            super.viewDidLoad()
            self.dataSource = self
            let bar = TMBar.ButtonBar()
            bar.layout.transitionStyle = .snap
            addBar(bar, dataSource: self, at: .top)
        }
}

extension PagerViewController: PageboyViewControllerDataSource, TMBarDataSource {

    public func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    public func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    public func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .first
    }

    public func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let title: String
        if index == 0 {
            title = "Inspiring People"
        }else {
            title = "Add Person"
        }
        return TMBarItem(title: title)
    }
}

extension PagerViewController: SuccessDelegate {
    
    public func sendSuccess() {
        guard let landingViewController = viewControllers.first as? LandingViewController else {return}
        landingViewController.viewModel.loadDataSubject.onNext(())
        scrollToPage(.first, animated: true)
    }
}
