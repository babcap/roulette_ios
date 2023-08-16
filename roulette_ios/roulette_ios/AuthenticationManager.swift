//
//  AuthenticationManager.swift
//  roulette_ios
//
//  Created by Arthur on 15.08.2023.
//

import Foundation
import FirebaseAuth



class AuthenticationManager {
    
    typealias completionHandler = (UserModel?, Error?)->()
    typealias onCompletion = (Bool, Error?)->()

    private init() {
    }
    
    static let shared = AuthenticationManager()
    
    let authenticationObject = Auth.auth()

    func anonymus(handler: @escaping completionHandler) {
        authenticationObject.signInAnonymously { (response, error) in
            guard error == nil else {
                if let error = error {
                    handler(nil, error)
                }
                return
            }
            
            if let user = response?.user {
                DatabaseManager.shared.getUser(uid: user.uid) { userModel in
                    if let userModel = userModel {
                        handler(userModel, nil)
                    } else {
                        if let userModel = DatabaseManager.shared.writeUser(uid: user.uid) {
                            handler(userModel, nil)
                        }
                    }
                }
            }
        }
    }

    func deleteUser(handler: @escaping onCompletion) {
        
        authenticationObject.currentUser?.delete(completion: { (error) in
            
            guard error == nil else {
                handler(false, error)
                return
            }

            handler(true, nil)
        })
    }

    func isLoggedIn() -> User? {
        
        return authenticationObject.currentUser
    }

    func logout() -> Bool {
        do {
            try authenticationObject.signOut()
            return true
        }
        catch {
            return false
        }
    }
    
    
}
