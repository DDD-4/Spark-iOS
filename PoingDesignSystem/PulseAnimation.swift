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
    public var animationGroup = CAAnimationGroup()
    public var animationDuration: TimeInterval = 1.5
    public var radius: CGFloat = 200
    public var numberOfPulses: Float = 10
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(numberOfPulses: Float = 10, radius: CGFloat, position: CGPoint) {
        super.init()
        self.backgroundColor = UIColor.yellow.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.radius = radius
        self.numberOfPulses = numberOfPulses
        self.position = position
        
        self.bounds = CGRect(x: 0, y: 0, width: radius * 1.5, height: radius * 1.5)
        self.cornerRadius = radius
        
        DispatchQueue.global(qos: .default).async {
            self.setUpAnimationGroup()
            DispatchQueue.main.async {
                self.add(self.animationGroup, forKey: "pulse")
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
    
//    func setUpAnimationGroup() {
//        self.animationGroup.duration = animationDuration
//        self.animationGroup.repeatCount = numberOfPulses
//        let defaulCurve = CAMediaTimingFunction(name: .default)
//        self.animationGroup.timingFunction = defaulCurve
//        self.animationGroup.animations = [scaleAnimation(), createOpacirtyAnimation()]
//    }
    
    func setUpAnimationGroup() {
          self.animationGroup.repeatCount = .greatestFiniteMagnitude
          self.animationGroup.duration = animationDuration
          let defaulCurve = CAMediaTimingFunction(name: .default)
          self.animationGroup.timingFunction = defaulCurve
          self.animationGroup.animations = [scaleAnimation(), createOpacirtyAnimation()]
      }
}
