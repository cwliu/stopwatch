
 import Foundation

 class UserSettings {

    private var defaults = NSUserDefaults.standardUserDefaults()

    private let lastOpenedKey = "lastOpened"
    private let hasStartedKey = "hasStarted"
    private let hasStoppedKey = "hasStopped"
    private let hasResetKey = "hasReset"
	private let showHistoryHintKey = "showHistoryHint"

    private lazy var defaultValues : NSDictionary = [
            self.hasStartedKey : false,
            self.hasStoppedKey : false,
            self.hasResetKey : false,
            self.showHistoryHintKey: false,
            self.lastOpenedKey: NSDate()
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

    init (){
        defaults.registerDefaults(defaultValues as! [String : AnyObject])
        resetIfMoreThanWeekOld()
    }

    func resetIfMoreThanWeekOld () {
        let weekInSeconds = 604800.0 //week in seconds

        let interval = NSDate().timeIntervalSinceDate(lastOpened)

        if(interval > weekInSeconds){
            restoreDefaults()
        } else {
            lastOpened = NSDate()
        }
    }

    func restoreDefaults() {
        lastOpened = defaultValues[lastOpenedKey] as! NSDate
        hasStarted = defaultValues[hasStartedKey] as! Bool
        hasStopped = defaultValues[hasStoppedKey] as! Bool
        hasReset = defaultValues[hasResetKey] as! Bool
		showHistoryHint = defaultValues[showHistoryHintKey] as! Bool
    }
 }