
 import Foundation

 class UserSettings {

    private var defaults = NSUserDefaults.standardUserDefaults()

    private let lastOpenedKey = "lastOpened"
    private let hasStartedKey = "hasStarted"
    private let hasStoppedKey = "hasStopped"
    private let hasResetKey = "hasReset"
	private let showHistoryHintKey = "showHistoryHint"
    private let hasAskedFeedbackKey = "hasAskedFeedback"
    private let usageDayKey = "usageDayKey"

    private lazy var defaultValues : NSDictionary = [
            self.hasStartedKey : false,
            self.hasStoppedKey : false,
            self.hasResetKey : false,
            self.showHistoryHintKey: false,
            self.lastOpenedKey: NSDate(),
            self.hasAskedFeedbackKey: false,
            self.usageDayKey: 1,
    ]

    var lastOpened : NSDate! {
        set {
            defaults.setObject(newValue, forKey: lastOpenedKey)
        }
        get {
            return defaults.objectForKey(lastOpenedKey) as! NSDate
        }
    }

    var hasStarted : Bool {
        set {
            defaults.setBool(newValue, forKey: hasStartedKey)
        }
        get {
            return defaults.boolForKey(hasStartedKey)
        }
    }

    var hasStopped : Bool {
        set {
            defaults.setBool(newValue, forKey: hasStoppedKey)
        }
        get {
            return defaults.boolForKey(hasStoppedKey)
        }
    }

    var hasReset : Bool {
        set {
            defaults.setBool(newValue, forKey: hasResetKey)
        }
        get {
            return defaults.boolForKey(hasResetKey)
        }
    }
	
	var showHistoryHint : Bool {
		set {
			defaults.setBool(newValue, forKey: showHistoryHintKey)
		}
		get {
			return defaults.boolForKey(showHistoryHintKey)
		}
	}
    
    var hasAskedFeedback : Bool {
        set {
            defaults.setBool(newValue, forKey: hasAskedFeedbackKey)
        }
        get {
            return defaults.boolForKey(hasAskedFeedbackKey)
        }
    }

    var usageDay: Int {
        set {
            defaults.setInteger(newValue, forKey: usageDayKey)
        }
        get {
            return defaults.integerForKey(usageDayKey)
        }
    }

    init (){
        defaults.registerDefaults(defaultValues as! [String : AnyObject])
        resetIfMoreThanWeekOld()
    }

    func resetIfMoreThanWeekOld () {
        let weekInSeconds = 604800.0 //week in seconds

        let now = NSDate()

        let interval = now.timeIntervalSinceDate(lastOpened)

        if(interval > weekInSeconds){
            restoreDefaults()
        } else {
            lastOpened = NSDate()
        }
    }
    
    func updateUsageDay(){
        let now = NSDate()
        
        let lastOpenedComponents = NSCalendar.currentCalendar().components([.Day , .Month , .Year], fromDate: lastOpened)
        let lastOpenedYear =  lastOpenedComponents.year
        let lastOpenedMonth = lastOpenedComponents.month
        let lastOpenedDay = lastOpenedComponents.day
        
        let nowComponents = NSCalendar.currentCalendar().components([.Day , .Month , .Year], fromDate: now)
        let nowYear =  nowComponents.year
        let nowMonth = nowComponents.month
        let nowDay = nowComponents.day
        
        if(nowDay != lastOpenedDay || nowMonth != lastOpenedMonth || nowYear != lastOpenedYear){
            usageDay += 1
        }
        
        lastOpened = NSDate()
    }

    func restoreDefaults() {
        lastOpened = defaultValues[lastOpenedKey] as! NSDate
        hasStarted = defaultValues[hasStartedKey] as! Bool
        hasStopped = defaultValues[hasStoppedKey] as! Bool
        hasReset = defaultValues[hasResetKey] as! Bool
		showHistoryHint = defaultValues[showHistoryHintKey] as! Bool
        // hasAskedFeedback not restore to default
        // usageDay not restore to default
    }
 }
