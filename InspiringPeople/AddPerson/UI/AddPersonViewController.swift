//
//  AddPersonViewController.swift
//  InspiringPeople
//
//  Created by Zvonimir Medak on 01.04.2021..
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa
import UIKit

public class AddPersonViewController: UIViewController {
    
    private let personImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "placeholder"))
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let birthTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Birth"
        field.font = UIFont.systemFont(ofSize: 15)
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        return field
    }()
    
    private let deathTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Death"
        field.font = UIFont.systemFont(ofSize: 15)
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        return field
    }()
    
    private let descriptionTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Description"
        field.font = UIFont.systemFont(ofSize: 15)
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        return field
    }()
    
    private let quotesTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Quotes, separate them with semi-colon"
        field.font = UIFont.systemFont(ofSize: 15)
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        return field
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("SUBMIT", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        return button
    }()
    
    let disposeBag = DisposeBag()
    let tapGesture = UITapGestureRecognizer()
    let viewModel: AddPersonViewModel
    
    public init(viewModel: AddPersonViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupInteraction()
        initializeVM()
    }
}

private extension AddPersonViewController {
    
    func setupUI() {
        view.addSubviews(personImageView, birthTextField, deathTextField, descriptionTextField, quotesTextField, submitButton)
        handleControllerType(for: viewModel.type)
        setupConstraints()
        personImageView.addGestureRecognizer(tapGesture)
    }
    
    func setupConstraints() {
        personImageView.snp.makeConstraints { (make) in
            make.leading.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.width.equalTo(90)
        }
        
        birthTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(personImageView.snp.trailing).inset(-10)
            make.top.equalTo(personImageView).inset(5)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
        
        deathTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(personImageView.snp.trailing).inset(-10)
            make.top.equalTo(birthTextField.snp.bottom).inset(-10)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }
        
        descriptionTextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(personImageView.snp.bottom).inset(-10)
            make.height.equalTo(40)
        }
        
        quotesTextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(descriptionTextField.snp.bottom).inset(-10)
            make.height.equalTo(40)
        }
        
        submitButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(quotesTextField.snp.bottom).inset(-10)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
    }
    
    func setupInteraction() {
        tapGesture.rx.event
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (_) in
                openImagePicker()
            })
            .disposed(by: disposeBag)
        
        quotesTextField.rx
            .text
            .changed
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (text) in
                viewModel.userInteractionSubject.onNext(.quotes(quotes: text ?? ""))
            })
            .disposed(by: disposeBag)
        
        birthTextField.rx
            .text
            .changed
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (text) in
                viewModel.userInteractionSubject.onNext(.birth(birth: text ?? ""))
            })
            .disposed(by: disposeBag)
        
        deathTextField.rx
            .text
            .changed
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (text) in
                viewModel.userInteractionSubject.onNext(.death(death: text ?? ""))
            })
            .disposed(by: disposeBag)
        
        descriptionTextField.rx
            .text
            .changed
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (text) in
                viewModel.userInteractionSubject.onNext(.description(description: text ?? ""))
            })
            .disposed(by: disposeBag)
        
        submitButton.rx
            .tap
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] (_) in
                viewModel.userInteractionSubject.onNext(.submit)
            })
            .disposed(by: disposeBag)
    }
    
    func handleControllerType(for type: ModelType) {
        switch type {
        case .edit(index: _):
            personImageView.image = viewModel.inspiringPerson.getImageFromData()
            birthTextField.text = viewModel.inspiringPerson.birth
            deathTextField.text = viewModel.inspiringPerson.death
            descriptionTextField.text = viewModel.inspiringPerson.personDescription
            for quote in viewModel.inspiringPerson.quotes {
                if quote == viewModel.inspiringPerson.quotes.last{
                    quotesTextField.text?.append(" " + quote)
                }
                else {
                    quotesTextField.text?.append(" " + quote + ";")
                }
            }
        default:
            break
        }
    }
}

private extension AddPersonViewController {
    func initializeVM() {
        disposeBag.insert(viewModel.initializeVM())
        initializeAlertSubject(for: viewModel.showAlertSubject).disposed(by: disposeBag)
    }
    
    func initializeAlertSubject(for subject: PublishSubject<()>) -> Disposable {
        return subject
            .observe(on: MainScheduler.instance)
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .subscribe(onNext: { [unowned self] in
                showAlert(message: "All fields are required")
            })
    }
}

extension AddPersonViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openImagePicker() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imagePicked = info[.originalImage] as? UIImage, let assetPath = info[.imageURL] as? NSURL else {return}
        print(assetPath)
        var data: Data
        
        if (assetPath.absoluteString?.hasSuffix("JPG"))! {
            data = Data(imagePicked.jpegData(compressionQuality: 0.9)!)
            }
            else if (assetPath.absoluteString?.hasSuffix("PNG"))! {
                data = Data(imagePicked.pngData()!)
            }
            else if (assetPath.absoluteString?.hasSuffix("GIF"))! {
                    data = Data(imagePicked.jpegData(compressionQuality: 0.9)!)
                
            }
            else {
                    data = Data(imagePicked.jpegData(compressionQuality: 0.9)!)
            }
        personImageView.image = imagePicked
        viewModel.userInteractionSubject.onNext(.image(image: data))
        dismiss(animated: true, completion: nil)
    }
}
