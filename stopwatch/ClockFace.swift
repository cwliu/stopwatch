import UIKit

class ClockFace: UIView {
    let dotColor = UIColor(red: 232/255.0, green: 126/255.0, blue: 92/255.0, alpha: 1.0)
    let dotWidth = CGFloat(8)

    var clockHand = CAShapeLayer()
    var midLayer = CALayer()
    var centerDot = CALayer()
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
        
        centerDot.backgroundColor = dotColor.CGColor
        scaleDot(0)
        
        layer.addSublayer(centerDot)
    }
    
    func animate(seconds: Double) {
        
        if(seconds == currentSeconds) { //don't run the animation on every call (run it 10 times a second).
            return;
        }
        currentSeconds = seconds;
        
        let angle = seconds * 6.0
        let rotation = CGAffineTransformMakeRotation(CGFloat(Double(angle) / 180.0 * M_PI))
        self.clockHand.setAffineTransform(rotation)
    }
    
    func scaleDot(size : CGFloat) {
        
        centerDot.animate(0.5, animation: { (layer) -> Void in
                layer.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
                layer.bounds = CGRect(x: 0, y: 0, width: size, height: size)
                layer.cornerRadius = size / 2
            }, properties: "position", "bounds", "cornerRadius"
        )
    }
    
    func hide() {
        scaleDot(0)
    }
    
    func show() {
        hidden = false
        scaleDot(dotWidth)
    }
}

