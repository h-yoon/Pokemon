import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let friendTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "친구 목록"
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()

    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("추가", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()

    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        tv.separatorColor = .systemGray4
        tv.rowHeight = 80
        return tv
    }()

    var friends: [(name: String, phone: String)] = Array(repeating: ("name", "010-0000-0000"), count: 6)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PokemonCell.self, forCellReuseIdentifier: PokemonCell.identifier)

        setupLayout()

        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }

    
    private func setupLayout() {
        view.addSubview(friendTitleLabel)
        view.addSubview(addButton)
        view.addSubview(tableView)

        friendTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.centerX.equalToSuperview()
        }

        addButton.snp.makeConstraints {
            $0.centerY.equalTo(friendTitleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(friendTitleLabel.snp.bottom).offset(12)
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
