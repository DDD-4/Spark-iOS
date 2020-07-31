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

private enum VocaForAllConstants {
  enum Table {
    static let EstimatedHeight: CGFloat = 100
    static let CellIdentifier: String = "VocaForAllCell"
  }
}

class VocaForAllViewController: UIViewController {

    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    lazy var VocaForAllNaviView: VocaForAllNavigationView = {
        let view = VocaForAllNavigationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.separatorStyle = .none
        view.rowHeight = UITableView.automaticDimension
        view.register(VocaForAllCell.self, forCellReuseIdentifier: VocaForAllConstants.Table.CellIdentifier)
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bindRx()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View ✨
    func initView() {
        view.addSubview(VocaForAllNaviView)
        view.addSubview(tableView)
        view.backgroundColor = .white
        VocaForAllNaviView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(view).offset(8)
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
            }).disposed(by: disposeBag)
        //self.tableView.rx.modelSelected()
    }
}

extension VocaForAllViewController {
    // MARK: - Notification
    @objc func didNotifyChangedVoca(_ notification: Notification) {
      
    }
}
