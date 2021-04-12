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
        view.backgroundColor = .white
        setupUI()
        initializeVM()
        viewModel.loadDataSubject.onNext(())
    }
}

private extension LandingViewController {
    
    func setupUI() {
        view.addSubview(tableView)
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
}

extension LandingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.inspiringPeopleRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InspiringPersonTableViewCell", for: indexPath) as? InspiringPersonTableViewCell else {
            return UITableViewCell()
        }
        if  viewModel.inspiringPeopleRelay.value.count > indexPath.row {
            let currentPerson = viewModel.inspiringPeopleRelay.value[indexPath.row]
            cell.configureCell(inspiringPerson: currentPerson)
            cell.deleteButton.rx.tap
                .observe(on: MainScheduler.instance)
                .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                .subscribe(onNext: { [unowned self] in
                    viewModel.userInteractionSubject.onNext(.delete(index: indexPath.row))
                })
                .disposed(by: disposeBag)
            
            cell.editButton.rx.tap
                .observe(on: MainScheduler.instance)
                .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                .subscribe(onNext: { [unowned self] in
                    presentEditingViewController(person: viewModel.inspiringPeopleRelay.value[indexPath.row], index: indexPath.row)
                })
                .disposed(by: disposeBag)
            return cell
        }
        else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.userInteractionSubject.onNext(.quote(index: indexPath.row))
    }
}

extension LandingViewController: SuccessDelegate {
    
    func presentEditingViewController(person: InspiringPerson, index: Int) {
        let addPersonViewController = AddPersonViewController(viewModel: AddPersonViewModel(inspiringPerson: person, userInteractionSubject: PublishSubject(), showAlertSubject: PublishSubject(), type: .edit(index: index), databaseManager: viewModel.databaseManager))
        addPersonViewController.viewModel.successDelegate = self
        present(addPersonViewController, animated: true, completion: nil)
    }
    
    func sendSuccess() {
        dismiss(animated: true) { [unowned self] in
            viewModel.loadDataSubject.onNext(())
        }
    }
}
