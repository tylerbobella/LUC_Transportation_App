//
//  LakeshoreController.swift
//  RamblerRides
//
//  Created by Tyler Bobella on 11/12/15.
//  Copyright © 2015 LUCCS. All rights reserved.
//

import UIKit

class LakeshoreController: UIViewController {
    
    let cta = CTA()
    
    var timer = NSTimer()
    let timeInterval:NSTimeInterval = 0.01
    let timerEnd:NSTimeInterval = 0.01
    var currentDate = NSDate()
    var timeCount:NSTimeInterval = 5.0
    let scenario0: NSTimeInterval = 900
    let scenario1: NSTimeInterval = 1200
    let scenario2: NSTimeInterval = 2100
    let scenario3: NSTimeInterval = 3000
    let scenario4: NSTimeInterval = 3300
    let scenario5: NSTimeInterval = 3600
    var lscInbound = [String : String]()
    var lscOutbound = [String : String]()
    
    @IBOutlet weak var LSCBusTime: UILabel!
    @IBOutlet weak var countingDown: UISwitch!
    @IBOutlet weak var LSCOutbound: UILabel!
    @IBOutlet weak var LSCInbound: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cta.getTrain("lakeshore") { response, error in
            if let inbound = response?.valueForKey("InboundTrain") {
                for (k, v) in (inbound as? [String : AnyObject])! {
                    self.lscInbound[k] = v as? String
                }
            }
            
            if let outbound = response?.valueForKey("OutboundTrain") {
                for (k, v) in (outbound as? [String : AnyObject])! {
                    self.lscOutbound[k] = v as? String
                }
            }
            
            self.LSCInbound.text = "To 95th: " + self.timeConvert (self.arrivalTime(self.lscInbound))
            self.LSCOutbound.text = "To Howard: " + self.timeConvert (self.arrivalTime(self.lscOutbound))
            self.changeTime()
            self.startTimer()
        }
        
    }
    
    func timeConvert(milTime: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.dateFromString(milTime)
        dateFormatter.dateFormat = "h:mm a"
        let stanDate = dateFormatter.stringFromDate(date!)
        return stanDate
    }
    
    func arrivalTime(dictValue: [String: String]) -> String {
        if let arrival = dictValue["prdt"] {
            let endIdx = arrival.endIndex.advancedBy(-8)
            return arrival.substringFromIndex(endIdx)
        }
        return ""
    }
    
    func startTimer() {
        if !timer.valid{ //prevent more than one timer on the thread
            LSCBusTime.text = timeString(timeCount)
            timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval,
                target: self,
                selector: "timerDidEnd:",
                userInfo: nil,
                repeats: true) //repeating timer in the second iteration
        }
    }
    
    @IBAction func countingDown(sender: UISwitch) {
        if !timer.valid {
            resetTimeCount()
        }
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func changeTime() {
        if timerScenario() == 0 {
            timeCount = scenario0 - Double(currentDate.minute()*60) - Double(currentDate.second())
        }
        if timerScenario() == 1 {
            timeCount = scenario1 - Double(currentDate.minute()*60) - Double(currentDate.second())
        }
        if timerScenario() == 2 {
            timeCount = scenario2 - Double(currentDate.minute()*60) - Double(currentDate.second())
        }
        if timerScenario() == 3 {
            timeCount = scenario3 - Double(currentDate.minute()*60) - Double(currentDate.second())
        }
        if timerScenario() == 4 {
            timeCount = scenario4 - Double(currentDate.minute()*60) - Double(currentDate.second())
        }
        if timerScenario() == 5 {
            timeCount = scenario5 - Double(currentDate.minute()*60) - Double(currentDate.second())
        }
    }
    
    func resetTimeCount(){
        currentDate = NSDate()
        stopTimer()
        timerScenario()
        changeTime()
        startTimer()
    }
    
    func timeString(time:NSTimeInterval) -> String {
        let minutes = Int(time) / 60
        //let seconds = Int(time) % 60
        let seconds = time - Double(minutes) * 60
        let secondsFraction = seconds - Double(Int(seconds))
        return String(format:"%02i:%02i.%01i",minutes,Int(seconds),Int(secondsFraction * 10.0))
    }
    
    // THIS SECTION IS THE TESTS TO SEE WHAT COUNTDOWN TIMER TO USE //
    
    func timerScenario() -> Int{
        if currentDate.hour() < 7 && currentDate.hour() > 1 {
            return 6
        }
        else if currentDate.minute() > 0 && currentDate.minute() <= 15  {
            return 0
        }
        else if currentDate.minute() > 15 && currentDate.minute() <= 20  {
            return 1
        }
        else if currentDate.minute() > 20 && currentDate.minute() <= 35  {
            return 2
        }
        else if currentDate.minute() > 35 && currentDate.minute() <= 40  {
            return 3
        }
        else if currentDate.minute() > 40 && currentDate.minute() <= 55  {
            return 4
        }
        else if currentDate.minute() > 55 && currentDate.minute() <= 60  {
            return 5
        }
        return 7
    }
    
    ///////////////////////////////////////////
    /* This is what happens when each scenario is activated */
    
    func timerDidEnd(timer:NSTimer){
        if timerScenario() == 6 {
            LSCBusTime.text = "The Bus doesn't run now"
        }
        else if timerScenario() == 0 {
            timeCount = timeCount - timeInterval
            if timeCount <= 0 {  //test for target time reached.
                LSCBusTime.text = "Bus Arriving"
                countingDown.setOn(false, animated:true)
                resetTimeCount()
            } else { //update the time on the clock if not reached
                LSCBusTime.text = "Bus Arriving in: " + timeString(timeCount)
            }
        }
        else if timerScenario() == 1 {
            timeCount = timeCount - timeInterval
            if timeCount <= 0{  //test for target time reached.
                LSCBusTime.text = "Bus Leaving"
                resetTimeCount()
            } else { //update the time on the clock if not reached
                LSCBusTime.text = "Bus Leaving in: " + timeString(timeCount)
            }
        }
        else if timerScenario() == 2 {
            timeCount = timeCount - timeInterval
            if timeCount <= 0{  //test for target time reached.
                LSCBusTime.text = "Bus Arriving"
                countingDown.setOn(false, animated:true)
                resetTimeCount()
            } else { //update the time on the clock if not reached
                LSCBusTime.text = "Bus Arriving in: " + timeString(timeCount)
            }
        }
        else if timerScenario() == 3 {
            timeCount = timeCount - timeInterval
            if timeCount <= 0{  //test for target time reached.
                LSCBusTime.text = "Bus Leaving"
                countingDown.setOn(true, animated:true)
                resetTimeCount()
            } else { //update the time on the clock if not reached
                LSCBusTime.text = "Bus Arriving in: " + timeString(timeCount)
            }
        }
        else if timerScenario() == 4 {
            timeCount = timeCount - timeInterval
            if timeCount <= 0{  //test for target time reached.
                LSCBusTime.text = "Bus Arriving"
                countingDown.setOn(false, animated:true)
                resetTimeCount()
            } else { //update the time on the clock if not reached
                LSCBusTime.text = "Bus Arriving in: " + timeString(timeCount)
            }
        }
        else if timerScenario() == 5 {
            timeCount = timeCount - timeInterval
            if timeCount <= 0{  //test for target time reached.
                LSCBusTime.text = "Bus Leaving"
                countingDown.setOn(true, animated:true)
                timerScenario() == 6
                resetTimeCount()
            } else { //update the time on the clock if not reached
                LSCBusTime.text = "Bus Leaving in: " + timeString(timeCount)
            }
        }
    }
}




