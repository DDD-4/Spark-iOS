//
//  StackContainerController.swift
//  TinderStack
//
//  Created by Osama Naeem on 16/03/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import UIKit
import AVFoundation

protocol StackContainerViewDelegate: class {
    func stackContainerView(
        _ view: StackContainerView,
        didCompleteCard: SwipeCardView
    )
    func stackContainerView(
        _ view: StackContainerView,
        didEndDisplayCard: SwipeCardView,
        endIndex index: Int
    )
}

class StackContainerView: UIView {

    //MARK: - Properties
    var numberOfCardsToShow: Int = 0
    var cardsToBeVisible: Int = 3
    var cardViews : [SwipeCardView] = []
    var remainingcards: Int = 0
    
    let horizontalInset: CGFloat = 16
    let verticalInset: CGFloat = 16
    
    var visibleCards: [SwipeCardView] {
        return subviews as? [SwipeCardView] ?? []
    }

    var dataSource: SwipeCardsDataSource? {
        didSet {
            reloadData()
        }
    }

    var maxCount: Int = 0

    // Speek
    let synthesizer = AVSpeechSynthesizer()

    weak var delegate: StackContainerViewDelegate?

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(maxCount: Int) {
        self.maxCount = maxCount
    }

    func reloadData() {
        removeAllCardViews()
        guard let datasource = dataSource else { return }
        setNeedsLayout()
        layoutIfNeeded()
        numberOfCardsToShow = datasource.numberOfCardsToShow()
        remainingcards = numberOfCardsToShow
        
        for i in 0..<min(numberOfCardsToShow,cardsToBeVisible) {
            addCardView(cardView: datasource.card(at: i), atIndex: i )
            
        }
    }

    //MARK: - Configurations

    private func addCardView(cardView: SwipeCardView, atIndex index: Int) {
        cardView.delegate = self
        addCardFrame(index: index, cardView: cardView)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingcards -= 1
    }
    
    func addCardFrame(index: Int, cardView: SwipeCardView) {
        var cardViewFrame = bounds
        let horizontalInset = (CGFloat(index) * self.horizontalInset)
        let verticalInset = CGFloat(index) * self.verticalInset
        
        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.x += horizontalInset
        cardViewFrame.origin.y += verticalInset
        
        cardView.frame = cardViewFrame
    }
    
    private func removeAllCardViews() {
        for cardView in visibleCards {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }
}

extension StackContainerView: SwipeCardsDelegate {
    func swipeView(_ view: SwipeCardView) {
        guard let readText = view.flipLabel.text else {
            return
        }

        UIView.transition(with: view, duration: 0.3, options: [.transitionFlipFromRight], animations: {
            view.flipView.isHidden = !view.flipView.isHidden
        }, completion: { [weak self] complete in

            guard let self = self else { return }
            self.synthesizer.stopSpeaking(at: .immediate)
            let utterance = AVSpeechUtterance(string: readText)
            utterance.rate = 0.3
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

            self.synthesizer.speak(utterance)
        })

    }

    func swipeDidEnd(on view: SwipeCardView, endIndex index: Int) {
        guard let datasource = dataSource else { return }
        view.removeFromSuperview()

        delegate?.stackContainerView(self,
                                         didEndDisplayCard: view,
                                         endIndex: index
        )

        if remainingcards > 0 {
            let newIndex = datasource.numberOfCardsToShow() - remainingcards
            addCardView(cardView: datasource.card(at: newIndex), atIndex: 2)
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, animations: {
                    cardView.center = self.center
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                })
            }

        } else {
            for (cardIndex, cardView) in visibleCards.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, animations: {
                    cardView.center = self.center
                    self.addCardFrame(index: cardIndex, cardView: cardView)
                    self.layoutIfNeeded()
                })
            }
        }

        if index == maxCount - 1 {
            delegate?.stackContainerView(self, didCompleteCard: view)
        }
    }
}
