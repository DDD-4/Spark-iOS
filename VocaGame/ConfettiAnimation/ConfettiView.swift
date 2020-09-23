//
//  ConfettiView.swift
//  VocaGame
//
//  Created by LEE HAEUN on 2020/09/22.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import PoingDesignSystem

class ConfettiView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureConfettiLayer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        print(emitter)
        print(frame)
        emitter.emitterPosition = CGPoint(x: center.x, y: -96)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
    }

    let emitter = CAEmitterLayer()

    func configureConfettiLayer() {
        emitter.emitterPosition = CGPoint(x: center.x, y: -96)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)
        emitter.emitterCells = getEmiiterCells()
        self.layer.addSublayer(emitter)
    }

    func getEmiiterCells() -> [CAEmitterCell] {
        var cells:[CAEmitterCell] = [CAEmitterCell]()
        for index in 0..<2 {
            let cell = CAEmitterCell()
            cell.birthRate = 3
            cell.lifetime = 10.0
            cell.lifetimeRange = 0
            cell.velocity = 10
            cell.velocityRange = 0
            cell.color = getColor(index: index).cgColor
            cell.contents = UIImage(named: "confetti")?.cgImage
            cell.scaleRange = 0
            cell.scale = 0.3
            cell.velocityRange = 90
            cell.yAcceleration = 30
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.emissionRange = 90
            cells.append(cell)
        }
        return cells
    }

    func getColor(index: Int) -> UIColor {
        ((index % 2) != 0) ? UIColor.dandelion : UIColor.confettiBlue
    }

}
