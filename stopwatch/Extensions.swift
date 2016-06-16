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
    func animate(duration duration : Double, timingFunction : CAMediaTimingFunction? = nil, animation : CALayer -> Void, properties : String...) {
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