//
//  ViewController.swift
//  stopwatch
//
//  Created by Taavi Rehemägi on 14/06/16.
//  Copyright © 2016 Toggl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var timerLabel: UILabel!
    
    //MARK: Actions
    @IBAction func timerAction(sender: UITapGestureRecognizer) {
        if(timer.valid){
            stopTimer()
        }else{
            startTimer()
        }
    }
    
    
    let daycolor = UIColor(red: 241/255.0, green: 207/255.0, blue: 99/255.0, alpha: 1.0)
    let nightColor = UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0)
    
    var timer = NSTimer()
    var startTime = NSDate()
    var interval = NSTimeInterval(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = daycolor
        timerLabel.text = "00:00:00:000"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTimer() {
        startTime = NSDate.init(timeIntervalSinceNow: interval)
        timer = NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        interval += startTime.timeIntervalSinceNow - interval
        timer.invalidate()
    }
    
    func reset(){
        interval = NSTimeInterval(0)
    }
    
    func updateTimer() {
        timerLabel.text = stringFromTimeInterval(startTime.timeIntervalSinceNow)
    }
    
    func stringFromTimeInterval(interval:NSTimeInterval) -> String {
        let ti = NSInteger(abs(interval))
        let ms = Int((abs(interval) % 1) * 1000)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        return String(format: "%0.2d:%0.2d:%0.2d:%0.3d",hours,minutes,seconds,ms)
    }

}

