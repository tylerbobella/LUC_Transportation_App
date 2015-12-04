//
//  WatertowerController.swift
//  RamblerRides
//
//  Created by Tyler Bobella on 11/12/15.
//  Copyright © 2015 LUCCS. All rights reserved.
//

import UIKit

class WatertowerController: UIViewController {

        let cta = CTA()
    
    var timer = NSTimer() //make a timer variable, but do do anything yet
    let timeInterval:NSTimeInterval = 0.01
    let timerEnd:NSTimeInterval = 10.0
    var timeCount:NSTimeInterval = 10.0
    
    @IBOutlet weak var WTCBusTime: UILabel!
    @IBOutlet weak var countingDown: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cta.getTrain("watertower") { response, error in
            print(response)
        }
        startTimer()
    }
    
    func startTimer() {
        if !timer.valid{ //prevent more than one timer on the thread
            WTCBusTime.text = timeString(timeCount)
            timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval,
                target: self,
                selector: "timerDidEnd:",
                userInfo: nil,
                repeats: true) //repeating timer in the second iteration
        }
    }
    
    @IBAction func countingDown(sender: UISwitch) {
        if !timer.valid{
            resetTimeCount()
    }
    }

    func stopTimer() {
        //timerLabel.text = "Timer Stopped"
        timer.invalidate()
    }
    
   func resetTimer() {
        timer.invalidate()
        resetTimeCount()
        WTCBusTime.text = timeString(timeCount)
    }
    
    func resetTimeCount(){
        if countingDown.on{
            timeCount = timerEnd
           startTimer()
        } else {
            timeCount = 0.0
        }
    }
    
    func timeString(time:NSTimeInterval) -> String {
        let minutes = Int(time) / 60
        //let seconds = Int(time) % 60
        let seconds = time - Double(minutes) * 60
        let secondsFraction = seconds - Double(Int(seconds))
        return String(format:"%02i:%02i.%01i",minutes,Int(seconds),Int(secondsFraction * 10.0))
    }
    
    func timerDidEnd(timer:NSTimer){
        if countingDown.on{
            //timer that counts down
            timeCount = timeCount - timeInterval
            if timeCount <= 0 {  //test for target time reached.
                WTCBusTime.text = "Bus Arrived"
                resetTimeCount()
                 countingDown.setOn(false, animated:true)
            } else { //update the time on the clock if not reached
                WTCBusTime.text = "Bus Arriving in: " + timeString(timeCount)
            }
            
        } else {
            timeCount = timeCount - timeInterval
            if timeCount <= 0{  //test for target time reached.
                WTCBusTime.text = "Bus Leaving"
                countingDown.setOn(true, animated:true)
                resetTimeCount()
            } else { //update the time on the clock if not reached
                WTCBusTime.text = "Bus Leaving in: " + timeString(timeCount)
            }
        }
    }
}




