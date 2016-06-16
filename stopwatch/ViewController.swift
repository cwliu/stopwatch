import UIKit

class ViewController: UIViewController {

    //MARK: Color constants
    let dayBackgroundColor = UIColor(red: 241/255.0, green: 207/255.0, blue: 99/255.0, alpha: 1.0)
    let nightBackgroundColor = UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0)
    let nightTimerColor = UIColor(red: 241/255.0, green: 207/255.0, blue: 99/255.0, alpha: 1.0)
    let dayTimerColor = UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0)

    //MARK: Properties
    @IBOutlet weak var timerLabel: Timer!
    @IBOutlet weak var clockFace: ClockFace!
    
    //MARK: Actions
    @IBAction func timerAction(sender: UITapGestureRecognizer) {
        timerLabel.startOrStop()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setColors()
        timerLabel.clockFace = clockFace
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
            timerLabel.reset()
        }
    }
    
    func setColors() {
        let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        let isDay = hour < 20 && hour > 8
        self.view.backgroundColor = isDay ? dayBackgroundColor : nightBackgroundColor
        timerLabel.textColor = isDay ? dayTimerColor : nightTimerColor
    }
}


