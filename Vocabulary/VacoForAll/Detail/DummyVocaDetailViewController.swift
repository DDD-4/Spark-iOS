//
//  DummyVocaDetailViewController.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/08/24.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingVocaSubsystem
import PoingDesignSystem
import RxSwift
import RxCocoa
import SnapKit

class DummyVocaDetailViewController: UIViewController {
    enum Constant {
        enum Floating {
            static let height: CGFloat = 60
            static let width: CGFloat = 206
        }
        static let buttonRadius: CGFloat = 30
    }
    
    // MARK: - Properties
    lazy var naviView: SideNavigationView = {
        let view = SideNavigationView(leftImage: UIImage(named: "icArrow"), centerTitle: nil, rightImage: nil)
        view.leftSideButton.addTarget(self, action: #selector(tapLeftButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var headerView: VocaHeaderView = {
        let view = VocaHeaderView(vocaTitle: vocaTitle, profileName: "홍길동", profileImage: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var vocaCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical // 스크롤 방향
        flowLayout.minimumLineSpacing = 11 // 최소라인간격
        flowLayout.minimumInteritemSpacing = 11 // 최소 내부 여백
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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
        button.layer.cornerRadius = Constant.buttonRadius
        button.setTitle("모두 저장하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
        button.backgroundColor = .brightSkyBlue
        button.layer.masksToBounds = false
        return button
    }()

    static let photoIdentifier = "DetailsCollectionViewCell"
    let disposeBag = DisposeBag()
    let wordDownload: [WordDownload]
    let vocaTitle: String

    init(title: String, wordDownload: [WordDownload]) {
        self.vocaTitle = title
        self.wordDownload = wordDownload
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
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
        view.addSubview(naviView)
        view.addSubview(headerView)
        view.addSubview(vocaCollectionView)
        view.addSubview(saveButton)

        naviView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(naviView.snp.bottom).offset(24)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(57)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-57)
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(hasTopNotch ? 0 : -16)
            make.centerX.equalTo(view)
            make.height.equalTo(Constant.Floating.height)
            make.width.equalTo(Constant.Floating.width)
        }

        vocaCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(37)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }
    }

    func configureRx() {

        self.saveButton.rx.tap.subscribe(onNext: {[weak self] (_) in
            let viewController = SelectVocaViewController()
            viewController.delegate = self
            self?.present(viewController, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
    @objc func tapLeftButton() {
        self.navigationController?.popViewController(animated: true)
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
        let width = (collectionView.frame.width - (11) - (16 * 2)) / 2
        return CGSize(width: width, height: width * 1.28)
        //return CGSize(width: (collectionView.frame.width - 11) / 2 , height: (collectionView.frame.width - 11) / 2 + 70)
    }
}

