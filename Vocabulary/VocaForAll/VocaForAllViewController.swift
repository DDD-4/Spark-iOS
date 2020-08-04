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
import Voca

private enum VocaForAllConstants {
    enum Table {
        static let EstimatedHeight: CGFloat = 100
        static let CellIdentifier: String = "VocaForAllCell"
    }
}

class VocaForAllViewController: UIViewController {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var viewModel = WordViewModel(group: nil)
    
    lazy var VocaForAllNaviView: VocaForAllNavigationView = {
        let view = VocaForAllNavigationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.separatorStyle = .none
        view.rowHeight = UITableView.automaticDimension
        view.register(VocaForAllCell.self, forCellReuseIdentifier: VocaForAllCell.reuseIdentifier)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    let dummyWords = [
        Word(korean: "한글", english: "eng", image: nil, identifier: UUID()),
        Word(korean: "한글", english: "eng", image: nil, identifier: UUID()),
        Word(korean: "한글", english: "eng", image: nil, identifier: UUID())
    ]
    
    var groups = [Group]()
    init(groups: [Group]) {
        
        self.groups = groups
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        let newGroup = Group(
            title: "test",
            visibilityType: .public,
            identifier: UUID(),
            words: self.dummyWords
        )
        
        self.groups.append(newGroup)
        self.tableView.reloadData()
        self.viewModel = WordViewModel(group: newGroup)
        configureLayout()
        bindRx()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - View ✨
    func configureLayout() {
        view.addSubview(VocaForAllNaviView)
        view.addSubview(tableView)
        view.backgroundColor = .white
        
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
        self.VocaForAllNaviView.sortButton.rx.tap
            .subscribe(onNext: { [weak self] (_) in
                // openNavigation
                print("hello!!")
            }).disposed(by: disposeBag)
        
        self.viewModel.output.words.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            self?.tableView.reloadData()
        })
    }
}

extension VocaForAllViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VocaForAllCell.reuseIdentifier, for: indexPath) as? VocaForAllCell else {
            return UITableViewCell()
        }

        cell.configure(group: groups[indexPath.row])
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
        let wordView = VocaDetailViewController(group: self.groups[indexPath.row])
        self.navigationController?.pushViewController(wordView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let elem = groups.remove(at: sourceIndexPath.row)
        groups.insert(elem, at: destinationIndexPath.row)

        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
}

extension VocaForAllViewController {
    // MARK: - Notification
    @objc func didNotifyChangedVoca(_ notification: Notification) {
        
    }
}
