//
//  GameViewController.swift
//  roulette_ios
//
//  Created by Arthur on 12.08.2023.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet private weak var rouletteView: UIView!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    let reuseIdentifier = "cell"
    var items: [BetType] = [BetType]()
    var selectedBets: [Bet] = [Bet]()
    private let output = GameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.items = self.output.gameSectors
            .sorted(by: { $0 < $1 })
            .map({ BetType.number($0.number)})
        
        self.setupCollectionView()
        self.setupCollectionViewFlowLayout()
//        self.setupAdditionalButtons()
    }

//    private func setupAdditionalButtons() {
//        let buttonsArray = [first12Button, second12Button, third12Button, till18Button, evenButton, redButton, blackButton, oddButton, from19To36Button]
//        buttonsArray.forEach {
//            $0?.titleLabel?.textColor = .white
////            $0?.titleLabel?.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 2))
//            $0?.layer.borderColor = UIColor.white.cgColor
//            $0?.layer.borderWidth = 1
//
//            switch $0 {
//            case blackButton:
//                $0?.backgroundColor = .black
//            case redButton:
//                $0?.backgroundColor = .red
//            default:
//                $0?.backgroundColor = .green
//            }
//        }
//        self.first12Button.titleLabel?.text = "1st 12"
//        self.second12Button.titleLabel?.text = "2nd 12"
//        self.third12Button.titleLabel?.text = "3rd 12"
//        self.till18Button.titleLabel?.text = "1-18"
//        self.evenButton.titleLabel?.text = "Even"
//        self.redButton.titleLabel?.text = "Red"
//        self.blackButton.titleLabel?.text = "Black"
//        self.oddButton.titleLabel?.text = "Odd"
//        self.from19To36Button.titleLabel?.text = "19-36"
//    }

    private func setupCollectionView() {
        self.collectionView.register(DefaultBetCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        self.collectionView.isScrollEnabled = false
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    private func setupCollectionViewFlowLayout() {
        let layout = CustomCollectionViewFlowLayout(columns: 3, rows: 13)
        self.collectionView?.collectionViewLayout = layout
    }

}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.output.availableBets.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section <= self.output.availableBets.count else { return 0 }
        return self.output.availableBets[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! DefaultBetCollectionViewCell
        let betVariant = self.output.availableBets[indexPath.section][indexPath.row]
        cell.setup(with: betVariant)

        return cell
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellsAcross: CGFloat = 3
        let dim = (collectionView.bounds.width - (cellsAcross - 1)) / cellsAcross
        return CGSize(width: dim, height: collectionView.bounds.height/13)
    }
}
