//
//  ViewController.swift
//  PokemonProject
//
//  Created by 형윤 on 4/18/25.
//
//
//  ViewController.swift
//  PokemonProject
//
//  Created by 형윤 on 4/18/25.
//

import UIKit
import SnapKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.separatorStyle = .none
        tv.rowHeight = 80
        return tv
    }()

    var friends: [ContactEntity] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        self.title = "친구 목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "추가",
            style: .plain,
            target: self,
            action: #selector(addButtonTapped)
        )

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PokemonCell.self, forCellReuseIdentifier: PokemonCell.identifier)

        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        friends = fetchContacts()
        tableView.reloadData()
    }

    private func setupLayout() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.left.right.bottom.equalToSuperview()
        }
    }

    @objc private func addButtonTapped() {
        let vc = PhoneBookViewController()

        vc.onSave = { [weak self] in
            self?.friends = self?.fetchContacts() ?? []
            self?.tableView.reloadData()
        }

        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCell.identifier, for: indexPath) as? PokemonCell else {
            return UITableViewCell()
        }

        let contact = friends[indexPath.row]
        cell.nameLabel.text = contact.name
        cell.phoneLabel.text = contact.phone

        if let urlString = contact.imageUrl,
           let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.profileImageView.image = image
                    }
                }
            }.resume()
        } else {
            cell.profileImageView.image = nil
        }

        return cell
    }

    private func fetchContacts() -> [ContactEntity] {
        let context = CoreData.shared.context
        let request: NSFetchRequest<ContactEntity> = ContactEntity.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
}
