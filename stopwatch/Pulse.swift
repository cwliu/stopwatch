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
        initAnim()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initAnim ()
    {
        let path = UIBezierPath ()
        path.addArcWithCenter(CGPoint.init(x:0,y:0), radius: radInt, startAngle: 0.0 * CGFloat ((M_PI/180.0)), endAngle: 360 * CGFloat((M_PI/180.0)), clockwise: true)
        internalCircle.path = path.CGPath

        let staticPath = UIBezierPath ()
        staticPath.addArcWithCenter(CGPoint.init(x:0,y:0), radius: radExt, startAngle: 0.0 * CGFloat ((M_PI/180.0)), endAngle: 360 * CGFloat((M_PI/180.0)), clockwise: true)
        externalCircle.path = staticPath.CGPath

        layer.addSublayer(externalCircle)
        layer.addSublayer(internalCircle)
        
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(Pulse.animInnerOnce), userInfo: nil, repeats: true)
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(Pulse.animOuterOnce), userInfo: nil, repeats: true)
        animInnerOnce()
        animOuterOnce()
        
        layer.opacity = 0
    }
    
    func animInnerOnce() {
        
        let bounceScaleAnim = CAKeyframeAnimation ()
        bounceScaleAnim.keyPath = "transform.scale.xy"
        bounceScaleAnim.values = [0.6, 0.67, 0.6]
        
        let animGroup = CAAnimationGroup ()
        animGroup.animations =  [bounceScaleAnim]
        animGroup.duration = 2
        animGroup.fillMode = kCAFillModeForwards
        animGroup.removedOnCompletion = false
        
        internalCircle.addAnimation(animGroup, forKey: "scale")
    }
    
    func animOuterOnce() {
        
        let simpleScale = CABasicAnimation ()
        simpleScale.keyPath = "transform.scale.xy"
        simpleScale.fromValue = 0
        simpleScale.toValue = 1.0
        
        let simpleAlpha = CABasicAnimation ()
        simpleAlpha.keyPath = "opacity"
        simpleAlpha.fromValue = 1
        simpleAlpha.toValue = 0.0
        
        let animGroup = CAAnimationGroup ()
        animGroup.animations = [simpleScale, simpleAlpha]
        animGroup.duration = 3
        animGroup.fillMode = kCAFillModeForwards
        animGroup.removedOnCompletion = false
        
        externalCircle.addAnimation(animGroup, forKey: "pulse")
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
