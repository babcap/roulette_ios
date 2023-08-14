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
    let gameSectors = RouletteSector.defaultGame()
    let availableBets: [[BetVariant]] = [
        [
            BetVariant(type: .number(0))
        ],
        [
            BetVariant(type: .number(0)),
            BetVariant(type: .number(1)),
            BetVariant(type: .number(2)),
            BetVariant(type: .number(3)),
            BetVariant(type: .number(4)),
            BetVariant(type: .number(5)),
            BetVariant(type: .number(6)),
            BetVariant(type: .number(7)),
            BetVariant(type: .number(8)),
            BetVariant(type: .number(9)),
            BetVariant(type: .number(10)),
            BetVariant(type: .number(11)),
            BetVariant(type: .number(12)),
            BetVariant(type: .number(13)),
            BetVariant(type: .number(14)),
            BetVariant(type: .number(15)),
            BetVariant(type: .number(16)),
            BetVariant(type: .number(17)),
            BetVariant(type: .number(18)),
            BetVariant(type: .number(19)),
            BetVariant(type: .number(20)),
            BetVariant(type: .number(21)),
            BetVariant(type: .number(22)),
            BetVariant(type: .number(23)),
            BetVariant(type: .number(24)),
            BetVariant(type: .number(25)),
            BetVariant(type: .number(26)),
            BetVariant(type: .number(27)),
            BetVariant(type: .number(28)),
            BetVariant(type: .number(29)),
            BetVariant(type: .number(30)),
            BetVariant(type: .number(31)),
            BetVariant(type: .number(32)),
            BetVariant(type: .number(33)),
            BetVariant(type: .number(34)),
            BetVariant(type: .number(35)),
            BetVariant(type: .number(36)),
        ],
        [
            BetVariant(type: .first12),
            BetVariant(type: .second12),
            BetVariant(type: .third12)
        ],
        [
            BetVariant(type: .range(SectorRangeConstants.start18)),
            BetVariant(type: .even),
            BetVariant(type: .color(.red)),
            BetVariant(type: .color(.black)),
            BetVariant(type: .odd),
            BetVariant(type: .range(SectorRangeConstants.end18)),
        ],
        
    ]
    
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
