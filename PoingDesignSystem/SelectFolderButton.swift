//
//  SelectFolderButton.swift
//  PoingDesignSystem
//
//  Created by apple on 2020/09/05.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

public class SelectFolderButton: UIButton {
    public lazy var folderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "폴더를 선택하세요"
        label.textColor = .gray
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        return label
    }()
    
    lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "arrow2")
        return imageView
    }()
    
    public init() {
        super.init(frame: .zero)
        
        configureLayout()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        addSubview(folderLabel)
        addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            folderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            folderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            folderLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            arrowImageView.topAnchor.constraint(equalTo: topAnchor, constant: 21),
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            arrowImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -21)
        ])
    }
}
