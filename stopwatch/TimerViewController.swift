import UIKit

class TimerViewController: UIViewController {

    //MARK: Properties
    let pulse = Pulse ()
    let shakeView = ShakeableView()
    let clockFace = ClockFace()
    @IBOutlet weak var timer: TimerView!
	@IBOutlet weak var historyButton: UIButton!
	@IBOutlet weak var historyHintView: UIView!
	@IBOutlet weak var historyHintArrow: UIImageView!
	@IBOutlet weak var historyHintCircles: UIImageView!
	
	var shakeTimer: NSTimer?
	
	var pulseTimer: NSTimer?

    var settings : UserSettings!
	
	var delegate: TimerDelegate?
    
    //MARK: Actions
    @IBAction func timerAction(sender: UITapGestureRecognizer) {
        if(timer.isRunning()) {
			if pulseTimer != nil {
				pulseTimer?.invalidate()
				pulseTimer = nil
			}
            timer.stop()
            settings.hasStopped = true
            pulse.hide()
            if (!settings.hasReset) {
               shakeTimer = NSTimer.schedule(delay: 1, handler: { timer in self.shakeView.show()})
            }
        } else {
			if shakeTimer != nil {
				shakeTimer?.invalidate()
				shakeTimer = nil
			}
			timer.secondaryClockFaces = (delegate?.getSecondaryClockFaces())!
			timer.secondaryLabels = (delegate?.getSecondaryLabels())!
			timer.prettySecondaryLabels = (delegate?.getPrettySecondaryLabels())!
            shakeView.hide()
            timer.start()
			delegate?.timerStarted()
            settings.hasStarted = true
            pulse.hide()
            if(!settings.hasStopped){
                pulseTimer = NSTimer.schedule(delay: 5, handler: { timer in
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
        clockFace.center = ClockFace.clockHandLocation(view, clockFaceView: clockFace)
        view.addSubview(clockFace)
        settings = UserSettings()

        timer.clockFace = clockFace
        shakeView.center = CGPoint (x: view.center.x - shakeView.bounds.size.width, y: view.center.y + 90)
        pulse.center = CGPoint (x: view.center.x, y: view.center.y + 90)
        shakeView.hide()

        view.addSubview(shakeView)
        view.addSubview(pulse)

        if !settings.hasStarted {
            NSTimer.schedule(delay: 0.5, handler: { timer in
                if self.timer.isRunning() {
                    return
                }
                self.pulse.show()
            })
        }
		
		historyButton.setImage(AppDelegate.instance.colorScheme.historyButton, forState: .Normal)
		historyHintArrow.image = AppDelegate.instance.colorScheme.historyHintArrow
		historyHintCircles.image = AppDelegate.instance.colorScheme.historyHintCircles
		
		refreshHistoryHint()
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

            if(meetRatingCriteria()){
                rateApp()
            }
        }
    }
	
	func refreshHistoryHint() {
		if historyHintView.hidden && settings.showHistoryHint {
			historyHintView.hidden = false
			historyHintView.alpha = 0
			historyButton.hidden = false
			historyButton.alpha = 0
			UIView.animateWithDuration(0.5) {
				self.historyHintView.alpha = 1
				self.historyButton.alpha = 1
			}
		} else {
			historyHintView.hidden = settings.showHistoryHint == false
		}
	}
	
	func reset() {
		if (!settings.hasReset){
			confirmReset()
		} else {
			refreshHistoryHint()
			delegate?.timerReset()
			Datastore.instance.saveTimer(timer.startTime, duration: abs(timer.interval))
			delegate?.timerSaved()
			timer.reset()
		}
	}

    func meetRatingCriteria() -> Bool{
        // TODO
        return true
    }

    func rateApp() {

        let appId = "id1126783712"

        let askRatingDialog = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        askRatingDialog.view.backgroundColor = UIColor.whiteColor()
        let askRatingTitle = NSAttributedString(string: "Would you mind taking a moment to rate it in the App Store?", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(16),
            NSForegroundColorAttributeName : AppDelegate.instance.colorScheme.textColor
            ])
        askRatingDialog.setValue(askRatingTitle, forKey: "attributedTitle")


        let askRatingYesAction = UIAlertAction(title: "Ok, sure", style: .Default, handler: { action in
            UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/" + appId)!)
        })
        let askRatingNoAction = UIAlertAction(title: "No, thanks", style: .Cancel, handler: nil)
        askRatingDialog.addAction(askRatingNoAction)
        askRatingDialog.addAction(askRatingYesAction)

        let askFeedbackDialog = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let feedbackTitle = NSAttributedString(string: "Would you mind giving us some feedback?", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(16),
            NSForegroundColorAttributeName : AppDelegate.instance.colorScheme.textColor
            ])
        askFeedbackDialog.setValue(feedbackTitle, forKey: "attributedTitle")

        
        askFeedbackDialog.view.backgroundColor = UIColor.whiteColor()
        
        let feedbackYesAction = UIAlertAction(title: "Ok, sure", style: .Default, handler: { action in
            let feedbackViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FeedbackController") as! FeedbackViewController
            self.presentViewController(feedbackViewController, animated: true, completion: nil)
        })
        let feedbackNoAction = UIAlertAction(title: "No, thanks", style: .Cancel, handler: nil)
        askFeedbackDialog.addAction(feedbackNoAction)
        askFeedbackDialog.addAction(feedbackYesAction)
        
        let isEnjoyDialog = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        isEnjoyDialog.view.backgroundColor = UIColor.whiteColor()
        
        let isEnjoyTitle = NSAttributedString(string: "Enjoying Stopwatch?", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(16),
            NSForegroundColorAttributeName : AppDelegate.instance.colorScheme.textColor
            ])
        isEnjoyDialog.setValue(isEnjoyTitle, forKey: "attributedTitle")
        
        let isEnjoyYesAction = UIAlertAction(title: "Yes!", style: .Default, handler: { action in
            self.presentViewController(askRatingDialog, animated: true, completion: nil)

        })
        let isEnjoyNoAction = UIAlertAction(title: "Not really", style: .Cancel, handler: { action in
            self.presentViewController(askFeedbackDialog, animated: true, completion: nil)
        })

        isEnjoyDialog.addAction(isEnjoyNoAction)
        isEnjoyDialog.addAction(isEnjoyYesAction)

        self.presentViewController(isEnjoyDialog, animated: true, completion: nil)
    }

    func confirmReset() {
        let confirmDialog = UIAlertController(title: "Reset", message: "Do you want to reset the timer?", preferredStyle: .Alert)
        confirmDialog.addAction(UIAlertAction(title: "Reset", style: .Default, handler: { action in
			self.delegate?.timerReset()
			self.settings.showHistoryHint = true
			self.refreshHistoryHint()
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
