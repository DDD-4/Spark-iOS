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
    lazy var navigationViewArea: SideNavigationView = {
        let view = SideNavigationView(leftImage: UIImage(named: "icArrow"), centerTitle: "폴더 편집", rightImage: UIImage(named: "btnAdd"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rightSideButton.addTarget(nil, action: #selector(addDidTap(_:)), for: .touchUpInside)
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

    var groups = [Group]()
    init(groups: [Group]) {
        self.groups = groups
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        DispatchQueue.main.async {
            self.groupTableView.setEditing(true, animated: true)
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
    @objc func addDidTap(_ sender: UIButton) {
        present(AddVocaViewController(), animated: true, completion: nil)
    }
}

extension EditMyVocaGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: EditMyVocaGroupCell.reuseIdentifier,
            for: indexPath) as? EditMyVocaGroupCell else {
            return UITableViewCell()
        }
        cell.configure(group: groups[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
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
        let elem = groups.remove(at: sourceIndexPath.row)
        groups.insert(elem, at: destinationIndexPath.row)

        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        false
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
}
