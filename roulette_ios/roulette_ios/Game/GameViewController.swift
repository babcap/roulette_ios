//
//  GameViewController.swift
//  roulette_ios
//
//  Created by Arthur on 12.08.2023.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet private weak var profileView: UIView!
    @IBOutlet private weak var profileNameLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var rouletteView: UIView!
    @IBOutlet private weak var rouletteLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var stepper: UIStepper!
    @IBOutlet private weak var betView: UIView!
    @IBOutlet private weak var betTitleLabel: UILabel!
    @IBOutlet private weak var betCountLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!

    let reuseIdentifier = "cell"
    private let output = GameViewModel()
    private var selectedCellIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.output.delegate = self

        self.setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.output.updateBalance()
    }

    private func setupUI() {
        self.view.backgroundColor = .darkGray
        self.setupRouletteView(with: RouletteSector(number: 0, color: .green))
        self.setupStepperView()
        self.setupBetView()
        self.setupProfileViewView()
        self.setupCollectionView()
        self.setupCollectionViewFlowLayout()
    }

    private func setupProfileViewView() {
        self.profileView.layer.cornerRadius = 12
        self.profileView.layer.borderColor = UIColor.yellow.cgColor
        self.profileView.layer.borderWidth = 3
    }

    private func setupBetView() {
        self.betView.layer.cornerRadius = 12
        self.betView.backgroundColor = RouletteColor.green.color()
        self.betView.layer.borderColor = UIColor.yellow.cgColor
        self.betView.layer.borderWidth = 3
        self.startButton.setTitle("Start", for: .normal)
        self.startButton.setTitleColor(.black, for: .normal)
        self.startButton.tintColor = .cyan
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
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    private func setupCollectionViewFlowLayout() {
        let layout = CustomCollectionViewFlowLayout(columns: 3, rows: 13)
        self.collectionView?.collectionViewLayout = layout
    }

    private func setupRouletteView(with sector: RouletteSector) {
        self.rouletteView.backgroundColor = sector.color.color()
        self.rouletteLabel.text = "\(sector.number)"
    }

    @IBAction private func onStepperChanged(_ sender: Any) {
        self.betCountLabel.text = "\(Int(self.stepper.value))"
    }

    @IBAction private func onStartButton(_ sender: Any) {
        guard let indexPath = self.selectedCellIndexPath else { return }
        self.output.startGame(stepCount: Int(self.stepper.value), and: indexPath) { sector in
            self.setupRouletteView(with: sector)
        }
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
        self.selectedCellIndexPath = indexPath
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellsAcross: CGFloat = 3
        let dim = (collectionView.bounds.width - (cellsAcross - 1)) / cellsAcross
        return CGSize(width: dim, height: collectionView.bounds.height/13)
    }
}

extension GameViewController: GameViewModelDelegate {
    func updateView(model: UserModel) {
        DispatchQueue.main.async {
            self.profileNameLabel.text = model.name
            self.balanceLabel.text = "\(model.balance)"
        }
    }
}
