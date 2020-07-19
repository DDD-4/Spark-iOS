//
//  Protocols.swift
//  TinderStack
//
//  Created by Hyeonjae Lee on 16/03/2019.
//  Copyright © 2019 NexThings. All rights reserved.
//

import UIKit

protocol SwipeCardsDataSource {
    func numberOfCardsToShow() -> Int
    func card(at index: Int) -> SwipeCardView
    func emptyView() -> UIView?
}
