//
//  SettingsViewModel.swift
//  roulette_ios
//
//  Created by Arthur on 15.08.2023.
//

import Foundation
import StoreKit

enum SettingAction {
    case signIn
    case rateApp
    case shareGame
    case deleteAccount
    case logout
}

struct Setting {
    let title: String
    let action: SettingAction
}

protocol SettingsViewModelDelegate: AnyObject {
    func updateView(with user: UserModel?)
    func share()
}

class SettingsViewModel {
    weak var delegate: SettingsViewModelDelegate!

    let settings: [Setting] = [
        Setting(title: "Rate App", action: .rateApp),
        Setting(title: "Share Game", action: .shareGame),
        Setting(title: "Logout", action: .logout),
        Setting(title: "Delete Account", action: .deleteAccount)
    ]

    func handleActionAt(_ indexPath: IndexPath) {
        let setting = settings[indexPath.row]
        self.handleAction(setting.action)
    }

    func getUser(completion: @escaping (UserModel?) -> Void) {
        guard let user = AuthenticationManager.shared.isLoggedIn() else { return }
        DatabaseManager.shared.getUser(uid: user.uid, with: completion)
    }

    func handleAction(_ action: SettingAction) {
        switch action {
        case .signIn:
            AuthenticationManager.shared.anonymus() { user, error in
                guard let user = user, let userModel = DatabaseManager.shared.writeUser(uid: user.uid) else { return }
                self.delegate.updateView(with: userModel)
                
            }
        case .rateApp:
            SKStoreReviewController.requestReviewInCurrentScene()
        case .shareGame:
            self.delegate.share()
        case .deleteAccount:
            AuthenticationManager.shared.deleteUser() { user, error in
                self.delegate.updateView(with: nil)
            }
        case .logout:
            guard AuthenticationManager.shared.logout() else { return }
            self.delegate.updateView(with: nil)
        }
    }
}
