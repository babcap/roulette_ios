//
//  CustomCollectionViewFlowLayout.swift
//  roulette_ios
//
//  Created by Arthur on 13.08.2023.
//

import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    let columnCount: Int
    let rowCount: Int

    private var size: CGSize = .zero

    init(columns: Int, rows: Int) {
        self.columnCount = columns
        self.rowCount = rows

        super.init()
        self.minimumInteritemSpacing = 1
        self.minimumLineSpacing = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    func updateItems(with size: CGSize) {
        self.size = size
    }

    func getItemSize() -> CGSize {
        let columns = CGFloat(self.columnCount)
        let rows = CGFloat(self.rowCount)
        return CGSize(width: (self.size.width - columns) / columns,
                      height: (self.size.height - rows) / rows)
    }
}
