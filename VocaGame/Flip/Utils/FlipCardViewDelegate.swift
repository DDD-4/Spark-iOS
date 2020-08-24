//
//  FlipCardViewDelegate.swift
//  VocaGame
//
//  Created by LEE HAEUN on 2020/07/18.
//  Copyright © 2020 NexThings. All rights reserved.
//

import UIKit

protocol FlipCardViewDelegate: class {
    func flipCardDidEnd(on view: FlipCardView, endIndex index: Int)
    func flipCardDidTap(_ view: FlipCardView)
}

