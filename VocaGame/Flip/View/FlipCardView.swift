//
//  SwipeCardView.swift
//  VocaGame
//
//  Created by Osama Naeem on 16/03/2019.
//  Edited by Haeun lee
//  Copyright © 2019 NexThings. All rights reserved.
//

import UIKit
import SnapKit
import PoingDesignSystem

class FlipCardView: UIView {
    enum Constant {
        static let radius: CGFloat = 16
    }
    
    //MARK: - Properties
    let index: Int
    weak var delegate: FlipCardViewDelegate?

    var dataSource : CardsDataModel? {
        didSet {
            swipeView.backgroundColor = .white
            flipLabel.text = dataSource?.text
            guard let image = dataSource?.image else { return }
//            imageView.image = UIImage(named: image)
        }
    }

    lazy var swipeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.layer.cornerRadius = Constant.radius
        view.layer.shadow(color: .greyblue20, alpha: 1, x: 0, y: 10, blur: 60, spread: 0)
        view.backgroundColor = .white
        return view
    }()

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constant.radius
        return imageView
    }()

    var flipView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = Constant.radius
        return view
    }()

    var flipLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.BalsamiqSansBold(size: 46)
        label.textColor = .darkIndigo
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.minimumScaleFactor = 0.1
        return label
    }()

    
    //MARK: - Init

    init(index: Int) {
        self.index = index
        super.init(frame: .zero)
        configureLayout()
        addPanGestureOnCards()
        configureTapGesture()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration
    func configureLayout() {
        addSubview(swipeView)
        swipeView.addSubview(imageView)
        swipeView.addSubview(flipView)
        flipView.addSubview(flipLabel)

        swipeView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(self)
        }

        imageView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(swipeView)
        }

        flipView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(swipeView)
        }

        flipLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(flipView)
        }
    }

    func configureTapGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    
    func addPanGestureOnCards() {
        self.isUserInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }
    
    
    
    //MARK: - Handlers
    @objc func handlePanGesture(sender: UIPanGestureRecognizer){
        let card = sender.view as! FlipCardView
        let point = sender.translation(in: self)
        let centerOfParentContainer = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        card.center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)

        switch sender.state {
        case .ended:
            if (card.center.x) > 400 {
                delegate?.flipCardDidEnd(on: card, endIndex: index)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x + 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }else if card.center.x < -65 {
                delegate?.flipCardDidEnd(on: card, endIndex: index)
                UIView.animate(withDuration: 0.2) {
                    card.center = CGPoint(x: centerOfParentContainer.x + point.x - 200, y: centerOfParentContainer.y + point.y + 75)
                    card.alpha = 0
                    self.layoutIfNeeded()
                }
                return
            }
            UIView.animate(withDuration: 0.2) {
                card.transform = .identity
                card.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                self.layoutIfNeeded()
            }
        case .changed:
            let rotation = tan(point.x / (self.frame.width * 2.0))
            card.transform = CGAffineTransform(rotationAngle: rotation)
            
        default:
            break
        }
    }
    
    @objc func handleTapGesture(sender: UITapGestureRecognizer){
        delegate?.flipCardDidTap(self)
    }
    
  
}
