//
//  PokemonCell.swift
//  PokemonProject
//
//  Created by 형윤 on 4/18/25.
//

import UIKit
import SnapKit

class PokemonCell: UITableViewCell {
    
    static let identifier = "PokemonCell"

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = nil 
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 30
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "name"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "010-0000-0000"
        label.font = .systemFont(ofSize: 13, weight: .light)
        label.textColor = .darkGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(phoneLabel)
        
        profileImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        
        nameLabel.font = .systemFont(ofSize: 16, weight: .regular)
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(profileImageView.snp.right).offset(12)
        }
        
        phoneLabel.font = .systemFont(ofSize: 16, weight: .regular)
        phoneLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(30)
        }
    }
}
