//
//  ViewController.swift
//  RamblerRides
//
//  Created by Tyler Bobella on 11/12/15.
//  Copyright © 2015 LUCCS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var campuses: [UIButton]!
    


    @IBAction func chooseCampus(sender: AnyObject) {
        
        // Not 100% sure if "tag" is the right method here.
        // I would like to pass a keyPath but I believe you need to
        // Make a subclass of the button to allow this. Not sure if
        // That is standard iOS development moves or not. Oh well. 
        switch sender.tag {
        case 1:
            self.performSegueWithIdentifier("lakeshore", sender: self)
        case 2:
            self.performSegueWithIdentifier("watertower", sender: self)
        default:
            break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "lakeshore" {
            segue.destinationViewController as? LakeshoreController
        }
        
        if segue.identifier == "watertower" {
            segue.destinationViewController as? WatertowerController
        }
    }
}

