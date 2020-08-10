//
//  ViewController.swift
//  TinderStack
//
//  Created by Osama Naeem on 16/03/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import UIKit
import Voca
import SnapKit

class FlipGameViewController: UIViewController {

    //MARK: - Properties
    var viewModelData = [CardsDataModel]()
    var stackContainer : StackContainerView!

    
    //MARK: - Init

    init(words: [Word]) {
        super.init(nibName: nil, bundle: nil)
        for word in words {
            viewModelData.append(CardsDataModel(text: word.english ?? "", image: UIImage()))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        stackContainer = StackContainerView()
        view.addSubview(stackContainer)
        configureStackContainer()
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        configureNavigationBarButtonItem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Expense Tracker"
        stackContainer.dataSource = self
    }
    

    //MARK: - Configurations
    func configureStackContainer() {
        stackContainer.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(stackContainer.snp.width)
        }
    }
    
    func configureNavigationBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetTapped))
    }
    
    //MARK: - Handlers
    @objc func resetTapped() {
        stackContainer.reloadData()
    }

}

extension FlipGameViewController : SwipeCardsDataSource {

    func numberOfCardsToShow() -> Int {
        return viewModelData.count
    }
    
    func card(at index: Int) -> SwipeCardView {
        let card = SwipeCardView()
        card.dataSource = viewModelData[index]
        return card
    }
    
    func emptyView() -> UIView? {
        return nil
    }
    

}
