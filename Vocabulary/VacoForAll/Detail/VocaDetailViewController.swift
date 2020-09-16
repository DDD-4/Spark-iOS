////
////  VocaDetailViewController.swift
////  Vocabulary
////
////  Created by apple on 2020/07/31.
////  Copyright © 2020 LEE HAEUN. All rights reserved.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//import SnapKit
//import PoingVocaSubsystem
//import PoingDesignSystem
//
//class VocaDetailViewController: UIViewController {
//    enum Constant {
//        enum Floating {
//            static let height: CGFloat = 60
//            static let width: CGFloat = 206
//        }
//        static let buttonRadius: CGFloat = 30
//    }
//
//    var headerHeightConstraint: NSLayoutConstraint?
//    let maximumHeaderHeight: CGFloat = 130
//    let minimumHeaderHeight: CGFloat = 0
//
//    // MARK: - Properties
//    lazy var naviView: SideNavigationView = {
//        let view = SideNavigationView(leftImage: UIImage(named: "icArrow"), centerTitle: vocaTitle, rightImage: nil)
//        view.backgroundColor = .white
//        view.titleLabel.alpha = 0
//        view.leftSideButton.addTarget(self, action: #selector(tapLeftButton), for: .touchUpInside)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    lazy var headerView: VocaHeaderView = {
//        let view = VocaHeaderView(vocaTitle: vocaTitle, profileName: "홍길동", profileImage: nil)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    lazy var vocaCollectionView: UICollectionView = {
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.scrollDirection = .vertical // 스크롤 방향
//        flowLayout.minimumLineSpacing = 11 // 최소라인간격
//        flowLayout.minimumInteritemSpacing = 11 // 최소 내부 여백
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.backgroundColor = .white
//        collectionView.contentInset = UIEdgeInsets(
//            top: 0,
//            left: 16,
//            bottom: Constant.Floating.height + (hasTopNotch ? bottomSafeInset : 32),
//            right: 16
//        )
//        collectionView.register(
//            WordDetailCell.self,
//            forCellWithReuseIdentifier: WordDetailCell.reuseIdentifier
//        )
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.allowsMultipleSelection = false
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.clipsToBounds = false
//        return collectionView
//    }()
//
//    lazy var saveButton: BaseButton = {
//        let button = BaseButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = Constant.buttonRadius
//        button.setTitle("모두 저장하기", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)
//        button.backgroundColor = .brightSkyBlue
//        button.layer.masksToBounds = false
//        return button
//    }()
//
//    var words = [Word]()
//    static let photoIdentifier = "DetailsCollectionViewCell"
//    private var viewModel: WordViewModel
//    let disposeBag = DisposeBag()
//    var vocaTitle: String
//
//    // MARK: - Init
//    init(group: Group) {
//        self.viewModel = WordViewModel(group: group)
//        self.vocaTitle = group.title
//        self.words = group.words
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureLayout()
//        configureRx()
//        viewModel.input.fetchGroups()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//    }
//
//    func configureLayout() {
//        view.backgroundColor = .white
//        view.addSubview(headerView)
//        view.addSubview(vocaCollectionView)
//        view.addSubview(naviView)
//        view.addSubview(saveButton)
//
//        let notchTopView = UIView()
//        notchTopView.translatesAutoresizingMaskIntoConstraints = false
//        notchTopView.backgroundColor = .white
//
//        view.addSubview(notchTopView)
//
//        notchTopView.snp.makeConstraints { (make) in
//            make.top.leading.trailing.equalTo(view)
//            make.bottom.equalTo(naviView.snp.top)
//        }
//
//        naviView.snp.makeConstraints { (make) in
//            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
//        }
//
//        headerView.snp.makeConstraints { (make) in
//            make.top.equalTo(naviView.snp.bottom)
//            make.leading.equalTo(view.safeAreaLayoutGuide).offset(57)
//            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-57)
//        }
//
//        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: maximumHeaderHeight)
//        headerHeightConstraint?.isActive = true
//
//        saveButton.snp.makeConstraints { (make) in
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(hasTopNotch ? 0 : -16)
//            make.centerX.equalTo(view)
//            make.height.equalTo(Constant.Floating.height)
//            make.width.equalTo(Constant.Floating.width)
//        }
//
//        vocaCollectionView.snp.makeConstraints { (make) in
//            make.top.equalTo(headerView.snp.bottom)
//            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
//            make.bottom.equalTo(view)
//        }
//    }
//
//    func configureRx() {
//
//        self.saveButton.rx.tap.subscribe(onNext: {[weak self] (_) in
//            let viewController = SelectFolderViewController(words: self?.words)
//            viewController.delegate = self
//            self?.navigationController?.pushViewController(viewController, animated: true)
//        }).disposed(by: disposeBag)
//
//        viewModel.output.words
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: {[weak self] (_) in
//
//            }).disposed(by: disposeBag)
//
//        viewModel.output.groups
//        .observeOn(MainScheduler.instance)
//        .subscribe(onNext: {[weak self] (_) in
//
//        }).disposed(by: disposeBag)
//    }
//
//    @objc func tapLeftButton() {
//        self.navigationController?.popViewController(animated: true)
//    }
//}
//
//extension VocaDetailViewController: SelectFolderViewControllerDelegate {
//    func selectFolderViewController(didTapFolder folder: Group) {
//
//        VocaManager.shared.update(group: folder, addWords: words) {
//            let alert: UIAlertView = UIAlertView(title: "단어 추가 완료!", message: "단어장에 단어를 추가했어요!", delegate: nil, cancelButtonTitle: nil);
//
//            alert.show()
//
//            let when = DispatchTime.now() + 2
//            DispatchQueue.main.asyncAfter(deadline: when){
//                alert.dismiss(withClickedButtonIndex: 0, animated: true)
//            }
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
//}
//
//extension VocaDetailViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return words.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordDetailCell.reuseIdentifier, for: indexPath) as? WordDetailCell else {
//            return UICollectionViewCell()
//        }
//        cell.configure(word:
//            words[indexPath.row])
//
//        return cell
//    }
//}
//
//extension VocaDetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
//    func collectionView(
//        _ collectionView: UICollectionView,
//        layout collectionViewLayout: UICollectionViewLayout,
//        sizeForItemAt indexPath: IndexPath
//    ) -> CGSize {
//        let width = (collectionView.frame.width - (11) - (16 * 2)) / 2
//        return CGSize(width: width, height: 214)
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard scrollView == vocaCollectionView else {
//            return
//        }
//
//        let y: CGFloat = scrollView.contentOffset.y
//        let headerHeightConstant: CGFloat = headerHeightConstraint?.constant ?? 0
//        let newHeaderHeight = headerHeightConstant - y
//
//        if newHeaderHeight > maximumHeaderHeight {
//            naviView.titleLabel.alpha = 0
//            headerView.alpha = 1
//            headerHeightConstraint?.constant = maximumHeaderHeight
//        } else if newHeaderHeight < minimumHeaderHeight {
//            naviView.titleLabel.alpha = 1
//            headerView.alpha = 0
//            headerHeightConstraint?.constant = minimumHeaderHeight
//        } else {
//            let ratio = newHeaderHeight / maximumHeaderHeight
//            naviView.titleLabel.alpha = 1 - ratio
//            headerView.alpha = ratio
//            headerHeightConstraint?.constant = newHeaderHeight
//            scrollView.contentOffset.y = 0
//        }
//    }
//}
