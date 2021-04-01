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
        let iv = UIImageView()
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
}

private extension AddPersonViewController {
    
    func setupUI() {
        view.addSubviews(personImageView, birthTextField, deathTextField, descriptionTextField, quotesTextField)
        setupConstraints()
    }
    
    func setupConstraints() {
        personImageView.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview().inset(10)
            make.height.width.equalTo(50)
        }
        
        birthTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(personImageView.snp.trailing).inset(-10)
            make.top.equalTo(personImageView).inset(5)
            make.trailing.equalToSuperview().inset(10)
        }
        
        deathTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(personImageView.snp.trailing).inset(-10)
            make.top.equalTo(birthTextField.snp.bottom).inset(-10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        descriptionTextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(personImageView.snp.bottom).inset(-10)
        }
        
        quotesTextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(descriptionTextField.snp.bottom).inset(-10)
        }
    }
}
