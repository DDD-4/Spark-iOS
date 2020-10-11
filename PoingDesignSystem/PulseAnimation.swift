//
//  PulseAnimation.swift
//  PoingDesignSystem
//
//  Created by apple on 2020/09/20.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import UIKit

public class PulseAnimation: CALayer {
    public var animationGroup: CAAnimationGroup?
    public var animationDuration: TimeInterval = 1.5
    public var radius: CGFloat = 200
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(radius: CGFloat, position: CGPoint) {
        super.init()
        self.backgroundColor = UIColor.yellow.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.radius = radius
        self.position = position

        let diameter: CGFloat = radius * 2
        bounds = CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: diameter, height: diameter))
        cornerRadius = radius

        DispatchQueue.global(qos: .default).async {
            self.setUpAnimationGroup()
            DispatchQueue.main.async {
                guard let animationGroup = self.animationGroup else {
                    return
                }
                self.add(animationGroup, forKey: "pulse")
            }
        }
    }
    
    func scaleAnimation() -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(value: 0)
        scaleAnimation.toValue = NSNumber(value: 1)
        scaleAnimation.duration = animationDuration
        return scaleAnimation
    }
    
    func createOpacirtyAnimation() -> CAKeyframeAnimation {
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.keyTimes = [0, 0.3, 0.6, 1]
        opacityAnimation.values = [0.3, 0.6, 0.8, 0]
        return opacityAnimation
    }
    
    func setUpAnimationGroup() {
        let animationGroup = CAAnimationGroup()
        animationGroup.repeatCount = .greatestFiniteMagnitude
        animationGroup.duration = animationDuration
        let defaulCurve = CAMediaTimingFunction(name: .default)
        animationGroup.timingFunction = defaulCurve
        animationGroup.animations = [scaleAnimation(), createOpacirtyAnimation()]

        self.animationGroup = animationGroup
    }

    public func stop() {
        animationGroup = nil
        removeAllAnimations()
    }
}
