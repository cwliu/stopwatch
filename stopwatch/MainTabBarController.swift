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
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		self.view.backgroundColor = AppDelegate.instance.colorScheme.backgroundColor
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return AppDelegate.instance.colorScheme.statusBarStyle
	}
}