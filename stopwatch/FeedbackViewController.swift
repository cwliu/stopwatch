//
//  FeedbackViewController.swift
//  stopwatch
//
//  Created by Cody Liu on 8/17/16.
//  Copyright © 2016 Toggl. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var feedbackMessage: UITextView!
    @IBOutlet var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        feedbackMessage.textColor = UIColor.lightGrayColor()
        feedbackMessage.delegate = self
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonClick(sender: UIButton){
        // TODO
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
