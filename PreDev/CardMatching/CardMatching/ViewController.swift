//
//  ViewController.swift
//  CardMatching
//
//  Created by LEE HAEUN on 2020/07/18.
//

import UIKit

public class CardMatchingViewController: UIViewController {
    enum Constant {
        static let spacing: CGFloat = 20
        static let maxSelectedCount: Int = 2
    }

    var cards: [CardMatching] = []
    var selectedCardRow: [Int] = []

    var currectCardCount: Int = 0 {
        didSet {
            currectLabel.text = "정답 개수: \(currectCardCount)"
        }
    }

    lazy var cardCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            CardCell.self,
            forCellWithReuseIdentifier: CardCell.reuseIdentifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    lazy var currectLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var cardHeightConstraint: NSLayoutConstraint?

    public init(imageWords: [ImageWord]) {
        for word in imageWords {
            guard let wordImage = UIImage(named: word.image) else {
                continue
            }
            let currentUUID = UUID()
            let image = CardMatching(
                contentType: .image(wordImage),
                uuid: currentUUID
            )
            let word = CardMatching(
                contentType: .text(word.word),
                uuid: currentUUID
            )
            cards.append(image)
            cards.append(word)
        }

        cards.shuffle()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }

    func configureLayout() {
        view.backgroundColor = .white

        view.addSubview(cardCollectionView)
        view.addSubview(currectLabel)

        NSLayoutConstraint.activate([
            cardCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cardCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cardCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            cardCollectionView.heightAnchor.constraint(equalToConstant: 400),

            currectLabel.centerXAnchor.constraint(equalTo: cardCollectionView.centerXAnchor),
            currectLabel.topAnchor.constraint(equalTo: cardCollectionView.bottomAnchor, constant: 30)
        ])

    }

    func isMatching() {
        guard selectedCardRow.count == 2 else {
            return
        }
        let first = selectedCardRow[0]
        let second = selectedCardRow[1]

        if cards[first].uuid == cards[second].uuid {
            currectCardCount += 1
            currectCard(row: first)
            currectCard(row: second)
        }
    }

    func currectCard(row: Int) {
        selectedCardRow.removeFirst()
        guard let cell = cardCollectionView.cellForItem(at: IndexPath(row: row, section: 0)) as? CardCell else {
            return
        }
        UIView.transition(
            with: cell,
            duration: 0.3,
            options: [.transitionCurlUp],
            animations: {
                cell.frontView.isHidden = !cell.frontView.isHidden
            },
            completion: nil
        )
    }

    func SelectCard(row: Int) {
        selectedCardRow.append(row)

        guard let cell = cardCollectionView.cellForItem(at: IndexPath(row: row, section: 0)) as? CardCell else {
            return
        }
        cell.selectedImage.isHidden = !cell.selectedImage.isHidden
        cell.setNeedsLayout()
    }

    func deSelectCard(row: Int) {
        let firstRow = selectedCardRow.removeFirst()
        guard let cell = cardCollectionView.cellForItem(at: IndexPath(row: firstRow, section: 0)) as? CardCell else {
            return
        }
        cell.selectedImage.isHidden = !cell.selectedImage.isHidden
        cell.setNeedsLayout()
    }
}

extension CardMatchingViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.reuseIdentifier, for: indexPath) as? CardCell else {
            return UICollectionViewCell()
        }
        cell.configure(card: cards[indexPath.row])
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard selectedCardRow.contains(indexPath.row) == false else {
            return
        }
        if selectedCardRow.count >= Constant.maxSelectedCount {
            deSelectCard(row: indexPath.row)
        }
        SelectCard(row: indexPath.row)
        isMatching()
    }
}

extension CardMatchingViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSpcing = 2 * Constant.spacing
        let width = (collectionView.bounds.width - cellSpcing) / 4
        return CGSize(width: width, height: width)
    }
}
