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
    
    var isEnjoyDialog: UIAlertController!
    var askRatingDialog: UIAlertController!
    var askFeedbackDialog: UIAlertController!
    
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
        setupDialog()
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
	
    func setupDialog(){
        
        isEnjoyDialog = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        askRatingDialog = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        askFeedbackDialog = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        configDialog(isEnjoyDialog, title: "\nEnjoying Stopwatch?\n\n\n\n\n\n\n\n",
                     yesString: "Yes!", noString: "Not really",
                     yesCallback: #selector(self.enjoyYesClick), noCallbalk: #selector(self.enjoyNoClick),
                     titleHeight: 66
        )

        configDialog(askRatingDialog, title: "\nWould you mind taking a moment to rate it in the App Store?\n\n\n\n\n\n\n\n",
                     yesString: "Ok, sure", noString: "No, thanks",
                     yesCallback: #selector(self.ratingYesClick), noCallbalk: #selector(self.ratingNoClick),
                     titleHeight: 110
        )
        
        configDialog(askFeedbackDialog, title: "\nWould you mind giving us some feedback?\n\n\n\n\n\n\n\n",
                     yesString: "Ok, sure", noString: "No, thanks",
                     yesCallback: #selector(self.feedbackYesClick), noCallbalk: #selector(self.feedbackNoClick),
                     titleHeight: 90
        )
        
    }
    
    func configDialog(alert: UIAlertController, title: String, yesString: String, noString: String,
                      yesCallback: Selector, noCallbalk: Selector, titleHeight: CGFloat){
        let margin:CGFloat = 20.0
        
        let isEnjoyTitle = NSAttributedString(string: title, attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(20),
            NSForegroundColorAttributeName : UIColor(red: 32/255.0, green: 31/255.0, blue: 61/255.0, alpha: 1)
            ])
        
        alert.setValue(isEnjoyTitle, forKey: "attributedTitle")
        alert.view.alpha = 1
        let isEnjoyCancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(isEnjoyCancelAction)
        
        
        let noRect = CGRectMake(margin, margin + titleHeight, alert.view.bounds.size.width - margin * 3, 50.0)
        let noButton = UIButton(frame: noRect)
        noButton.backgroundColor = UIColor(red: 255/255.0, green: 212/255.0, blue: 96/255.0, alpha: 1.0)
        noButton.addTarget(self, action: noCallbalk, forControlEvents: .TouchUpInside)
        noButton.layer.cornerRadius = 7
        noButton.setTitle(noString, forState: UIControlState.Normal)
        alert.view.addSubview(noButton)
        
        
        let yesRect = CGRectMake(margin, margin + titleHeight + 70, alert.view.bounds.size.width - margin * 3.0, 50.0)
        let yesButton = UIButton(frame: yesRect)
        yesButton.backgroundColor = UIColor(red: 240/255.0, green: 123/255.0, blue: 63/255.0, alpha: 1.0)
        yesButton.addTarget(self, action: yesCallback, forControlEvents: .TouchUpInside)
        yesButton.layer.cornerRadius = 7
        yesButton.setTitle(yesString, forState: UIControlState.Normal)
        alert.view.addSubview(yesButton)
        
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
        if(settings.hasAskedFeedback){
            return false
        }
        
        settings.updateUsageDay()
        
        let timers = Datastore.instance.fetchTimers()
        if(timers.count >= 10 && settings.usageDay >= 3){
            return true
        }else{
            return false
        }
    }

    func rateApp() {
        settings.hasAskedFeedback = true
        self.presentViewController(isEnjoyDialog, animated: true, completion: nil)
    }
    
    func enjoyYesClick(){
        isEnjoyDialog.dismissViewControllerAnimated(true, completion: nil)
        self.presentViewController(askRatingDialog, animated: true, completion: nil)
    }

    func enjoyNoClick(){
        isEnjoyDialog.dismissViewControllerAnimated(true, completion: nil)
        self.presentViewController(askFeedbackDialog, animated: true, completion: nil)
    }
    
    func ratingYesClick(){
        let appId = "id1126783712"

        askRatingDialog.dismissViewControllerAnimated(true, completion: nil)
        UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/" + appId)!)
    }
    
    func ratingNoClick(){
        askRatingDialog.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func feedbackYesClick(){
        askFeedbackDialog.dismissViewControllerAnimated(true, completion: nil)
        
        let feedbackViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FeedbackController") as! FeedbackViewController
        self.presentViewController(feedbackViewController, animated: true, completion: nil)
    }

    func feedbackNoClick(){
        askFeedbackDialog.dismissViewControllerAnimated(true, completion: nil)
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
