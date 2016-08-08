//
//  MainTabBarController.swift
//  stopwatch
//
//  Created by Alex Eroshin on 8/8/16.
//  Copyright © 2016 Toggl. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
	
	// MARK: Color constants
	let dayBackgroundColor = UIColor(red: 241/255.0, green: 207/255.0, blue: 99/255.0, alpha: 1.0)
	let nightBackgroundColor = UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0)
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		self.view.backgroundColor = AppDelegate.instance.colorMode == .day ? dayBackgroundColor : nightBackgroundColor
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return AppDelegate.instance.colorMode == .day ? .Default : .LightContent
	}
}