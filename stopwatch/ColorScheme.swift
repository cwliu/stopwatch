//
//  ColorScheme.swift
//  stopwatch
//
//  Created by Alex Eroshin on 8/8/16.
//  Copyright © 2016 Toggl. All rights reserved.
//

import Foundation
import UIKit

struct ColorScheme {
	var statusBarStyle: UIStatusBarStyle
	var backgroundColor: UIColor
	var uiTintColor: UIColor
	var dotColor: UIColor
	var handColor: UIColor
	var timerColor: UIColor
	var pulseColor: UIColor
	var shakerColor: UIColor
}

class ColorSchemes {
	static let dayScheme = ColorScheme(
		statusBarStyle: .Default,
		backgroundColor: UIColor(red: 241/255.0, green: 207/255.0, blue: 99/255.0, alpha: 1.0),
		uiTintColor: .blackColor(),
		dotColor: UIColor(red: 240/255.0, green: 123/255.0, blue: 63/255.0, alpha: 1.0),
		handColor: UIColor(red: 32/255.0, green: 31/255.0, blue: 61/255.0, alpha: 1.0),
		timerColor: UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0),
		pulseColor: UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 0.11),
		shakerColor: UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0)
	
	)
	static let nightScheme = ColorScheme(
		statusBarStyle: .LightContent,
		backgroundColor: UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0),
		uiTintColor: .whiteColor(),
		dotColor: UIColor(red: 255/255.0, green: 212/255.0, blue: 96/255.0, alpha: 1.0),
		handColor: UIColor(red: 240/255.0, green: 123/255.0, blue: 63/255.0, alpha: 1.0),
		timerColor: UIColor(red: 241/255.0, green: 207/255.0, blue: 99/255.0, alpha: 1.0),
		pulseColor: UIColor(red: 255/255.0, green: 212/255.0, blue: 96/255.0, alpha: 0.11),
		shakerColor: UIColor(red: 255/255.0, green: 212/255.0, blue: 96/255.0, alpha: 1.0)
	)
}