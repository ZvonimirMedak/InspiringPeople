//
//  LandingViewController.swift
//  InspiringPeople
//
//  Created by Zvonimir Medak on 01.04.2021..
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LandingViewController: UIViewController{
    
    let disposeBag = DisposeBag()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        return tv
    }()
    
    let addPersonBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        return barButton
    }()
    
    let viewModel: LandingViewModel
    
    init(viewModel: LandingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initializeVM()
        initializeInteraction()
        viewModel.loadDataSubject.onNext(())
    }
}

private extension LandingViewController {
    
    func setupUI() {
        view.addSubview(tableView)
        navigationItem.rightBarButtonItem = addPersonBarButton
        setupConstraints()
        setupTableView()
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupTableView() {
        tableView.register(InspiringPersonTableViewCell.self, forCellReuseIdentifier: "InspiringPersonTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

private extension LandingViewController {
    
    func initializeVM() {
        initializeScreenDataObservable(for: viewModel.inspiringPeopleRelay).disposed(by: disposeBag)
        initializeShowQuoteObservable(for: viewModel.showQuoteSubject).disposed(by: disposeBag)
        disposeBag.insert(viewModel.initializeObservables()) 
    }
    
    func initializeScreenDataObservable(for subject: BehaviorRelay<[InspiringPerson]>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (_) in
                tableView.reloadData()
            })
    }
    
    func initializeShowQuoteObservable(for subject: PublishSubject<String>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (quote) in
                showAlert(message: quote)
            })
    }
    
    func initializeInteraction() {
        addPersonBarButton.rx
            .tap
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] in
                let viewModel = AddPersonViewModel(inspiringPerson: InspiringPerson(image: nil, description: nil, birth: nil, death: nil, quotes: nil), userInteractionSubject: PublishSubject(), showAlertSubject: PublishSubject(), inspiringPersonRepository: self.viewModel.inspiringPeopleRepository)
                viewModel.successDelegate = self
                let addPersonVC = AddPersonViewController(viewModel: viewModel)
                self.present(addPersonVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension LandingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.inspiringPeopleRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InspiringPersonTableViewCell", for: indexPath) as? InspiringPersonTableViewCell else {
            return UITableViewCell()
        }
        let currentPerson = viewModel.inspiringPeopleRelay.value[indexPath.row]
        cell.configureCell(inspiringPerson: currentPerson)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.userInteractionSubject.onNext(indexPath.row)
    }
}

extension LandingViewController: SuccessDelegate {
    
    func sendSuccess() {
        dismiss(animated: true) { [unowned self] in
            viewModel.loadDataSubject.onNext(())
        }
    }
}
