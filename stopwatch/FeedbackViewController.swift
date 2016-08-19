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
    @IBOutlet var cancelButton: UIButton!
    
    var kbHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedbackMessage.textColor = UIColor.lightGrayColor()
        feedbackMessage.font = UIFont(name: feedbackMessage.font!.fontName, size: 16)
        feedbackMessage.delegate = self
        
        sendButton.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
    }

    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)

    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                kbHeight = keyboardSize.height
                self.animateButtons(true)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.animateButtons(false)
    }
    
    func animateButtons(up: Bool){
        let movement = (up ? -kbHeight : kbHeight)
        
        UIView.animateWithDuration(0.3, animations: {
            self.sendButton.transform = CGAffineTransformMakeTranslation( 0.0, movement)
            self.cancelButton.transform = CGAffineTransformMakeTranslation( 0.0, movement)
        })
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
    }

    @IBAction func cancelButtonClick(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
