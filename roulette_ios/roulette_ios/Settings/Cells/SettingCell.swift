//
//  SettingCell.swift
//  roulette_ios
//
//  Created by Arthur on 15.08.2023.
//

import UIKit

class SettingCell: UITableViewCell {
    @IBOutlet private weak var settingLabel: UILabel!

    static let reuseIdentifier = "SettingCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 12
        layer.masksToBounds = true
        layer.borderColor = UIColor.yellow.cgColor
        layer.borderWidth = 3
    }

    func setup(with title: String) {
        self.settingLabel.text = title
    }
}
