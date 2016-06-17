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
    
    var clockFace: ClockFace! {
        didSet{
            if clockFace !== oldValue {
                clockFace.hidden = true
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        interval = NSTimeInterval(0)
        
        secondFraction.text = ".0"
        secondFraction.font = font
        secondFraction.textColor = textColor
        secondFraction.layer.opacity = 0
        secondFraction.translatesAutoresizingMaskIntoConstraints = false
        addSubview(secondFraction)
        secondFraction.leftAnchor.constraintEqualToAnchor(rightAnchor).active = true
        secondFraction.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        
        makeLabelMonospaced()
        updateLabel()
    }

    func start() {
        startTime = NSDate.init(timeIntervalSinceNow: interval)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(Timer.tick), userInfo: nil, repeats: true)
        if let clock = clockFace {
            clock.show()
        }
        animateSecondFractionOpacity(0.5)
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
    
    func startOrStop() {
        timer.valid ? stop() : start();
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
    
    func makeLabelMonospaced() {
        let font = self.font
        self.font = UIFont.monospacedDigitSystemFontOfSize(font.pointSize, weight: UIFontWeightUltraLight)
    }
}
