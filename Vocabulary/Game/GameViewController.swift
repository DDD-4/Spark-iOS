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

    lazy var guideContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var guideCenterContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        collectionView.contentInset = .zero
        collectionView.clipsToBounds = false
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
        view.addSubview(guideContainerView)
        guideContainerView.addSubview(guideCenterContainerView)
        guideCenterContainerView.addSubview(imageView)
        guideCenterContainerView.addSubview(titleLabel)
        guideCenterContainerView.addSubview(gameListCollectionView)
        view.addSubview(closeButton)

        closeButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(Constant.Close.height)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(hasTopNotch ? 0 : -16)
            make.centerX.equalTo(view)
        }

        guideContainerView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(closeButton.snp.top)
        }

        guideCenterContainerView.snp.makeConstraints { (make) in
            make.center.leading.trailing.equalTo(guideContainerView).priority(.high)
            make.top.lessThanOrEqualTo(guideContainerView).priority(.low)
            make.bottom.greaterThanOrEqualTo(guideContainerView).priority(.low)
        }

        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(guideCenterContainerView)
            make.centerX.equalTo(guideCenterContainerView)
            make.height.width.equalTo(Constant.Image.height)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(guideCenterContainerView)
            make.centerX.equalTo(guideCenterContainerView)
        }

        gameListCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalTo(guideCenterContainerView)
            make.bottom.equalTo(guideCenterContainerView)
            make.height.equalTo((96 * Constant.gameList.count) + 16)
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

        let selectFolderViewController: VocaGame.SelectFolderViewController
        if ModeConfig.shared.currentMode == .offline {
            selectFolderViewController = VocaGame.SelectFolderViewController(
                VocaManager.shared.groups ?? [],
                gameType: selectedGame
            )
        } else {
            selectFolderViewController = VocaGame.SelectFolderViewController(
                FolderManager.shared.myFolders,
                gameType: selectedGame
            )
        }

        navigationController?.pushViewController(selectFolderViewController, animated: true)
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
