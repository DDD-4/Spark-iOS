//
//  VocaDetailViewController.swift
//  Vocabulary
//
//  Created by apple on 2020/07/31.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Voca

class VocaDetailViewController: UIViewController {
    
    // MARK: - Properties
    static let photoIdentifier = "DetailsCollectionViewCell"
    
    private var viewModel: WordViewModel
    let disposeBag = DisposeBag()
    
    lazy var vocaCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical // 스크롤 방향
        flowLayout.minimumLineSpacing = 16 // 최소라인간격
        flowLayout.minimumInteritemSpacing = 0 // 최소 내부 여백
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .gray
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
        button.layer.cornerRadius = 30
        button.setTitle("모두 저장하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        return button
    }()
    
    var words = [Word]()
    
    // MARK: - Init
    init(group: Group) {
        self.viewModel = WordViewModel(group: group)
        defer {
            self.words = group.words
            self.navigationItem.title = group.title
            //self.naviTitle.text = group.title
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarController = tabBarController as? TabbarViewController { tabBarController.hiddenTabBar(true)
        }
        configureLayout()
        configureRx()
        viewModel.input.fetchGroups()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let tabBarController = tabBarController as? TabbarViewController { tabBarController.hiddenTabBar(false)
        }
    }
    
    func configureLayout() {
        view.addSubview(saveButton)
        view.bringSubviewToFront(saveButton)
        view.addSubview(vocaCollectionView)
        
        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        vocaCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func configureRx() {
        
        viewModel.output.words
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                self?.vocaCollectionView.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel.output.groups
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                 self?.vocaCollectionView.reloadData()
            })
        
        self.vocaCollectionView.rx.modelSelected(Group.self)
        .subscribe(onNext : { [weak self] (groupData) in
            // present dim view..
        }).disposed(by: disposeBag)
    
    }
}

extension VocaDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.words.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordDetailCell.reuseIdentifier, for: indexPath) as? WordDetailCell else {
            return UICollectionViewCell()
        }
        cell.configure(word:
            viewModel.output.words.value[indexPath.row])
        
        return cell
    }
}

extension VocaDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 11) / 2 , height: (collectionView.frame.width - 11) / 2 + 70)
    }
}

