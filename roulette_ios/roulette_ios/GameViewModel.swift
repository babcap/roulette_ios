//
//  GameViewModel.swift
//  roulette_ios
//
//  Created by Arthur on 13.08.2023.
//

import Foundation
import UIKit


class GameViewModel {
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

    var selectedBet: Bet?

    func getRandomSector() {
        guard let selectedSector = self.gameSectors.randomElement() else {
            debugPrint("Error")
            return
        }
        
        balance += self.handleWinning(for: selectedSector)
    }

    func handleWinning(for sector: RouletteSector) -> Int {
        var totalWinning = 0
        guard let bet = selectedBet else { return 0 }

        switch bet.type {
        case .color(let color):
            if sector.color == color {
                totalWinning = bet.amount * 2
            }
        case .number(let number):
            if sector.number == number {
                totalWinning = bet.amount * 37
            }
        case .range(let range):
            if range.contains(sector.number) {
                totalWinning = bet.amount * 19
            }
        case .even:
            if sector.number != 0, sector.number % 2 == 0 {
                totalWinning = bet.amount * 2
            }
        case .odd:
            if sector.number != 0, sector.number % 2 != 0 {
                totalWinning = bet.amount * 2
            }
        case .first12, .second12, .third12:
            var range: Range<Int> = .init(uncheckedBounds: (lower: 0, upper: 0))
            
            switch bet.type {
            case .first12: range = SectorRangeConstants.first12
            case .second12: range = SectorRangeConstants.second12
            case .third12: range = SectorRangeConstants.third12
            default: break
            }
            if range.contains(sector.number) {
                totalWinning = bet.amount * 3
            }
        }
        return totalWinning
    }

//    func takeBet(for type: BetType, with ) -> [Bet] {
//        var bet: [Bet] = []
//        var remainingBalance = balance
//
//        while remainingBalance > 0 {
//            print("Your balance: \(remainingBalance)")
//            let betAmountStep = remainingBalance / 10
//
//            let maxBetAmount = remainingBalance
//            let allowedStep = maxBetAmount / 10
//
//            print("Enter your bet amount (Step: \(allowedStep), Max: \(maxBetAmount)):")
//            guard let betAmount = takeBetAmount(maxAmount: maxBetAmount, step: allowedStep) else {
//                print("Invalid bet amount.")
//                continue
//            }
//
//            bets.append(Bet(type: type, amount: betAmount))
//            remainingBalance -= betAmount
//        }
//
//        return bets
//    }

//    func playRoulette() {
//
//    while balance > 0 {
//    if balance < 100 {
//    balance += 100
//    print("You've been granted 100 chips!")
//    }
//
//    let bets = takeBet(balance: &balance)
//    if bets.isEmpty {
//    print("No bets placed. Exiting.")
//    break
//    }
//
//    let spunColor = getRandomSector()
//    let totalWinnings = calculateWinnings(bets: bets, spunColor: spunColor)
//
//    balance += totalWinnings
//
//    if totalWinnings > 0 {
//    print("Congratulations! You won \(totalWinnings) chips.")
//    } else {
//    print("Sorry, you lost.")
//    }
//
//    print("Your balance: \(balance)")
//    }
//
//    print("Game over. Your final balance: \(balance)")
//    }
}
