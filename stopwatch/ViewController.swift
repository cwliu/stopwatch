import UIKit

class ViewController: UIViewController {

    //MARK: Color constants
    let dayBackgroundColor = UIColor(red: 241/255.0, green: 207/255.0, blue: 99/255.0, alpha: 1.0)
    let nightBackgroundColor = UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0)

    //MARK: Properties
    let pulse = Pulse ()
    let shakeView = ShakeableView()
    @IBOutlet weak var clockFace: ClockFace!
    @IBOutlet weak var timer: Timer!

    var settings : UserSettings!
    
    //MARK: Actions
    @IBAction func timerAction(sender: UITapGestureRecognizer) {
        if(timer.isRunning()){
            timer.stop()
            settings.hasStopped = true
            pulse.hide()
            if(!settings.hasReset){
                NSTimer.schedule(delay: 1, handler: { timer in self.shakeView.show()})
            }
        }else {
            shakeView.hide()
            timer.start()
            settings.hasStarted = true
            pulse.hide()
            if(!settings.hasStopped){
                NSTimer.schedule(delay: 5, handler: { timer in
                    if !self.timer.isRunning() {
                        return
                    }
                    self.pulse.show()
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setColors()
        timer.clockFace = clockFace
        view.addSubview(timer)
        settings = UserSettings()
        timer.clockFace = clockFace
        print(shakeView.bounds.size.width)
        shakeView.center = CGPoint (x: self.view.center.x - shakeView.bounds.size.width, y: self.view.center.y + 90)
        pulse.center = CGPoint (x: self.view.center.x, y: self.view.center.y + 90)

        self.view.addSubview(shakeView)
        self.view.addSubview(pulse)
        shakeView.hide()

        if !settings.hasStarted {
            NSTimer.schedule(delay: 0.5, handler: { timer in
                if self.timer.isRunning() {
                    return
                }
                self.pulse.show()
            })
        }
    }

    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if (motion == .MotionShake && !timer.timer.valid){
            if(!settings.hasReset){
                confirmReset()
            }else {
                timer.reset()
            }
        }
    }
    
    func setColors() {
        let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        let isDay = hour < 20 && hour > 8

        self.view.backgroundColor = isDay ? dayBackgroundColor : nightBackgroundColor

        timer.setColorScheme(isDay ? ColorMode.day : ColorMode.night)
        clockFace.setColorScheme(isDay ? ColorMode.day : ColorMode.night)
        pulse.setColorScheme(isDay ? ColorMode.day : ColorMode.night)
    }

    func confirmReset() {
        let confirmDialog = UIAlertController(title: "Reset", message: "Do you want to reset the timer?", preferredStyle: .Alert)
        confirmDialog.addAction(UIAlertAction(title: "Reset", style: .Default, handler: { action in
            self.settings.hasReset = true
            self.shakeView.hide()
            self.timer.reset()
            }
        ))
        confirmDialog.addAction(UIAlertAction(title: "Do nothing", style: .Cancel, handler: nil))
        presentViewController(confirmDialog, animated: true, completion: nil)
    }
}

enum ColorMode {
    case day, night
}
