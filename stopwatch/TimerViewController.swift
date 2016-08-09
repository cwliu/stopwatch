import UIKit

class TimerViewController: UIViewController {

    //MARK: Properties
    let pulse = Pulse ()
    let shakeView = ShakeableView()
    let clockFace = ClockFace()
    @IBOutlet weak var timer: TimerView!
	@IBOutlet weak var historyButton: UIButton!

    var settings : UserSettings!
	
	var delegate: TimerDelegate?
    
    //MARK: Actions
    @IBAction func timerAction(sender: UITapGestureRecognizer) {
        if(timer.isRunning()){
            timer.stop()
			delegate?.timerStopped()
            settings.hasStopped = true
            pulse.hide()
            if(!settings.hasReset){
                NSTimer.schedule(delay: 1, handler: { timer in self.shakeView.show()})
            }
        } else {
            shakeView.hide()
            timer.start()
			delegate?.timerStarted()
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
		
		historyButton.setImage(AppDelegate.instance.colorScheme.historyButton, forState: .Normal)
    }
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		becomeFirstResponder()
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
			delegate?.timerReset()
			Datastore.instance.saveTimer(timer.startTime, duration: abs(timer.interval))
			delegate?.timerSaved()
			timer.reset()
		}
	}

    func confirmReset() {
        let confirmDialog = UIAlertController(title: "Reset", message: "Do you want to reset the timer?", preferredStyle: .Alert)
        confirmDialog.addAction(UIAlertAction(title: "Reset", style: .Default, handler: { action in
			self.delegate?.timerReset()
			Datastore.instance.saveTimer(self.timer.startTime, duration: abs(self.timer.interval))
			self.delegate?.timerSaved()
            self.settings.hasReset = true
            self.shakeView.hide()
            self.timer.reset()
            }
        ))
        confirmDialog.addAction(UIAlertAction(title: "Do nothing", style: .Cancel, handler: nil))
        presentViewController(confirmDialog, animated: true, completion: nil)
    }
	
	@IBAction func showHistory() {
		delegate?.showHistory()
	}
}
