//
//  GameViewModel.swift
//  roulette_ios
//
//  Created by Arthur on 13.08.2023.
//

import Foundation

protocol GameViewModelDelegate: NSObject {
    func updateView(balance: Int)
}

class GameViewModel {
    weak var delegate: GameViewModelDelegate!

    var balance: Int = 0
    let gameSectors = RouletteSector.sectorsArray
    
    var  availableBets: [[BetVariant]] = {
        let firstSection = [
            BetVariant(type: .number(0), color: .green)
        ]
        let secondSection: [BetVariant] = RouletteSector.sectorsArray.sorted(by: { $0 < $1 }).compactMap {
            guard $0.number != 0 else { return nil
            }
            return BetVariant(type: .number($0.number), color: $0.color)
        }
        let thirdSection = [
            BetVariant(type: .first12, color: .green),
            BetVariant(type: .second12, color: .green),
            BetVariant(type: .third12, color: .green)
        ]
        let fourthSection = [
            BetVariant(type: .range(SectorRangeConstants.start18), color: .green),
            BetVariant(type: .even, color: .green),
            BetVariant(type: .color(.red), color: .red),
            BetVariant(type: .color(.black), color: .black),
            BetVariant(type: .odd, color: .green),
            BetVariant(type: .range(SectorRangeConstants.end18), color: .green),
        ]
        return [firstSection, secondSection, thirdSection, fourthSection]
    }()

    func updateBalance() {
        if let user = AuthenticationManager.shared.isLoggedIn() {
            DatabaseManager.shared.getUser(uid: user.uid) { userModel in
                guard let userModel = userModel else { return }
                self.balance = userModel.balance
                self.delegate.updateView(balance: self.balance)
            }
        }
    }

    func startGame(stepCount: Int, and indexPath: IndexPath, completion: (RouletteSector) -> Void) {
        guard var betVariant = self.getBetVariant(for: indexPath) else { return }
        let betAmount = balance/10 * stepCount
        betVariant.amount = betAmount
        guard let selectedSector = self.gameSectors.randomElement() else {
            debugPrint("Error")
            return
        }
        self.balance -= betAmount
        self.balance += self.handleWinning(for: selectedSector, betVariant: betVariant)
        if let user = AuthenticationManager.shared.isLoggedIn() {
            DatabaseManager.shared.update(balance: self.balance, uid: user.uid)
            self.delegate.updateView(balance: self.balance)
        }
    }

    private func getBetVariant(for indexPath: IndexPath) -> BetVariant? {
        guard indexPath.section <= availableBets.count,
              indexPath.row <= availableBets[indexPath.section].count else { return nil }
        let variant = availableBets[indexPath.section][indexPath.row]
        return variant
    }

    func handleWinning(for sector: RouletteSector, betVariant: BetVariant) -> Int {
        var totalWinning = 0
        guard let amount = betVariant.amount else { return 0 }

        switch betVariant.type {
        case .color(let color):
            if sector.color == color {
                totalWinning = amount * 2
            }
        case .number(let number):
            if sector.number == number {
                totalWinning = amount * 37
            }
        case .range(let range):
            if range.contains(sector.number) {
                totalWinning = amount * 19
            }
        case .even:
            if sector.number != 0, sector.number % 2 == 0 {
                totalWinning = amount * 2
            }
        case .odd:
            if sector.number != 0, sector.number % 2 != 0 {
                totalWinning = amount * 2
            }
        case .first12, .second12, .third12:
            var range: Range<Int> = .init(uncheckedBounds: (lower: 0, upper: 0))
            
            switch betVariant.type {
            case .first12: range = SectorRangeConstants.first12
            case .second12: range = SectorRangeConstants.second12
            case .third12: range = SectorRangeConstants.third12
            default: break
            }
            if range.contains(sector.number) {
                totalWinning = amount * 3
            }
        }
        return totalWinning
    }
}
