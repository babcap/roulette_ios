//
//  Models.swift
//  roulette_ios
//
//  Created by Arthur on 15.08.2023.
//

import UIKit

enum BetType {
    case number(Int)
    case range(Range<Int>)
    case even
    case odd
    case color(RouletteColor)
    case first12
    case second12
    case third12
}

struct Constants {
    static let greenColor = UIColor.init(hexString: "#006600")
    static let redColor = UIColor.init(hexString: "#FF0000")
}

enum RouletteColor {
    case red
    case black
    case green

    func color() -> UIColor {
        switch self {
        case .red:
            return Constants.redColor
        case .black:
            return .black
        case .green:
            return Constants.greenColor
        }
    }
}

struct Bet {
    let type: BetType
    var amount: Int
}

struct BetVariant {
    let type: BetType
    let color: RouletteColor

    var betString: String {
        var resultString = ""
        switch type {
        case .number(let number):
            resultString =  "\(number)"
        case .range(let range):
            switch range {
            case SectorRangeConstants.start18:
                resultString = "1-18"
            case SectorRangeConstants.end18:
                resultString = "19-36"
            default: break
            }
        case .even:
            resultString =  "Even"
        case .odd:
            resultString =  "Odd"
        case .color(let rouletteColor):
            switch rouletteColor {
            case .red:
                resultString =  "Red"
            case .black:
                resultString =  "Black"
            default: break
            }
        case .first12:
            resultString = "1st 12"
        case .second12:
            resultString = "2nd 12"
        case .third12:
            resultString = "3rd 12"
        }

        return resultString
    }
}

struct SectorRangeConstants {
    static let first12: Range<Int> = 1..<13
    static let second12: Range<Int> = 13..<25
    static let third12: Range<Int> = 25..<37
    static let start18: Range<Int> = 1..<19
    static let end18: Range<Int> = 19..<36
}

struct RouletteSector: Comparable {
    static func < (lhs: RouletteSector, rhs: RouletteSector) -> Bool {
        lhs.number < rhs.number
    }
    
    let number: Int
    let color: RouletteColor
    static let sectorsArray: [RouletteSector] = [
        RouletteSector(number: 0, color: .green),
        RouletteSector(number: 32, color: .red),
        RouletteSector(number: 15, color: .black),
        RouletteSector(number: 19, color: .red),
        RouletteSector(number: 4, color: .black),
        RouletteSector(number: 21, color: .red),
        RouletteSector(number: 2, color: .black),
        RouletteSector(number: 25, color: .red),
        RouletteSector(number: 17, color: .black),
        RouletteSector(number: 34, color: .red),
        RouletteSector(number: 6, color: .black),
        RouletteSector(number: 27, color: .red),
        RouletteSector(number: 13, color: .black),
        RouletteSector(number: 36, color: .red),
        RouletteSector(number: 11, color: .black),
        RouletteSector(number: 30, color: .red),
        RouletteSector(number: 8, color: .black),
        RouletteSector(number: 23, color: .red),
        RouletteSector(number: 10, color: .black),
        RouletteSector(number: 5, color: .red),
        RouletteSector(number: 24, color: .black),
        RouletteSector(number: 16, color: .red),
        RouletteSector(number: 33, color: .black),
        RouletteSector(number: 1, color: .red),
        RouletteSector(number: 20, color: .black),
        RouletteSector(number: 14, color: .red),
        RouletteSector(number: 31, color: .black),
        RouletteSector(number: 9, color: .red),
        RouletteSector(number: 22, color: .black),
        RouletteSector(number: 18, color: .red),
        RouletteSector(number: 29, color: .black),
        RouletteSector(number: 7, color: .red),
        RouletteSector(number: 28, color: .black),
        RouletteSector(number: 12, color: .red),
        RouletteSector(number: 35, color: .black),
        RouletteSector(number: 3, color: .red),
        RouletteSector(number: 26, color: .black),
    ]

}
