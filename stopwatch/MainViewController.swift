//
//  MainViewController.swift
//  stopwatch
//
//  Created by Alex Eroshin on 8/8/16.
//  Copyright © 2016 Toggl. All rights reserved.
//

import Foundation
import UIKit

protocol TimerDelegate {
	func timerStarted()
	func timerReset()
	func timerSaved()
	func getSecondaryClockFaces() -> [ClockFace]
	func getSecondaryLabels() -> [UILabel]
	func getPrettySecondaryLabels() -> [UILabel]
	func showHistory()
}

protocol HistoryDelegate {
	func showTimer()
}

class MainViewController: UIViewController, UIScrollViewDelegate {
	
	@IBOutlet weak var scrollView: UIScrollView!
	
	var timerController: TimerViewController?
	
	var historyController: HistoryViewController?
	
    var mainViewLayouted: Bool = false
    
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = AppDelegate.instance.colorScheme.backgroundColor
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
        
        if(!mainViewLayouted){
            mainViewLayouted = true
            
            scrollView.contentSize = CGSize(width: view.frame.width * 2, height: view.frame.height)
            scrollView.delegate = self
		
            historyController = storyboard?.instantiateViewControllerWithIdentifier("HistoryController")
                as? HistoryViewController
            historyController?.delegate = self
            addChildViewController(historyController!)
            historyController?.view.frame.origin.x = view.frame.size.width
            scrollView.addSubview((historyController?.view)!)
            historyController?.didMoveToParentViewController(self)
            
            timerController = storyboard?.instantiateViewControllerWithIdentifier("TimerController")
                as? TimerViewController
            timerController?.delegate = self
            addChildViewController(timerController!)
            scrollView.addSubview((timerController?.view)!)
            timerController?.didMoveToParentViewController(self)
            
            scrollView.scrollEnabled = UserSettings().hasReset
            timerController?.historyButton.hidden = !UserSettings().hasReset
        }
	}
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		if scrollView.contentOffset.x >= scrollView.frame.width * 0.9
				&& timerController?.settings.showHistoryHint == true {
			timerController?.settings.showHistoryHint = false
			timerController?.refreshHistoryHint()
		}
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
}

extension MainViewController: TimerDelegate {
	
	func timerStarted() {
		historyController?.showCurrentTimerView()
	}
	
	func timerReset() {
		scrollView.scrollEnabled = true
		timerController?.refreshHistoryHint()
		historyController?.hideCurrentTimerView()
	}
	
	func timerSaved() {
		historyController?.loadData()
	}
	
	func getSecondaryClockFaces() -> [ClockFace] {
		return [(historyController?.clockFace)!]
	}
	
	func getSecondaryLabels() -> [UILabel] {
		return [(historyController?.currentDetailsLabel)!]
	}
	
	func getPrettySecondaryLabels() -> [UILabel] {
		return [(historyController?.currentDurationLabel)!]
	}
	
	func showHistory() {
		var rect = view.frame
		rect.origin.x = rect.width
		scrollView.scrollRectToVisible(rect, animated: true)
	}
}

extension MainViewController: HistoryDelegate {

	func showTimer() {
		scrollView.scrollRectToVisible(view.frame, animated: true)
	}
	
}