import Foundation
import UIKit

extension Double {
    
    // Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}


extension CALayer {
    
    func animate(duration duration : Double, timingFunction : CAMediaTimingFunction? = nil,
                          animation : CALayer -> Void, properties : String...) {
        self.animate(duration: duration, timingFunction: timingFunction, animation: animation, properties: properties)
    }
    
    func animate(duration duration : Double, delay : Double, timingFunction : CAMediaTimingFunction? = nil,
                          animation : CALayer -> Void, properties : String...) {
        NSTimer.schedule(delay: delay) { timer in
            self.animate(duration: duration, timingFunction: timingFunction, animation: animation, properties: properties)
        }
    }
    
    private func animate(duration duration : Double, timingFunction : CAMediaTimingFunction? = nil,
                                  animation : CALayer -> Void, properties : [String]) {
        CATransaction.setDisableActions(true)
        animation(self)
        for property in properties {
            let anim = CABasicAnimation(keyPath: property)
            if let f = timingFunction {
                anim.timingFunction = f
            }
            anim.duration = duration
            self.addAnimation(anim, forKey: nil)
        }
        
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