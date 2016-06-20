//
//  Pulse.swift
//  stopwatch
//
//  Created by Angel Ernesto Anton Yebra on 16/06/16.
//  Copyright © 2016 Toggl. All rights reserved.
//

import UIKit

class Pulse: UIView {

    let radExt = CGFloat(50)
    let radInt = CGFloat(30)
    let internalCircle = CAShapeLayer ()
    let externalCircle = CAShapeLayer ()

    init() {
        super.init(frame: CGRect (x: 0.0, y:0.0, width: 1.0, height: 1.0))
        pulse()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func pulse ()
    {
        let path = UIBezierPath ()
        path.addArcWithCenter(CGPoint.init(x:0,y:0), radius: radInt, startAngle: 0.0 * CGFloat ((M_PI/180.0)), endAngle: 360 * CGFloat((M_PI/180.0)), clockwise: true)
        internalCircle.path = path.CGPath

        let staticPath = UIBezierPath ()
        staticPath.addArcWithCenter(CGPoint.init(x:0,y:0), radius: radExt, startAngle: 0.0 * CGFloat ((M_PI/180.0)), endAngle: 360 * CGFloat((M_PI/180.0)), clockwise: true)
        externalCircle.path = staticPath.CGPath

        let bounceScaleAnim = CAKeyframeAnimation ()
        bounceScaleAnim.keyPath = "transform.scale.xy"
        bounceScaleAnim.values = [0.6, 0.67, 0.6]

        let simpleScale = CABasicAnimation ()
        simpleScale.keyPath = "transform.scale.xy"
        simpleScale.fromValue = 0
        simpleScale.toValue = 1.0

        let simpleAlpha = CABasicAnimation ()
        simpleAlpha.keyPath = "opacity"
        simpleAlpha.fromValue = 1
        simpleAlpha.toValue = 0.0

        let internalAnimGroup = CAAnimationGroup ()
        internalAnimGroup.animations =  [bounceScaleAnim]
        internalAnimGroup.repeatCount = .infinity
        internalAnimGroup.duration = 2

        let externalAnimGroup = CAAnimationGroup ()
        externalAnimGroup.animations = [simpleScale, simpleAlpha]
        externalAnimGroup.repeatCount = .infinity
        externalAnimGroup.duration = 3

        internalCircle.addAnimation(internalAnimGroup, forKey: "scale")
        externalCircle.addAnimation(externalAnimGroup, forKey: "pulse")

        layer.addSublayer(externalCircle)
        layer.addSublayer(internalCircle)
        
        layer.opacity = 0
    }
    
    func hide() {
        fadeToOpacity(0)
    }
    
    func show() {
        fadeToOpacity(1)
    }
    
    func fadeToOpacity(opacity : Float) {
        animateLayer(layer, duration: 0.5, animation: { l in l.opacity = opacity }, properties: "opacity")
    }

    let nightColor = UIColor(red: 255/255.0, green: 212/255.0, blue: 96/255.0, alpha: 0.11).CGColor
    let dayColor = UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 0.11).CGColor

    func setColorScheme(mode: ColorMode) {
        if(mode == ColorMode.day) {
            internalCircle.fillColor = dayColor
            externalCircle.fillColor = dayColor
        } else {
            internalCircle.fillColor = nightColor
            externalCircle.fillColor = nightColor
        }
    }
}
