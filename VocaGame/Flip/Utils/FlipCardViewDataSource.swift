//
//  Protocols.swift
//  VocaGame
//
//  Created by Osama Naeem on 16/03/2019.
//  Edited by haeun lee
//  Copyright © 2019 NexThings. All rights reserved.
//

import UIKit

protocol FlipCardViewDataSource {
    func numberOfCardsToShow() -> Int
    func flipCard(at index: Int) -> FlipCardView
    func emptyView() -> UIView?
}
