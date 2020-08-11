//
//  SwipeCardDelegate.swift
//  TinderStack
//
//  Created by LEE HAEUN on 2020/07/18.
//  Copyright © 2020 NexThings. All rights reserved.
//

import UIKit

protocol SwipeCardsDelegate: class {
    func swipeDidEnd(on view: SwipeCardView, endIndex index: Int)
    func swipeView(_ view: SwipeCardView)
}

