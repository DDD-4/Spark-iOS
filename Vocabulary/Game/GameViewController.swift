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
        static let gameList: [GameType] = [.flip, .matching]
        static let spacing: CGFloat = 23
    }

    var tableViewHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        configureLayout()
    }

    func configureLayout() {
        view.addSubview(titleLabel)
        view.addSubview(gameListTableView)

        titleLabel.snp.makeConstraints { (make) in
//            make.centerX.equalTo(view)
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(gameListTableView.snp.top)
        }

        gameListTableView.snp.makeConstraints { (make) in
            make.centerY.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide)
        }

        tableViewHeightConstraint = gameListTableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.constant = (CGFloat(Constant.gameList.count) * GameCell.Constant.height) + ((CGFloat(Constant.gameList.count) - 1 ) * Constant.spacing)
        tableViewHeightConstraint?.isActive = true
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "복습 해볼까?"
        label.textAlignment = .center
        return label
    }()

    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var gameListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            GameCell.self,
            forCellReuseIdentifier: GameCell.reuseIdentifier
        )
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .gray
        return tableView
    }()
}

extension GameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = Constant.gameList[indexPath.section]
        switch selectedGame {
        case .flip:
            present(FlipGameViewController(words: [Word(korean: "kor", english: "eng", image: nil, identifier: nil)]), animated: true, completion: nil)
        case .matching:
            present(CardMatchingViewController(imageWords: [ImageWord(image: "icPicture", word: "eng")]), animated: true, completion: nil)
        }
    }
}

extension GameViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constant.gameList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constant.spacing
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GameCell.reuseIdentifier, for: indexPath) as? GameCell else {
            return UITableViewCell()
        }
        cell.configure(title: Constant.gameList[indexPath.section].rawValue)
        return cell
    }
}
