//
//  HomeHeaderView.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/08/10.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import SnapKit
import UIKit
import SnapKit

protocol HomeHeaderDelegate: class {
    func homeHeader(_ view: HomeHeaderView, selectedTab: HomeTabType)
    func homeHeader(_ view: HomeHeaderView, settingDidTap button: UIButton)
}

class HomeHeaderView: UIView {
    enum Constant {
        static let leftMargin: CGFloat = 16
        enum Setting {
            static let width: CGFloat = 24
            static let image: UIImage? = UIImage(named: "icnSetting")
        }
    }
    let titles: [HomeTabType]
    var activeTabType: HomeTabType

    weak var delegate: HomeHeaderDelegate?

    lazy var settingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constant.Setting.image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(settingDidTap(_:)), for: .touchUpInside)
        return button
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            HomeHeaderCell.self,
            forCellWithReuseIdentifier: HomeHeaderCell.reuseIdentifier
        )
        collectionView.backgroundColor = .white
        collectionView.contentInset.left = Constant.leftMargin
        collectionView.contentInset.right = Constant.leftMargin
        return collectionView
    }()

    init(titles: [HomeTabType], activeTabType: HomeTabType, delegate: HomeHeaderDelegate) {
        self.titles = titles
        self.activeTabType = activeTabType
        self.delegate = delegate
        super.init(frame: .zero)

        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configire(activeTabType: HomeTabType) {
        self.activeTabType = activeTabType
        collectionView.reloadData()
    }

    func configureLayout() {
        addSubview(settingButton)
        addSubview(collectionView)

        collectionView.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(settingButton.snp.leading)
        }

        settingButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-Constant.leftMargin)
            make.width.height.equalTo(Constant.Setting.width)
            make.centerY.equalTo(self)
        }
    }

    @objc func settingDidTap(_ sender: UIButton) {
        delegate?.homeHeader(self, settingDidTap: sender)
    }
}

extension HomeHeaderView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.homeHeader(self, selectedTab: titles[indexPath.row])
    }
}

extension HomeHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeHeaderCell.reuseIdentifier, for: indexPath) as? HomeHeaderCell else {
            return UICollectionViewCell()
        }
        cell.configure(title: titles[indexPath.row].rawValue, isActive: titles[indexPath.row] == activeTabType)
        return cell
    }
}

class HomeHeaderCell: UICollectionViewCell {
    enum Constant {
        static let activeColor: UIColor = UIColor(red: 17.0 / 255.0, green: 28.0 / 255.0, blue: 78.0 / 255.0, alpha: 1.0)
        static let inactiveColor: UIColor = UIColor(white: 223.0 / 255.0, alpha: 1.0)
    }

    static let reuseIdentifier: String = String(describing: HomeHeaderCell.self)

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Test"
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textColor = Constant.activeColor
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, isActive: Bool) {
        titleLabel.text = title

        if isActive {
            titleLabel.textColor = Constant.activeColor
        } else {
            titleLabel.textColor = Constant.inactiveColor
        }
    }

    func configureLayout() {
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
