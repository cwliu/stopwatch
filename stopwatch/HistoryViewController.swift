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
	@IBOutlet weak var backButton: UIButton!
	@IBOutlet weak var currentDurationLabel: UILabel!
	@IBOutlet weak var currentDetailsLabel: UILabel!
	@IBOutlet weak var topSeparatorView: UIView!
	@IBOutlet weak var clockFaceContainer: UIView!
	
	var tableViewHeader: UIView?
	
	var clockFace: ClockFace?
	
	var delegate: HistoryDelegate?
	
	var timers: [Timer] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		backButton.setImage(AppDelegate.instance.colorScheme.backButton, forState: .Normal)
		currentDurationLabel.textColor = AppDelegate.instance.colorScheme.textColor
		currentDetailsLabel.textColor = AppDelegate.instance.colorScheme.secondaryTextColor
		topSeparatorView.backgroundColor = AppDelegate.instance.colorScheme.separatorColor
		
		tableViewHeader = tableView.tableHeaderView!
		
		hideCurrentTimerView()
		
		loadData()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if clockFace == nil {
			clockFace = ClockFace(containerSize: clockFaceContainer.frame.size)
			clockFace!.frame = CGRect(x: 0, y: 0, width: clockFaceContainer.frame.width, height: clockFaceContainer.frame.width)
			clockFaceContainer.addSubview(clockFace!)
		}
	}
	
	func hideCurrentTimerView() {
		tableView.tableHeaderView = nil
	}
	
	func showCurrentTimerView() {
		tableView.tableHeaderView = tableViewHeader
	}
	
	func loadData() {
		timers = Datastore.instance.fetchTimers()
		tableView.reloadData()
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return timers.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell") as! HistoryTableViewCell
		let timer = timers[indexPath.row]
		
		cell.backgroundColor = .clearColor()
		cell.durationLabel.textColor = AppDelegate.instance.colorScheme.textColor
		cell.detailsLabel.textColor = AppDelegate.instance.colorScheme.secondaryTextColor
		cell.separatorView.backgroundColor = AppDelegate.instance.colorScheme.separatorColor
		
		
		
		let date = NSDate(timeIntervalSince1970: timer.duration)
		cell.durationLabel.text = NSDateComponentsFormatter.prettyFormattedInterval(timer.duration)
		cell.detailsLabel.text = date.shortFormat()
		
		return cell
	}
	
	@IBAction func showTimer() {
		delegate?.showTimer()
	}
}