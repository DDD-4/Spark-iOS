//
//  SelectFolderViewController.swift
//  Vocabulary
//
//  Created by apple on 2020/08/30.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PoingVocaSubsystem
import PoingDesignSystem

protocol SelectFolderViewControllerDelegate: class {
    func selectFolderViewController(didTapFolder folder: Folder)
}

class SelectFolderViewController: UIViewController {
    
    enum Constant {
        static let spacing: CGFloat = 11
        enum Collection {
            static let topMargin: CGFloat = 44
        }
    }
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    let viewModel: SelectViewModelType
    weak var delegate: SelectFolderViewControllerDelegate?
    
    lazy var naviView: SideNavigationView = {
        let view = SideNavigationView(leftImage: nil, centerTitle: "폴더 선택", rightImage: nil)
        view.leftSideButton.setImage(UIImage(named: "icArrow"), for: .normal)
        view.leftSideButton.addTarget(self, action: #selector(tapLeftButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var folderCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = Constant.spacing
        flowLayout.minimumLineSpacing = Constant.spacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            SelectFolderViewCell.self,
            forCellWithReuseIdentifier: SelectFolderViewCell.reuseIdentifier
        )
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    init() {
        if ModeConfig.shared.currentMode == .offline {
            viewModel = SelectViewModel()
        } else {
            viewModel = SelectOnlineViewModel()
        }
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        configureRx()
        
        VocaDataChanged()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(VocaDataChanged),
            name: .vocaDataChanged,
            object: nil)
    }
    
    func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(naviView)
        view.addSubview(folderCollectionView)
        
        naviView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        folderCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(naviView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }
    }
    
    @objc func tapLeftButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureRx() {
        viewModel.output.myFolders
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                self?.folderCollectionView.reloadData()
            }).disposed(by: disposeBag)

    }
    
    @objc func VocaDataChanged() {
        if ModeConfig.shared.currentMode == .offline {
            viewModel.input.fetchMyFolders()
        }
    }
}

extension SelectFolderViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.myFolders.value.count + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SelectFolderViewCell.reuseIdentifier,
            for: indexPath
            ) as? SelectFolderViewCell else {
                return UICollectionViewCell()
        }
        
        if indexPath.row == 0 {
            cell.configure(type: .add)
        } else {
            //이부분을 보완해야할것같다. 모델에 따라 값을 넣어주어야한다.
            cell.configure(folder: viewModel.output.myFolders.value[indexPath.row - 1], type: .read)
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // TODO: 만약 온라인 모드이면 변경 사항을 현재 뷰컨으로 update해야합니다
            let myFolderDetailViewController = MyFolderDetailViewController(viewType: .add)
            navigationController?.pushViewController(myFolderDetailViewController, animated: true)
        } else {
            delegate?.selectFolderViewController(didTapFolder: viewModel.output.myFolders.value[indexPath.item - 1])
            navigationController?.popViewController(animated: true)
        }
    }
}

extension SelectFolderViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 32,
            left: 0,
            bottom: HomeViewController.Constant.Floating.height + (hasTopNotch ? bottomSafeInset : 32),
            right: 0
        )
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.width - (11) - (16 * 2)) / 2
        return CGSize(width: width, height: width)
    }
}
