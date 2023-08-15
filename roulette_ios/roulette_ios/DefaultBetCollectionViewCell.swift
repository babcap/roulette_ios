//
//  DefaultBetCollectionViewCell.swift
//  roulette_ios
//
//  Created by Arthur on 13.08.2023.
//

import UIKit

class DefaultBetCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCell"

    override var isSelected: Bool {
        didSet {
            self.layer.borderColor = isSelected ? UIColor.blue.cgColor : UIColor.white.cgColor
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Custom Cell"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(label)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with variant: BetVariant) {
        self.label.text = variant.betString
        self.backgroundColor = variant.color.color()
    }
}
