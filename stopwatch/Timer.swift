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
        makeLabelMonospaced()
        tick()
    }

    func start() {
        startTime = NSDate.init(timeIntervalSinceNow: interval)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(Timer.tick), userInfo: nil, repeats: true)
        if let clock = clockFace {
            clock.show()
        }
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
    
    func updateLabel() {
        
        let ti = NSInteger(abs(interval))
        let ms = Int((abs(interval) % 1) * 10)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        self.text = String(format: "%0.2d:%0.2d:%0.2d:%0.1d",hours,minutes,seconds,ms)
    }
    
    func makeLabelMonospaced() {
        let font = self.font
        self.font = UIFont.monospacedDigitSystemFontOfSize(font.pointSize, weight: UIFontWeightUltraLight)
    }
}
