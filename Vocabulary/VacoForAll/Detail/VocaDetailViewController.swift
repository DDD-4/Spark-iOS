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
import PoingVocaSubsystem

class VocaDetailViewController: UIViewController {
    
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
    
    var words = [Word]()
    static let photoIdentifier = "DetailsCollectionViewCell"
    private var viewModel: WordViewModel
    let disposeBag = DisposeBag()
    
    // MARK: - Init
    init(group: Group) {
        self.viewModel = WordViewModel(group: group)
        defer {
            self.words = group.words
            self.navigationItem.title = group.title
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
        })
        
        viewModel.output.words
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] (_) in
                
            }).disposed(by: disposeBag)
    }
}

extension VocaDetailViewController: SelectVocaViewControllerDelegate {
    func selectVocaViewController(didTapGroup group: Group) {
        
        VocaManager.shared.update(group: group, addWords: words) {
            let alert: UIAlertView = UIAlertView(title: "단어 추가 완료!", message: "단어장에 단어를 추가했어요!", delegate: nil, cancelButtonTitle: nil);
            
            alert.show()
            
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(withClickedButtonIndex: 0, animated: true)
            }
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}

extension VocaDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordDetailCell.reuseIdentifier, for: indexPath) as? WordDetailCell else {
            return UICollectionViewCell()
        }
        cell.configure(word:
            words[indexPath.row])
        
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

