//
//  SKStoreReviewController+Extensions.swift
//  roulette_ios
//
//  Created by Arthur on 15.08.2023.
//

import StoreKit

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}
