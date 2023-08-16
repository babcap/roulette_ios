//
//  SettingsViewController.swift
//  roulette_ios
//
//  Created by Arthur on 15.08.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var coinsImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    var viewModel: SettingsViewModel!

    let cellSpacingHeight: CGFloat = 20

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = SettingsViewModel()
        self.viewModel.delegate = self
        
        self.view.backgroundColor = .darkGray

        self.setupAccountView(with: nil)
        self.setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = AuthenticationManager.shared.isLoggedIn() {
            DatabaseManager.shared.getUser(uid: user.uid) { user in
                self.updateView(with: user)
            }
        }
    }

    private func setupLoginButton(isHidden: Bool) {
        self.loginButton.isHidden = isHidden
        self.loginButton.layer.cornerRadius = 12
        self.loginButton.layer.borderColor = UIColor.yellow.cgColor
        self.loginButton.layer.borderWidth = 3
        self.loginButton.titleLabel?.text = "Login"
        self.loginButton.tintColor = .cyan
    }

    private func setupAccountView(with user: UserModel?) {
        self.profileView.layer.cornerRadius = 12
        self.profileView.layer.borderColor = UIColor.yellow.cgColor
        self.profileView.layer.borderWidth = 3
        if let user = user {
            self.setupLoginButton(isHidden: true)
            self.profileView.isHidden = false
            self.profileNameLabel.text = user.name
            self.balanceLabel.text = "\(user.balance)"
        } else {
            self.setupLoginButton(isHidden: false)
            self.profileView.isHidden = true
        }
    }

    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName:SettingCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: SettingCell.reuseIdentifier)
    }

    @IBAction func onLoginButton(_ sender: Any) {
        self.viewModel.handleAction(.signIn)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseIdentifier) as? SettingCell else {
            return UITableViewCell()
        }
        
        let item = self.viewModel.settings[indexPath.section]
        cell.setup(with: item.title)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        self.viewModel.handleActionAt(indexPath)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.settings.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}

extension SettingsViewController: SettingsViewModelDelegate {
    func updateView(with user: UserModel?) {
        self.setupAccountView(with: user)
    }
    
    func share() {
        let items = [URL(string: "https://www.apple.com")!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    
}
