//
//  Pulse.swift
//  stopwatch
//
//  Created by Angel Ernesto Anton Yebra on 16/06/16.
//  Copyright © 2016 Toggl. All rights reserved.
//

import UIKit

class Pulse: UIView {

    var colorExt : CGColor
    var colorInt : CGColor
    var radExt : CGFloat
    var radInt : CGFloat
    
    init(colorExt:UIColor, colorInt:UIColor, radExt:Float, radInt:Float) {
        self.colorExt = colorExt.CGColor
        self.colorInt = colorInt.CGColor
        self.radExt = CGFloat (radExt)
        self.radInt = CGFloat (radInt)
        
        super.init(frame: CGRect (x: 0.0, y:0.0, width: 1.0, height: 1.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {

        // interal
        let internalCircle = CAShapeLayer ();
        let path = UIBezierPath ()
        path.addArcWithCenter(CGPoint.init(x:0,y:0), radius: radInt, startAngle: 0.0 * CGFloat ((M_PI/180.0)), endAngle: 360 * CGFloat((M_PI/180.0)), clockwise: true)
        
        internalCircle.path = path.CGPath
        internalCircle.fillColor = colorInt
        
        // external
        let externalCircle = CAShapeLayer ()
        let staticPath = UIBezierPath ()
        staticPath.addArcWithCenter(CGPoint.init(x:0,y:0), radius: radExt, startAngle: 0.0 * CGFloat ((M_PI/180.0)), endAngle: 360 * CGFloat((M_PI/180.0)), clockwise: true)
        
        externalCircle.path = staticPath.CGPath
        externalCircle.fillColor = colorExt
        
        // anims
        let bounceAlphaAnim = CAKeyframeAnimation ()
        bounceAlphaAnim.keyPath = "opacity"
        bounceAlphaAnim.values = [1, 0.4, 1]
        
        let bounceScaleAnim = CAKeyframeAnimation ()
        bounceScaleAnim.keyPath = "transform.scale.xy"
        bounceScaleAnim.values = [0.5, 0.8, 0.5]
        
        let simpleScale = CABasicAnimation ()
        simpleScale.keyPath = "transform.scale.xy"
        simpleScale.fromValue = 0.0
        simpleScale.toValue = 1.0
        
        let simpleAlpha = CABasicAnimation ()
        simpleAlpha.keyPath = "opacity"
        simpleAlpha.fromValue = 1
        simpleAlpha.toValue = 0.0
        
        // groups
        let internalAnimGroup = CAAnimationGroup ()
        internalAnimGroup.animations = [bounceAlphaAnim, bounceScaleAnim]
        internalAnimGroup.repeatCount = 1000
        internalAnimGroup.duration = 5
        
        let externalAnimGroup = CAAnimationGroup ()
        externalAnimGroup.animations = [simpleScale, simpleAlpha]
        externalAnimGroup.repeatCount = 1000
        externalAnimGroup.duration = 3
        
        internalCircle.addAnimation(internalAnimGroup, forKey: "scale")
        externalCircle.addAnimation(externalAnimGroup, forKey: "pulse")
        
        self.layer.addSublayer(externalCircle)
        self.layer.addSublayer(internalCircle)
    }

    
    
    
    
    

}
