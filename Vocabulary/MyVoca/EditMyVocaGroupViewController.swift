//
//  EditMyVocaGroupViewController.swift
//  Vocabulary
//
//  Created by user on 2020/07/31.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PoingVocaSubsystem
import PoingDesignSystem

class EditMyVocaGroupViewController: UIViewController {

    let viewModel: EditMyVocaGroupViewModel
    let disposeBag = DisposeBag()

    lazy var navigationViewArea: SideNavigationView = {
        let view = SideNavigationView(leftImage: UIImage(named: "icArrow"), centerTitle: "폴더 편집", rightImage: UIImage(named: "btnAdd"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rightSideButton.addTarget(nil, action: #selector(addDidTap(_:)), for: .touchUpInside)
        view.leftSideButton.addTarget(self, action: #selector(dismissDidTap), for: .touchUpInside)
        return view
    }()

    lazy var groupTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .gray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            EditMyVocaGroupCell.self,
            forCellReuseIdentifier: EditMyVocaGroupCell.reuseIdentifier
        )
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    init(groups: [Group]) {
        viewModel = EditMyVocaGroupViewModel(groups: groups)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureRx()
        DispatchQueue.main.async {
            self.groupTableView.setEditing(true, animated: true)
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(vocaDataChanged),
            name: .vocaDataChanged,
            object: nil
        )

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let tabBarController = tabBarController as? TabbarViewController {
            tabBarController.hiddenTabBar(true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func configureLayout() {
        view.backgroundColor = .gray
        view.addSubview(navigationViewArea)
        view.addSubview(groupTableView)

        navigationViewArea.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }

        groupTableView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationViewArea.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func configureRx() {
        viewModel.groups
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                self?.groupTableView.reloadData()
            }).disposed(by: disposeBag)

    }

    @objc func addDidTap(_ sender: UIButton) {
        present(AddVocaViewController(), animated: true, completion: nil)
    }

    @objc func dismissDidTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc func vocaDataChanged() {
        viewModel.filteredFetchGroup()
    }
}

extension EditMyVocaGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: EditMyVocaGroupCell.reuseIdentifier,
            for: indexPath) as? EditMyVocaGroupCell else {
            return UITableViewCell()
        }
        let group = viewModel.groups.value[indexPath.section]

        cell.delegate = self
        cell.configure(group: group)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.groups.value.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .gray
    }
}

extension EditMyVocaGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        20
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        guard sourceIndexPath.row != destinationIndexPath.row else {
            return
        }

        var tempGroup = viewModel.groups.value

        let elem = tempGroup.remove(at: sourceIndexPath.row)
        tempGroup.insert(elem, at: destinationIndexPath.row)

        viewModel.groups.accept(tempGroup)
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        false
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
}

extension EditMyVocaGroupViewController: EditMyVocaGroupCellDelegate {
    func editMyVocaGroupCell(
        _ cell: UITableViewCell,
        didTapDelete button: UIButton,
        group: Group
    ) {
        VocaManager.shared.delete(group: group)
    }

    func editMyVocaGroupCell(
        _ cell: UITableViewCell,
        didTapChangeVisibility button: UIButton,
        group: Group
    ) {
        let changedVisibilityType: VisibilityType = (group.visibilityType == .public) ? .private : .public

        var currentGroup = group

        currentGroup.visibilityType = changedVisibilityType

        VocaManager.shared.update(group: currentGroup)
    }
}
