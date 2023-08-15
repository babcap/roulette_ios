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
    @IBOutlet private weak var stepper: UIStepper!
    @IBOutlet private weak var betTitleLabel: UILabel!
    @IBOutlet private weak var betCountLabel: UILabel!

    let reuseIdentifier = "cell"
    private let output = GameViewModel()
    private var selectedCellIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupStepperView()
        self.setupCollectionView()
        self.setupCollectionViewFlowLayout()
    }

    private func setupStepperView() {
        self.setupStepper()
        self.betTitleLabel.text = "BET"
        self.betCountLabel.text = "\(Int(self.stepper.value))"
    }

    private func setupStepper() {
        stepper.minimumValue = 1.0
        stepper.maximumValue = 10.0
        stepper.value = 0
        stepper.autorepeat = false
    }

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

    @IBAction private func onStepperChanged(_ sender: Any) {
        self.betCountLabel.text = "\(Int(self.stepper.value))"
    }

    @IBAction private func onStartButton(_ sender: Any) {
        guard let indexPath = self.selectedCellIndexPath else { return }
        self.output.startGame(stepCount: Int(self.stepper.value), and: indexPath)
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellsAcross: CGFloat = 3
        let dim = (collectionView.bounds.width - (cellsAcross - 1)) / cellsAcross
        return CGSize(width: dim, height: collectionView.bounds.height/13)
    }
}
