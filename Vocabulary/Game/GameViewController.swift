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
import Voca

class GameViewController: UIViewController {

    enum GameType: String {
        case flip = "뒤집기"
        case matching = "매칭 게임"
    }

    enum Constant {
        static let gameList: [GameType] = [.flip, .matching]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        configureLayout()
    }

    func configureLayout() {
        view.addSubview(titleLabel)
        view.addSubview(gameListTableView)

        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(89)
        }

        gameListTableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "복습 해볼까?"
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
        tableView.backgroundColor = .gray
        return tableView
    }()
}

extension GameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = Constant.gameList[indexPath.row]
        switch selectedGame {
        case .flip:
            present(FlipGameViewController(words: [Word(korean: "kor", english: "eng", image: nil, identifier: nil)]), animated: true, completion: nil)
        case .matching:
            present(CardMatchingViewController(imageWords: [ImageWord(image: "icPicture", word: "eng")]), animated: true, completion: nil)
        }
    }
}

extension GameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constant.gameList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GameCell.reuseIdentifier, for: indexPath) as? GameCell else {
            return UITableViewCell()
        }
        cell.configure(title: Constant.gameList[indexPath.row].rawValue)
        return cell
    }
}
