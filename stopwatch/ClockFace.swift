import UIKit

class ClockFace: UIView {
    let midView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))

    var clockHand = CAShapeLayer()
    var midLayer = CALayer()
    var currentSeconds = 0.0;

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clearColor()
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        CGPathAddLineToPoint(path, nil, 0, -2)
        clockHand.strokeColor = UIColor.blackColor().CGColor
        clockHand.path = path
        clockHand.lineWidth = 0.01
        midLayer.addSublayer(clockHand)
        midLayer.setAffineTransform(CGAffineTransform.init(a: frame.width/4.0, b: 0, c: 0, d: frame.height / 4.0, tx: frame.width / 2.0, ty: frame.height / 2.0))
        
        layer.addSublayer(midLayer)
    }
    
    func animate(seconds: Double) {
        
        if(seconds == currentSeconds) { //don't run the animation on every call (run it 10 times a second).
            return;
        }
        currentSeconds = seconds;
        
        let angle = seconds * 6.0
        let rotation = CGAffineTransformMakeRotation(CGFloat(Double(angle) / 180.0 * M_PI))
        UIView.animateWithDuration(0.1, animations: { () -> Void in self.clockHand.setAffineTransform(rotation)})
    }
    
}
