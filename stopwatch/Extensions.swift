import Foundation
import UIKit

extension Double {
    
    // Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}


func animateLayer<T : CALayer>(layer : T, duration : Double, timingFunction : CAMediaTimingFunction? = nil,
             animation : T -> Void, properties : String...) {
    animateLayerImpl(layer, duration: duration, timingFunction: timingFunction, animation: animation, properties: properties)
}
func animateLayer<T : CALayer>(layer : T, duration : Double, delay : Double, timingFunction : CAMediaTimingFunction? = nil,
             animation : T -> Void, properties : String...) {
    
    if delay <= 0 {
        animateLayerImpl(layer, duration: duration, timingFunction: timingFunction, animation: animation, properties: properties)
        return;
    }
    
    NSTimer.schedule(delay: delay) { timer in
        animateLayerImpl(layer, duration: duration, timingFunction: timingFunction, animation: animation, properties: properties)
    }
}
func animateLayerImpl<T : CALayer>(layer : T, duration : Double, timingFunction : CAMediaTimingFunction? = nil,
             animation : T -> Void, properties : [String]) {
    CATransaction.setDisableActions(true)
    animation(layer)
    for property in properties {
        let anim = CABasicAnimation(keyPath: property)
        if let f = timingFunction {
            anim.timingFunction = f
        }
        anim.duration = duration
        layer.addAnimation(anim, forKey: nil)
    }
}

extension NSTimer {
    
    class func schedule(delay delay: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
    
    class func schedule(repeatInterval interval: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
}

extension AppDelegate {

    class func isIphone4s () -> Bool{
        return max(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height) == 480.0
    }
    class func isIPhone5orLower () -> Bool{
        return max(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height) <= 568.0
    }
}