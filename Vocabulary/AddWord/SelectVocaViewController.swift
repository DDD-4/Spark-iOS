//
//  AddVocaViewController.swift
//  Vocabulary
//
//  Created by user on 2020/07/31.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PoingDesignSystem
import PoingVocaSubsystem

protocol SelectVocaViewControllerDelegate: class {
    func selectVocaViewController(didTapGroup group: Group)
}

class SelectVocaViewController: UIViewController{
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    lazy var naviView: SideNavigationView = {
        let view = SideNavigationView(leftImage: nil, centerTitle: "폴더 선택", rightImage: UIImage(named: "btnAdd"))
        view.leftSideButton.setImage(UIImage(named: "icArrow"), for: .normal)
        view.leftSideButton.addTarget(self, action: #selector(tapLeftButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tableview: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.separatorStyle = .none
        //view.rowHeight = UITableView.automaticDimension
        view.rowHeight = 47
        view.register(SelectVocaTableViewCell.self, forCellReuseIdentifier: SelectVocaTableViewCell.reuseIdentifier)
        view.contentInset = UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private var groups = [Group]()
    let viewModel: SelectViewModelType = SelectViewModel()
    let disposeBag = DisposeBag()
    weak var delegate: SelectVocaViewControllerDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
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
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(containerView)
        containerView.addSubview(naviView)
        containerView.addSubview(tableview)
        
        containerView.snp.makeConstraints { (make) in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.centerY.centerX.equalTo(view)
            make.height.equalTo(308)
        }
        
        naviView.snp.makeConstraints { (make) in
            make.top.equalTo(containerView.snp.top).offset(32)
            make.leading.trailing.equalTo(containerView)
        }
        
        tableview.snp.makeConstraints { (make) in
            make.top.equalTo(naviView.snp.bottom).offset(34)
            make.leading.equalTo(containerView).offset(16)
            make.trailing.equalTo(containerView).offset(-16)
            make.bottom.equalTo(containerView).offset(-4)
        }
    }
    
    func configureRx() {
        viewModel.output.groups
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                self?.tableview.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel.output.words
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                self?.tableview.reloadData()
            }).disposed(by: disposeBag)
    }
    @objc func VocaDataChanged() {
        viewModel.input.fetchGroups()
        groups = viewModel.output.groups.value
    }
    
    @objc func tapLeftButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension SelectVocaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        delegate?.selectVocaViewController(didTapGroup: viewModel.output.groups.value[indexPath.row])
        //delegate?.selectVoca(selecteVoca: viewModel.output.groups.value[indexPath.row])
        //viewModel.input.selectedGroup.accept(viewModel.output.groups.value[indexPath.row])
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectVocaTableViewCell.reuseIdentifier, for: indexPath) as? SelectVocaTableViewCell else {
            return
        }
        
        //cell.delegate?.selectVoca(selecteVoca: viewModel.output.groups.value[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}

extension SelectVocaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.groups.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectVocaTableViewCell.reuseIdentifier, for: indexPath) as? SelectVocaTableViewCell else {
            return UITableViewCell()
        }
    
        cell.configure(group: viewModel.output.groups.value[indexPath.row])
        return cell
    }
}
