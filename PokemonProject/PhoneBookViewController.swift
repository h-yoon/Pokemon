//
//  PhoneBookViewController.swift
//  PokemonProject
//
//  Created by 형윤 on 4/18/25.
//

import UIKit
import SnapKit
import CoreData

class PhoneBookViewController: UIViewController {

    var onSave: (() -> Void)?

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 60
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let randomImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("랜덤 이미지 불러오기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return button
    }()

    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이름을 입력하세요"
        tf.borderStyle = .roundedRect
        return tf
    }()

    private let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "전화번호를 입력하세요"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .phonePad
        return tf
    }()

    private var currentImageUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "연락처 추가"
        setupLayout()

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "적용",
            style: .done,
            target: self,
            action: #selector(applyButtonTapped)
        )
        randomImageButton.addTarget(self, action: #selector(fetchRandomPokemonImage), for: .touchUpInside)
    }

    private func setupLayout() {
        view.addSubview(profileImageView)
        view.addSubview(randomImageButton)
        view.addSubview(nameTextField)
        view.addSubview(phoneTextField)

        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(120)
        }

        randomImageButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }

        nameTextField.snp.makeConstraints {
            $0.top.equalTo(randomImageButton.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(40)
            $0.height.equalTo(44)
        }

        phoneTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(16)
            $0.left.right.equalTo(nameTextField)
            $0.height.equalTo(44)
        }
    }

    @objc private func applyButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let phone = phoneTextField.text, !phone.isEmpty else {
            return
        }

        let context = CoreData.shared.context
        let contact = ContactEntity(context: context)
        contact.name = name
        contact.phone = phone
        contact.imageUrl = currentImageUrl

        CoreData.shared.saveContext()

        onSave?()
        navigationController?.popViewController(animated: true)
    }

    @objc private func fetchRandomPokemonImage() {
        let randomID = Int.random(in: 1...1000)
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(randomID)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }

            if let data = data,
               let result = try? JSONDecoder().decode(PokemonResponse.self, from: data),
               let imageUrlString = result.sprites.front_default,
               let imageUrl = URL(string: imageUrlString) {
                self.currentImageUrl = imageUrlString
                self.downloadImage(from: imageUrl)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.fetchRandomPokemonImage()
                }
            }
        }.resume()
    }

    private func downloadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.profileImageView.image = image
            }
        }.resume()
    }
}

struct PokemonResponse: Decodable {
    let sprites: Sprite
    struct Sprite: Decodable {
        let front_default: String?
    }
}

