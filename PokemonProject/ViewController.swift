//
//  PokemonCell.swift
//  PokemonProject
//
//  Created by 형윤 on 4/18/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.separatorStyle = .none
        tv.rowHeight = 80
        return tv
    }()

    var friends: [(name: String, phone: String)] = Array(repeating: ("name", "010-0000-0000"), count: 6)

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

    private func setupLayout() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }

    @objc private func addButtonTapped() {
        let vc = PhoneBookViewController()
        navigationController?.pushViewController(vc, animated: true)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCell.identifier, for: indexPath) as? PokemonCell else {
            return UITableViewCell()
        }

        cell.nameLabel.text = friends[indexPath.row].name
        cell.phoneLabel.text = friends[indexPath.row].phone
        return cell
    }
}
