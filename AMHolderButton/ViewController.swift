//
//  ViewController.swift
//  AMHolderButton
//
//  Created by Amir Daliri on 12/13/17.
//  Copyright © 2017 Amir Daliri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var holdButton: AMHolderButton!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I'm Here...
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setupButton()
    }
    
    
    func setupButton() {
        
        let center = self.view.center
        
        self.holdButton.slideDuration = 1
        self.holdButton.resetDuration = 0.2
        self.holdButton.holdButtonCompletion = {() -> Void in
            self.showAlert()
        }
        
        let button2 = AMHolderButton(frame: CGRect(x: self.holdButton.frame.origin.x, y: self.holdButton.frame.origin.y + 160 , width: self.holdButton.frame.width, height: self.holdButton.frame.height), slideColor: UIColor.magenta, slideTextColor: UIColor.purple, slideDuration: 1.0)
        button2.setText("Hold me!")
        button2.setTextFont(UIFont(name: "HelveticaNeue-UltraLight", size: 25)!)
        button2.textColor = UIColor.magenta
        button2.borderColor = UIColor.magenta
        button2.holdButtonCompletion = {() -> Void in
            self.showAlert()
        }
        button2.resetDuration = 0.2
        button2.borderWidth = 3.0
        self.view.addSubview(button2)
        
        
        let button3 = AMHolderButton(frame: CGRect(x: center.x - button2.frame.height / 2, y: button2.frame.origin.y + 160 , width: button2.frame.height, height: button2.frame.height), slideColor: UIColor.green, slideTextColor: UIColor.white, slideDuration: 1.0)
        button3.backgroundColor = UIColor.clear
        button3.setText("👍🏻")
        button3.setTextFont(UIFont.boldSystemFont(ofSize: 20))
        button3.textColor = UIColor.green
        button3.holdButtonCompletion = {() -> Void in
            self.showAlert()
        }
        button3.resetDuration = 0.2
        button3.borderWidth = 3.0
        button3.borderColor = UIColor.green
        button3.cornerRadius = button3.frame.width / 2
        self.view.addSubview(button3)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Long press done!", message: "Your long press has completed. Good job!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

