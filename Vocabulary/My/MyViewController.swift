//
//  MyViewController.swift
//  Vocabulary
//
//  Created by apple on 2020/08/04.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import Voca
import SnapKit
import RxCocoa
import RxSwift

class MyViewController: UIViewController {
    
    // MARK: - Properties
//    lazy var profileView: UserinfoHeader = {
//        let view = UserinfoHeader()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .red
//        return view
//    }()
    
    var userInforHeader: UserinfoHeader!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.frame
        //view.addSubview(tableView)
        tableView.rowHeight = 60
        tableView.register(settingCell.self, forCellReuseIdentifier: settingCell.reuseIdentifier)
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        userInforHeader = UserinfoHeader(frame: frame)
        tableView.tableHeaderView = userInforHeader
        tableView.tableFooterView = UIView()
        
        return tableView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationItem.title = "Settings"
        configureLayout()
    }
    
    func configureLayout() {
        
        //view.addSubview(profileView)
        view.addSubview(tableView)
        
//        profileView.snp.makeConstraints { (make) in
//            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
//            make.height.equalTo(80)
//        }
        
//        tableView.snp.makeConstraints { (make) in
//            //make.top.equalTo(profileView.snp.bottom)
//            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
//        }
    }
}

extension MyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: settingCell.reuseIdentifier, for: indexPath) as? settingCell else {
            return UITableViewCell()
        }
        
        guard let section = SettingsSection(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .Social:
            let social = SocialOptions(rawValue: indexPath.row)
            cell.sectionType = social
        case .Communications:
            let communication = CommunicationsOptions(rawValue: indexPath.row)
            cell.sectionType = communication
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.text = SettingsSection(rawValue: section)?.description
        title.textColor = .white
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.snp.makeConstraints { (make) in
            make.centerY.equalTo(view)
            make.leading.equalTo(view).offset(16)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableview(_ tableView: UITableView, numberOfFowsInSection section: Int) -> Int {
        
        guard let section = SettingsSection(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .Social: return SocialOptions.allCases.count
        case .Communications: return CommunicationsOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else {
            return
        }
        
        switch section {
        case .Social:
            print(SocialOptions(rawValue: indexPath.row)?.description)
        case .Communications:
            print(CommunicationsOptions(rawValue: indexPath.row)?.description)
        }
    }
}
