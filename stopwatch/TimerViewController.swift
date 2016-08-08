import UIKit

class TimerViewController: UIViewController {

    //MARK: Properties
    let pulse = Pulse ()
    let shakeView = ShakeableView()
    let clockFace = ClockFace()
    @IBOutlet weak var timer: TimerView!

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

        view.addSubview(timer)
        clockFace.center = ClockFace.clockHandLocation(self.view, clockFaceView: clockFace)
        view.addSubview(clockFace)
        settings = UserSettings()

        timer.clockFace = clockFace
        shakeView.center = CGPoint (x: self.view.center.x - shakeView.bounds.size.width, y: self.view.center.y + 90)
        pulse.center = CGPoint (x: self.view.center.x, y: self.view.center.y + 90)
        shakeView.hide()

        self.view.addSubview(shakeView)
        self.view.addSubview(pulse)

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
            reset()
        }
    }
	
	func reset() {
		if (!settings.hasReset){
			confirmReset()
		} else {
			Datastore.instance.saveTimer(timer.startTime, duration: abs(timer.interval))
			timer.reset()
		}
	}

    func confirmReset() {
        let confirmDialog = UIAlertController(title: "Reset", message: "Do you want to reset the timer?", preferredStyle: .Alert)
        confirmDialog.addAction(UIAlertAction(title: "Reset", style: .Default, handler: { action in
			Datastore.instance.saveTimer(self.timer.startTime, duration: abs(self.timer.interval))
            self.settings.hasReset = true
            self.shakeView.hide()
            self.timer.reset()
            }
        ))
        confirmDialog.addAction(UIAlertAction(title: "Do nothing", style: .Cancel, handler: nil))
        presentViewController(confirmDialog, animated: true, completion: nil)
    }
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return AppDelegate.instance.colorScheme.statusBarStyle
	}
}
