//
//  VocaForAllViewController.swift
//  Vocabulary
//
//  Created by apple on 2020/07/30.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PoingVocaSubsystem

private enum VocaForAllConstants {
    enum Table {
        static let EstimatedHeight: CGFloat = 100
        static let CellIdentifier: String = "VocaForAllCell"
    }
}

class VocaForAllViewController: UIViewController {
    
    // MARK: - Properties
    lazy var VocaForAllNaviView: VocaForAllNavigationView = {
        let view = VocaForAllNavigationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.separatorStyle = .none
        view.rowHeight = UITableView.automaticDimension
        view.register(VocaForAllCell.self, forCellReuseIdentifier: VocaForAllCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    var groups = [Group]()
    let disposeBag = DisposeBag()
    let viewModel = VocaForAllViewModel()
    weak var delegate: VocaForAllViewController?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configureLayout()
        bindRx()
        VocaDataChanged()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(VocaDataChanged),
            name: .vocaDataChanged,
            object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        VocaDataChanged()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - View ✨
    func configureLayout() {
        view.backgroundColor = .white
        view.addSubview(VocaForAllNaviView)
        view.addSubview(tableView)
        
        VocaForAllNaviView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            } else {
                make.leading.trailing.equalTo(view)
                make.top.equalTo(view).offset(8)
            }
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11, *) {
                make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.leading.trailing.equalTo(view)
            }
            make.bottom.equalTo(view)
            make.top.equalTo(VocaForAllNaviView.snp.bottom)
        }
    }
    
    // MARK: - Bind 🏷
    func bindRx() {
        self.VocaForAllNaviView.sortPopularButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                // sort popular
                // we need to group's properties about popularty and latest.
            }).disposed(by: disposeBag)
        
        self.VocaForAllNaviView.sortLatestButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                // sort latest
            }).disposed(by: disposeBag)
        
        self.viewModel.output.groups
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        self.viewModel.output.words
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    @objc func VocaDataChanged() {
        viewModel.input.fetchGroups()
        groups = viewModel.output.groups.value
    }
}

extension VocaForAllViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DummyData.vocaForAll.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: VocaForAllCell.reuseIdentifier,
                for: indexPath
        ) as? VocaForAllCell else {
            return UITableViewCell()
        }
        
//        cell.configure(group: viewModel.output.groups.value[indexPath.row])
        cell.configure(dummy: DummyData.vocaForAll[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .gray
    }
    
}

extension VocaForAllViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let wordView = VocaDetailViewController(group: viewModel.output.groups.value[indexPath.row])

        let wordView = DummyVocaDetailViewController(title: DummyData.vocaForAll[indexPath.row].title, wordDownload: DummyData.vocaForAll[indexPath.row].words)
        
//        let navViewController = UINavigationController(rootViewController: wordView)
//
//        self.present(navViewController, animated: true, completion: nil)
        present(wordView, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
