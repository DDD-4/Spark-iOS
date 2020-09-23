//
//  CardMatchingViewController.swift
//  VocaGame
//
//  Created by LEE HAEUN on 2020/07/18.
//

import UIKit
import SnapKit
import PoingVocaSubsystem

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

    var completeCardCount: Int = 0

    var gridType: CardMatchingGrid? {
        let wordCount = cards.count / 2
        if wordCount < 4 {
            return nil
        } else if wordCount <= 4 && wordCount < 6{
            return CardMatchingGrid(horizontal: 2, vertical: 4)
        } else if wordCount <= 6 && wordCount < 8 {
            return CardMatchingGrid(horizontal: 3, vertical: 4)
        } else if wordCount <= 8 {
            return CardMatchingGrid(horizontal: 4, vertical: 4)
        }

        return nil
    }

    private var scoreAnimationView: ScoreAnimateView?

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

    public init(words: [WordCoreData]) {
        super.init(nibName: nil, bundle: nil)

        let shuffledWord = words.shuffled()
        completeCardCount = getMaxCount(words: words)
        let currentWord = shuffledWord[0...completeCardCount - 1]

        for word in currentWord {
            guard let imageData = word.image,
                let wordImage = UIImage(data: imageData) else {
                continue
            }
            let english = word.english
            let currentUUID = UUID()
            let color = UIColor().HSBRandomColor()
            let image = CardMatching(
                contentType: .image(wordImage),
                uuid: currentUUID,
                color: color
            )
            let word = CardMatching(
                contentType: .text(english),
                uuid: currentUUID,
                color: color
            )
            cards.append(image)
            cards.append(word)
        }

        cards.shuffle()

        progressNavigationView.configire(maxCount: currentWord.count)
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
            correctCard(first: first, second: second)


            if currectCardCount == completeCardCount {
                present(StudyCompleteViewController(), animated: true, completion: nil)
            }
        } else {
            incorrectCard(first: first, second: second)
        }
    }

    func correctCard(first: Int, second: Int) {
        correctAnimation()

        currectCard(row: first)
        currectCard(row: second)

        correctCardRow.append(first)
        correctCardRow.append(second)
    }

    func incorrectCard(first: Int, second: Int) {
        incorrectAnimation()
        
        deSelectCard(row: first)
        deSelectCard(row: second)
    }

    func currectCard(row: Int) {
        selectedCardRow.removeFirst()
    }

    func SelectCard(row: Int) {
        selectedCardRow.append(row)

        guard let cell = cardCollectionView.cellForItem(at: IndexPath(row: row, section: 0)) as? CardCell else {
            return
        }
        cell.selected()
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

    func correctAnimation() {
        scoreAnimationView?.removeFromSuperview()
        let animateView = ScoreAnimateView(type: .Correct)
        scoreAnimationView = animateView

        view.addSubview(animateView)
        animateView.frame = view.frame

        animateView.startAnimation { [weak self] in
            self?.scoreAnimationView?.removeFromSuperview()
        }
    }

    func incorrectAnimation() {
        scoreAnimationView?.removeFromSuperview()
        let animateView = ScoreAnimateView(type: .Incorrect)
        scoreAnimationView = animateView

        view.addSubview(animateView)
        animateView.frame = view.frame

        animateView.startAnimation { [weak self] in
            self?.scoreAnimationView?.removeFromSuperview()
        }
    }

    @objc func closeDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    func getMaxCount(words: [WordCoreData]) -> Int {
        let wordCount = words.count
        if wordCount < 4 {
            return 0
        } else if 4 <= wordCount && wordCount < 6 {
            return 4
        } else if 6 <= wordCount && wordCount < 8 {
            return 6
        } else if 8 <= wordCount {
            return 8
        }
        return 0
    }
}

extension CardMatchingViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CardCell.reuseIdentifier,
                for: indexPath
        ) as? CardCell else {
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
