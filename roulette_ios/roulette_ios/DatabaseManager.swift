//
//  DatabaseManager.swift
//  roulette_ios
//
//  Created by Arthur on 15.08.2023.
//

import Foundation
import FirebaseDatabase

class DatabaseManager {
    private init() {
    }
    
    static let shared = DatabaseManager()

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private lazy var databasePath: DatabaseReference? = {
        guard let uid = AuthenticationManager.shared.isLoggedIn()?.uid else {
        return nil
      }

      let ref = Database.database()
        .reference()
        .child("users/")
      return ref
    }()

    func getUser(uid: String, with completion: @escaping (UserModel?) -> Void ) {
        if let databasePath = databasePath {
            databasePath.child(uid).observeSingleEvent(of: DataEventType.value) { (snapshot) in
                if snapshot.exists(), let json = snapshot.value {
                    do {
                        let userData = try JSONSerialization.data(withJSONObject: json)
                        let user = try self.decoder.decode(UserModel.self, from: userData)
                        completion(user)
                    } catch {
                        print("an error occurred", error)
                        completion(nil)
                    }
                } else {
                    print("doesn't exist")
                    completion(nil)
                }
            }
        }
    }

    func writeUser(uid: String) -> UserModel? {
        guard let databasePath = databasePath else {
            return nil
        }
        let userData = UserModel(uid: uid, balance: 2000)
        do {
            let data = try encoder.encode(userData)
            let json = try JSONSerialization.jsonObject(with: data)
            databasePath.child(uid).setValue(json)
            return userData
        } catch {
            print("an error occurred", error)
            return nil
        }
    }

    func update(balance: Int, uid: String) {
        guard let databasePath = databasePath else {
          return
        }
        
        databasePath.child(uid).updateChildValues(["balance": balance])
    }
}
