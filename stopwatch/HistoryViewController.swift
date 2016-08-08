//
//  HistoryViewController.swift
//  stopwatch
//
//  Created by Alex Eroshin on 8/8/16.
//  Copyright © 2016 Toggl. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView!
	
	var timers: [Timer] = []
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		timers = Datastore.instance.fetchTimers()
		tableView.reloadData()
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return timers.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell")
		let timer = timers[indexPath.row]
		
		cell?.backgroundColor = .clearColor()
		cell?.textLabel?.textColor = AppDelegate.instance.colorScheme.uiTintColor
		cell?.detailTextLabel?.textColor = AppDelegate.instance.colorScheme.uiTintColor
		
		let formatter = NSDateComponentsFormatter()
		formatter.unitsStyle = .Abbreviated
		formatter.allowedUnits = [.Second, .Minute, .Hour]
		
		cell?.textLabel?.text = formatter.stringFromTimeInterval(timer.duration)
		cell?.detailTextLabel?.text = timer.date.defaultFormat()
		
		return cell!
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return AppDelegate.instance.colorScheme.statusBarStyle
	}
}
