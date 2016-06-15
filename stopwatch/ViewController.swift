import UIKit

class ViewController: UIViewController {

    //MARK: Color constants
    let dayBackgroundColor = UIColor(red: 241/255.0, green: 207/255.0, blue: 99/255.0, alpha: 1.0)
    let nightBackgroundColor = UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0)
    let nightTimerColor = UIColor(red: 241/255.0, green: 207/255.0, blue: 99/255.0, alpha: 1.0)
    let dayTimerColor = UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0)

    //MARK: Properties
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var clockFace: ClockFace!
    
    //MARK: Actions
    @IBAction func timerAction(sender: UITapGestureRecognizer) {
        if(timer.valid){
            stopTimer()
        }else{
            startTimer()
        }
    }
    
    var timer = NSTimer()
    var startTime = NSDate()
    var interval = NSTimeInterval(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setColors()
        timerLabel.text = stringFromTimeInterval(NSTimeInterval(0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if (motion == .MotionShake){
            reset()
        }
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
        timerLabel.text = stringFromTimeInterval(NSTimeInterval(0))
    }
    
    func updateTimer() {
        timerLabel.text = stringFromTimeInterval(startTime.timeIntervalSinceNow)
        clockFace.animate(getSecondsFromInterval(startTime.timeIntervalSinceNow))
    }
    
    func stringFromTimeInterval(interval:NSTimeInterval) -> String {
        let ti = NSInteger(abs(interval))
        let ms = Int((abs(interval) % 1) * 1000)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        return String(format: "%0.2d:%0.2d:%0.2d:%0.3d",hours,minutes,seconds,ms)
    }
    
    func getSecondsFromInterval(interval: NSTimeInterval) -> Double {
        let sharpSeconds = Double(abs(interval) % 60)
        return Double(sharpSeconds).roundToPlaces(1)
    }
    
    func setColors() {
        let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        let isDay = hour < 20 && hour > 8
        self.view.backgroundColor = isDay ? dayBackgroundColor : nightBackgroundColor
        timerLabel.textColor = isDay ? dayTimerColor : nightTimerColor
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}
