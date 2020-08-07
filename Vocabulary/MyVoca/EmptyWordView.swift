//
//  EmptyWordView.swift
//  Vocabulary
//
//  Created by LEE HAEUN on 2020/08/08.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class EmptyWordView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "단어장이 없어요\n버튼을 눌러서\n나만의 단어장을 만들어요!"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view != self ? view : nil
    }

    func configureLayout() {
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(self)
        }
    }
}
