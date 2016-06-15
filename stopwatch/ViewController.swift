//
//  ViewController.swift
//  stopwatch
//
//  Created by Taavi Rehemägi on 14/06/16.
//  Copyright © 2016 Toggl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Properties
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let daycolor = UIColor(red: 241/255.0, green: 207/255.0, blue: 99/255.0, alpha: 1.0)
    let nightColor = UIColor(red: 31/255.0, green: 30/255.0, blue: 69/255.0, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = daycolor
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

