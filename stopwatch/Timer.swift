//
//  Timer.swift
//  stopwatch
//
//  Created by Taavi Rehemägi on 16/06/16.
//  Copyright © 2016 Toggl. All rights reserved.
//

import UIKit

class Timer: UILabel {

    var timer = NSTimer()
    var startTime = NSDate()
    var interval = NSTimeInterval(0)
    var secondFraction = UILabel()
    
    var yConstraint : NSLayoutConstraint?
    var xConstraint : NSLayoutConstraint?
    
    var clockFace: ClockFace! {
        didSet{
            if clockFace !== oldValue {
                clockFace.hidden = true
            }
        }
    }
    
    required init() {
        super.init(frame: CGRect())
        interval = NSTimeInterval(0)
        
        font = UIFont.monospacedDigitSystemFontOfSize(56, weight: UIFontWeightUltraLight)
        secondFraction.text = ".0"
        secondFraction.font = font
        secondFraction.textColor = textColor
        secondFraction.layer.opacity = 0
        secondFraction.translatesAutoresizingMaskIntoConstraints = false
        addSubview(secondFraction)
        secondFraction.leftAnchor.constraintEqualToAnchor(rightAnchor).active = true
        secondFraction.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        
        updateLabel()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initLayout() {
        xConstraint = centerXAnchor.constraintEqualToAnchor(superview!.centerXAnchor)
        yConstraint = centerYAnchor.constraintEqualToAnchor(superview!.centerYAnchor)
        
        xConstraint!.active = true
        yConstraint!.active = true
        
    }

    func start() {
        startTime = NSDate.init(timeIntervalSinceNow: interval)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(Timer.tick), userInfo: nil, repeats: true)
        if let clock = clockFace {
            clock.show()
        }
        animateSecondFractionOpacity(0.5)
        
        
        self.yConstraint!.constant = 100
        
        UIView.animateWithDuration(1, animations: { self.superview!.layoutIfNeeded() })
    }

    func stop() {
        interval += startTime.timeIntervalSinceNow - interval
        timer.invalidate()
    }
    
    func reset() {
        startTime = NSDate()
        interval = NSTimeInterval(0)
        updateLabel()
        if let clock = clockFace {
            clock.hide()
        }
        animateSecondFractionOpacity(0)
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
    }
    
    func animateSecondFractionOpacity(opacity : Float) {
        animateLayer(secondFraction.layer, duration: 0.3,
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
        
        if interval != NSTimeInterval(0) {
            secondFraction.text = String(format: ".%0.1d", ms)
        }
    }

    let nightTimerColor = UIColor(red: 241/255.0, green: 207/255.0, blue: 99/255.0, alpha: 1.0)
    let dayTimerColor = UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0)

    func setColorScheme(mode: ColorMode) {
        if(mode == ColorMode.day) {
            self.textColor = dayTimerColor
            secondFraction.textColor = dayTimerColor
        } else {
            textColor = self.nightTimerColor
            secondFraction.textColor = nightTimerColor
        }
    }
}
