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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = SettingsViewModel()
        self.viewModel.delegate = self

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

    private func setupAccountView(with user: UserModel?) {
        if let user = user {
            self.loginButton.isHidden = true
            self.profileNameLabel.text = user.name
            self.balanceLabel.text = "\(user.balance)"
        } else {
            self.loginButton.isHidden = false
            self.loginButton.titleLabel?.text = "Login"
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
        return self.viewModel.settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseIdentifier) as? SettingCell else {
            return UITableViewCell()
        }
        
        let item = self.viewModel.settings[indexPath.row]
        cell.setup(with: item.title)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        self.viewModel.handleActionAt(indexPath)
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
