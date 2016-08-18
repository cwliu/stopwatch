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
    
    var isEnjoyDialog: UIView!
    var askRatingDialog: UIView!
    var askFeedbackDialog: UIView!
    
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
        
        isEnjoyDialog = createDialog(
            "Enjoying Stopwatch?",
            yesString: "Yes!", noString: "Not really",
            yesCallback: #selector(self.enjoyYesClick),
            noCallbalk: #selector(self.enjoyNoClick),
            titleHeight: 30
        )
        
        askRatingDialog = createDialog(
            "Would you mind taking a moment\nto rate it in the App Store?",
            yesString: "Ok, sure", noString: "No, thanks",
            yesCallback: #selector(self.ratingYesClick),
            noCallbalk: #selector(self.ratingNoClick),
            titleHeight: 49
        )

        askFeedbackDialog = createDialog(
            "Would you mind giving us some feedback?",
            yesString: "Ok, sure", noString: "No, thanks",
            yesCallback: #selector(self.feedbackYesClick),
            noCallbalk: #selector(self.feedbackNoClick),
            titleHeight: 49
        )
    }
    
    func createDialog(titleString: String, yesString: String, noString: String,
                      yesCallback: Selector, noCallbalk: Selector, titleHeight: Int) -> UIView {
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        let margin = 20
        let dialogHeight = 170
        
        let dialogView = UIView(frame: CGRect(
            x: 0,y: Int(screenHeight) - dialogHeight - titleHeight,
            width: Int(screenWidth), height: dialogHeight + titleHeight))
        dialogView.backgroundColor = UIColor.whiteColor()
        dialogView.layer.cornerRadius = 5
        
        let title = UITextView(frame: CGRect(x: margin, y: 24, width: Int(screenWidth) - 2 * margin,height: titleHeight))
        title.text = titleString
        title.font = UIFont(name: title.font!.fontName, size: 16)
        title.textAlignment = NSTextAlignment.Center
        
        dialogView.addSubview(title)
        let noButton = UIButton(frame: CGRect(x: margin, y: 47 + titleHeight, width: Int(screenWidth) - 2 * margin, height: 46))
        noButton.setTitle(noString, forState: UIControlState.Normal)
        noButton.backgroundColor = UIColor(red: 255/255.0, green: 212/255.0, blue: 96/255.0, alpha: 1)
        noButton.addTarget(self, action: noCallbalk, forControlEvents: .TouchUpInside)
        noButton.titleLabel?.font = UIFont(name: noButton.titleLabel!.font!.fontName, size: 16)
        noButton.layer.cornerRadius = 4
        dialogView.addSubview(noButton)
        
        let yesButton = UIButton(frame: CGRect(x: margin, y: 109 + titleHeight, width: Int(screenWidth) - 2 * margin, height: 46))
        yesButton.setTitle(yesString, forState: UIControlState.Normal)
        yesButton.backgroundColor = UIColor(red: 240/255.0, green: 123/255.0, blue: 63/255.0, alpha: 1)
        yesButton.addTarget(self, action: yesCallback, forControlEvents: .TouchUpInside)
        yesButton.titleLabel?.font = UIFont(name: yesButton.titleLabel!.font!.fontName, size: 16)
        yesButton.layer.cornerRadius = 4
        dialogView.addSubview(yesButton)
        
        return dialogView
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
        self.view.addSubview(isEnjoyDialog)
    }
    
    func enjoyYesClick(){
        isEnjoyDialog.removeFromSuperview()
        self.view.addSubview(askRatingDialog)
    }

    func enjoyNoClick(){
        isEnjoyDialog.removeFromSuperview()
        self.view.addSubview(askFeedbackDialog)
    }
    
    func ratingYesClick(){
        let appId = "id1126783712"

        askRatingDialog.removeFromSuperview()
        UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/" + appId)!)
    }
    
    func ratingNoClick(){
        askRatingDialog.removeFromSuperview()
    }
    
    func feedbackYesClick(){
        askFeedbackDialog.removeFromSuperview()
        
        let feedbackViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FeedbackController") as! FeedbackViewController
        self.presentViewController(feedbackViewController, animated: true, completion: nil)
    }

    func feedbackNoClick(){
        askFeedbackDialog.removeFromSuperview()
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
