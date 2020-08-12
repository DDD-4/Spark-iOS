//
//  CardMatchingViewController.swift
//  VocaGame
//
//  Created by LEE HAEUN on 2020/07/18.
//

import UIKit
import SnapKit

var hasTopNotch: Bool {
  if #available(iOS 11.0, tvOS 11.0, *) {
    // with notch: 44.0 on iPhone X, XS, XS Max, XR.
    // without notch: 24.0 on iPad Pro 12.9" 3rd generation, 20.0 on iPhone 8 on iOS 12+.
    return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24
  }
  return false
}

public class CardMatchingViewController: UIViewController {

    struct CardMatchingGrid {
        let horizontal: Int
        let vertical: Int
    }

    enum Constant {
        static let spacing: CGFloat = 10
        static let maxSelectedCount: Int = 2
        enum Collection {
            static let topMargin: CGFloat = 28
        }
    }

    var cards: [CardMatching] = []
    var selectedCardRow: [Int] = []
    var correctCardRow: [Int] = []

    var currectCardCount: Int = 0 {
        didSet {
            progressNavigationView.setProgress(index: currectCardCount)
        }
    }

    var gridType: CardMatchingGrid? {
        let wordCount = cards.count / 2
        if wordCount < 4 {
            return nil
        } else if wordCount <= 4 {
            return CardMatchingGrid(horizontal: 2, vertical: 4)
        } else if wordCount <= 6 {
            return CardMatchingGrid(horizontal: 3, vertical: 4)
        } else if wordCount <= 8 {
            return CardMatchingGrid(horizontal: 4, vertical: 4)
        }

        return nil
    }

    lazy var progressNavigationView: ProgressBarNavigationView = {
        let view = ProgressBarNavigationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.closeButton.addTarget(
            self,
            action: #selector(closeDidTap(_:)),
            for: .touchUpInside
        )
        return view
    }()

    lazy var cardCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = Constant.spacing
        flowLayout.minimumLineSpacing = Constant.spacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = FlipGameViewController.Constant.backgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            CardCell.self,
            forCellWithReuseIdentifier: CardCell.reuseIdentifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
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
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical

        progressNavigationView.configire(maxCount: imageWords.count)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }

    func configureLayout() {
        view.backgroundColor = FlipGameViewController.Constant.backgroundColor

        view.addSubview(progressNavigationView)
        view.addSubview(cardCollectionView)

        progressNavigationView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(FlipGameViewController.Constant.navigationHeight)
        }

        cardCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(progressNavigationView.snp.bottom).offset(Constant.Collection.topMargin)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(hasTopNotch ? 0 : -Constant.Collection.topMargin)
        }
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
            correctCardRow.append(first)
            correctCardRow.append(second)
        }
    }

    func deselectCardIsNeeded() {
        if selectedCardRow.count > Constant.maxSelectedCount {
            let first = selectedCardRow[0]
            let second = selectedCardRow[1]
            if cards[first].uuid != cards[second].uuid {
                deSelectCard(row: first)
                deSelectCard(row: second)
            }
        }
    }

    func currectCard(row: Int) {
        selectedCardRow.removeFirst()
    }

    func SelectCard(row: Int) {
        selectedCardRow.append(row)

        guard let cell = cardCollectionView.cellForItem(at: IndexPath(row: row, section: 0)) as? CardCell else {
            return
        }
        cell.selected(color: .brightCyan)
        cell.setNeedsLayout()
    }

    func deSelectCard(row: Int) {
        let firstRow = selectedCardRow.removeFirst()
        guard let cell = cardCollectionView.cellForItem(at: IndexPath(row: firstRow, section: 0)) as? CardCell else {
            return
        }
        cell.deselected()
        cell.setNeedsLayout()
    }

    @objc func closeDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
        guard selectedCardRow.contains(indexPath.row) == false,
            correctCardRow.contains(indexPath.row) == false else {
            return
        }
        SelectCard(row: indexPath.row)
        isMatching()
        deselectCardIsNeeded()
    }
}

extension CardMatchingViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let currentGridTyp = gridType else {
            return .zero
        }

        let heightSpacing: CGFloat = (CGFloat((currentGridTyp.vertical - 1)) * Constant.spacing)
        var cellHeight = Int((collectionView.bounds.height - heightSpacing) / CGFloat(currentGridTyp.vertical))

        let widthSpacing: CGFloat = (CGFloat((currentGridTyp.horizontal - 1)) * Constant.spacing)
        var cellWidth = Int((collectionView.bounds.width - widthSpacing) / CGFloat(currentGridTyp.horizontal))

        if cellHeight <= cellWidth {
            cellWidth = cellHeight
            let sideMargin: CGFloat = floor(((collectionView.bounds.width - widthSpacing) - (CGFloat(cellWidth) * CGFloat(currentGridTyp.horizontal))) / 2)
            return UIEdgeInsets(top: 0, left: sideMargin, bottom: 0, right: sideMargin)
        } else if cellHeight > cellWidth {
            cellHeight = cellWidth
            let verticalMargin: CGFloat = ((collectionView.bounds.height - heightSpacing) - (CGFloat(cellHeight) * CGFloat(currentGridTyp.vertical))) / 2
            return UIEdgeInsets(top: verticalMargin, left: Constant.spacing, bottom: verticalMargin, right: Constant.spacing)
        }

        return .zero
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let currentGridTyp = gridType else {
            return .zero
        }

        let heightSpacing: CGFloat = (CGFloat((currentGridTyp.vertical - 1)) * Constant.spacing)
        var cellHeight = (collectionView.bounds.height - heightSpacing) / CGFloat(currentGridTyp.vertical)

        let widthSpacing: CGFloat = (CGFloat((currentGridTyp.horizontal + 1)) * Constant.spacing)
        var cellWidth = (collectionView.bounds.width - widthSpacing) / CGFloat(currentGridTyp.horizontal)

        if cellHeight <= cellWidth {
            cellWidth = cellHeight
        } else if cellHeight > cellWidth {
            cellHeight = cellWidth
        }

        return CGSize(width: Int(cellWidth), height: Int(cellHeight))
    }
}
