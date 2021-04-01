//
//  InspiringPersonTableViewCell.swift
//  InspiringPeople
//
//  Created by Zvonimir Medak on 01.04.2021..
//

import Foundation
import SnapKit
import UIKit

class InspiringPersonTableViewCell: UITableViewCell {
    
    private let personImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private let birthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Born:"
        return label
    }()
    
    private let deathLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Died:"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(inspiringPerson: InspiringPerson) {
        personImageView.image = inspiringPerson.image
        descriptionLabel.text = inspiringPerson.description
        birthLabel.text?.append(" " + (inspiringPerson.birth ?? ""))
        deathLabel.text?.append(" " + (inspiringPerson.death ?? ""))
    }
}

private extension InspiringPersonTableViewCell {
    
    func setupUI() {
        contentView.addSubviews(personImageView, descriptionLabel, birthLabel, deathLabel)
        selectionStyle = .none
        setupConstraints()
    }
    
    func setupConstraints() {
        personImageView.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().inset(10)
            make.height.width.equalTo(50)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalToSuperview().inset(10)
            make.top.equalTo(personImageView.snp.bottom).inset(-10)
        }
        
        birthLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(personImageView.snp.trailing).inset(-10)
            make.top.equalTo(personImageView).inset(5)
            make.trailing.equalToSuperview().inset(10)
        }
        
        deathLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(personImageView.snp.trailing).inset(-10)
            make.top.equalTo(birthLabel.snp.bottom).inset(-10)
            make.trailing.equalToSuperview().inset(10)
        }
    }
}
