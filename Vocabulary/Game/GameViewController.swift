//
//  GameViewController.swift
//  Vocabulary
//
//  Created by user on 2020/07/31.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import VocaGame
import PoingVocaSubsystem

class GameViewController: UIViewController {
    enum GameType: String {
        case flip = "뒤집기"
        case matching = "매칭 게임"
    }

    enum Constant {
        static let backgroundColor = UIColor.gameBackgroundColor
        static let gameList: [GameType] = [.flip, .matching]
        static let spacing: CGFloat = 32
        enum Title {
            static let text = "함께 복습 해볼까요?"
            static let font = UIFont.systemFont(ofSize: 26, weight: .bold)
            static let textColor: UIColor = .midnight
        }
        enum Image {
            static let image = UIImage(named: "yellowFace")
            static let height: CGFloat = 130
        }
        enum Close {
            static let image = UIImage(named: "btnCloseWhite")
            static let height: CGFloat = 60
        }
    }

    var tableViewHeightConstraint: NSLayoutConstraint?

    lazy var titleStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = Constant.spacing
        return stack
    }()

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = Constant.Image.image
        return view
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constant.Title.text
        label.font = Constant.Title.font
        label.textColor = Constant.Title.textColor
        label.textAlignment = .center
        return label
    }()

    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var gameListCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GameCell.self, forCellWithReuseIdentifier: GameCell.reuseIdentifier)
        collectionView.backgroundColor = Constant.backgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 60, right: 0)
        return collectionView
    }()

    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constant.Close.image, for: .normal)
        button.addTarget(self, action: #selector(closeDidTap(_:)), for: .touchUpInside)
        button.layer.shadow(
            color: .cement20,
            alpha: 1,
            x: 0,
            y: 4,
            blur: 20,
            spread: 0
        )
        return button
    }()


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constant.backgroundColor
        configureLayout()
    }

    func configureLayout() {
        view.addSubview(titleStackView)
        view.addSubview(gameListCollectionView)
        view.addSubview(closeButton)

        closeButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(Constant.Close.height)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(hasTopNotch ? 0 : -16)
            make.centerX.equalTo(view)
        }

        titleStackView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(106)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        imageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(Constant.Image.height)
        }

        gameListCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleStackView.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    @objc func closeDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 96)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedGame = Constant.gameList[indexPath.row]
        switch selectedGame {
        case .flip:
            navigationController?.pushViewController(FlipGameViewController(words: []), animated: true)
        case .matching:
            var words: [WordCoreData] = []
            guard let groups = VocaManager.shared.groups else {
                return
            }
            for group in groups {
                words.append(contentsOf: group.words)
            }

            navigationController?.pushViewController(CardMatchingViewController(words: words), animated: true)
        }
    }
}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Constant.gameList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.reuseIdentifier, for: indexPath) as? GameCell else {
            return UICollectionViewCell()
        }
        cell.configure(title: Constant.gameList[indexPath.row].rawValue)
        return cell
    }
}
