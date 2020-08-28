//
//  DummyVocaDetailViewController.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/08/24.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingVocaSubsystem
import RxSwift
import RxCocoa
import SnapKit

class DummyVocaDetailViewController: UIViewController {

    // MARK: - Properties
    lazy var vocaCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical // 스크롤 방향
        flowLayout.minimumLineSpacing = 16 // 최소라인간격
        flowLayout.minimumInteritemSpacing = 0 // 최소 내부 여백
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(
            WordDetailCell.self,
            forCellWithReuseIdentifier: WordDetailCell.reuseIdentifier
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    lazy var saveButton: BaseButton = {
        let button = BaseButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.setTitle("모두 저장하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        return button
    }()

    static let photoIdentifier = "DetailsCollectionViewCell"
    let disposeBag = DisposeBag()
    let wordDownload: [WordDownload]

    init(wordDownload: [WordDownload]) {
        self.wordDownload = wordDownload
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureRx()
    }

    override func viewWillDisappear(_ animated: Bool) {
    }

    func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(saveButton)
        view.bringSubviewToFront(saveButton)
        view.addSubview(vocaCollectionView)

        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }

        vocaCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(saveButton.snp.top).offset(-10)
        }
    }

    func configureRx() {

        self.saveButton.rx.tap.subscribe(onNext: {[weak self] (_) in
            let viewController = SelectVocaViewController()
            viewController.delegate = self
            self?.present(viewController, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
}

extension DummyVocaDetailViewController: SelectVocaViewControllerDelegate {
    func selectVocaViewController(didTapGroup group: Group) {

        LoadingView.show()
        let agent = VocaDownloadAgent(data: wordDownload)
        agent.download { [weak self] (words) in
            guard let self = self else {
                LoadingView.hide()
                return
            }

            VocaManager.shared.update(group: group, addWords: words) {

                LoadingView.hide()
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension DummyVocaDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wordDownload.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WordDetailCell.reuseIdentifier,
                for: indexPath
        ) as? WordDetailCell else {
            return UICollectionViewCell()
        }
//        cell.configure(word: words[indexPath.row])
        cell.configure(wordDownload: wordDownload[indexPath.row])

        return cell
    }
}

extension DummyVocaDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 11) / 2 , height: (collectionView.frame.width - 11) / 2 + 70)
    }
}

