import UIKit

class TimerView: UILabel {

    var timer = NSTimer()
    var startTime = NSDate()
    var interval = NSTimeInterval(0)
    var secondFraction = UILabel()
    
    var clockFace: ClockFace! {
        didSet{
            if clockFace !== oldValue {
                clockFace.hidden = true
            }
        }
    }
	
	var secondaryClockFaces: [ClockFace] = []
	var secondaryLabels: [UILabel] = []
	var prettySecondaryLabels: [UILabel] = []

    let screenSize: CGRect = UIScreen.mainScreen().bounds

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        font = UIFont.monospacedDigitSystemFontOfSize(TimerView.timerLabelSize(), weight: UIFontWeightUltraLight)
        secondFraction.text = ".0"
        secondFraction.font = font
        secondFraction.textColor = textColor
        secondFraction.layer.opacity = 0
        secondFraction.translatesAutoresizingMaskIntoConstraints = false
        addSubview(secondFraction)
        secondFraction.leftAnchor.constraintEqualToAnchor(rightAnchor).active = true
        secondFraction.topAnchor.constraintEqualToAnchor(topAnchor).active = true

        updateLabel()
		setColorScheme()
    }

    func start() {
        startTime = NSDate.init(timeIntervalSinceNow: interval)
		
		timer = NSTimer(timeInterval: 0.1, target: self, selector: #selector(TimerView.tick), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
		
        if let clock = clockFace {
            clock.show()
        }
		for secondaryClockFace in secondaryClockFaces {
			secondaryClockFace.show()
		}
        animateSecondFractionOpacity(0.5, delay: 0)
        
        animateTextOffset(1, duration: 0.6, delay: 0)
    }

    func stop() {
        interval += startTime.timeIntervalSinceNow - interval
        timer.invalidate()
    }
    
    func reset() {
        startTime = NSDate()
        interval = NSTimeInterval(0)
        if let clock = clockFace {
            clock.hide()
        }
		for secondaryClockFace in secondaryClockFaces {
			secondaryClockFace.hide()
		}
        animateTextOffset(0, duration: 1, delay: 0.4)
        
        NSTimer.schedule(delay: 0.4, handler: { timer in
            if self.isRunning() {
                return
            }
            let animation: CATransition = CATransition()
            animation.duration = 0.3
            animation.type = kCATransitionFade
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            self.layer.addAnimation(animation, forKey: "changeTextTransition")
            self.updateLabel()
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0)
            self.secondFraction.layer.opacity = 0
            CATransaction.commit()
        })
    }

    func isRunning() -> Bool {
        return timer.valid
    }
    
    func currentSeconds() -> Double {
        let sharpSeconds = Double(abs(interval) % 60)
        return Double(sharpSeconds).roundToPlaces(1)
    }
    
    func tick() {
        interval = startTime.timeIntervalSinceNow
        
        updateLabel()
        
        if let clock = clockFace {
            clock.animate(currentSeconds())
        }
		for secondaryClockFace in secondaryClockFaces {
			secondaryClockFace.animate(currentSeconds())
		}
    }
    
    func animateTextOffset(amount : Float, duration : Double, delay : Double) {
        let a = CGFloat(amount)
        let x = -secondFraction.frame.width / 2
        let y = CGFloat(superview!.frame.height / 2 - frame.height / 2) - TimerView.timerLabelFromBottom()
        animateLayer(layer,
            duration: duration, delay: delay,
            timingFunction: CAMediaTimingFunction(controlPoints: 0.2, 0, 0, 1),
            animation: { l in
                l.setAffineTransform(CGAffineTransformMakeTranslation(x * a, y * a))
            },
            properties: "transform")
    }
    
    func animateSecondFractionOpacity(opacity : Float, delay : Double) {
        animateLayer(secondFraction.layer, duration: 0.3, delay: delay,
                     animation: { l in l.opacity = opacity },
                     properties: "opacity")
    }
    
    func updateLabel() {
        let ti = NSInteger(abs(interval))
        let ms = Int((abs(interval) % 1) * 10)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        text = String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
        
        secondFraction.text = String(format: ".%0.1d", ms)
		for secondaryLabel in secondaryLabels {
			secondaryLabel.text = text! + String(format: ".%0.1d", ms)
		}
		for prettySecondaryLabel in prettySecondaryLabels {
			prettySecondaryLabel.text = NSDateComponentsFormatter.prettyFormattedInterval(interval)
		}
    }

    func setColorScheme() {
		self.textColor = AppDelegate.instance.colorScheme.timerColor
		secondFraction.textColor = AppDelegate.instance.colorScheme.timerColor
    }

    static func timerLabelSize() -> CGFloat {
        if(AppDelegate.isIPhone5orLower())
        {
            return CGFloat(48)
        }
        return CGFloat(56)
    }

    static func timerLabelFromBottom() -> CGFloat {
        if(AppDelegate.isIphone4s())
        {
            return CGFloat(24)
        } else if (AppDelegate.isIPhone5orLower()) {
            return CGFloat(42)
        }
        return CGFloat(80)
    }
}
