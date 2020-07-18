//
//  SwipeCardDelegate.swift
//  TinderStack
//
//  Created by LEE HAEUN on 2020/07/18.
//  Copyright © 2020 NexThings. All rights reserved.
//

import UIKit

protocol SwipeCardsDelegate {
    func swipeDidEnd(on view: SwipeCardView)
    func swipeView(_ view: SwipeCardView, didSelectCard indexPath: IndexPath)
}

