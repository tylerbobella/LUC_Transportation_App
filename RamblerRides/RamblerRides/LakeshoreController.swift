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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cta.getTrain("lakeshore") { response, error in
            print(response)
        }
    }
    
}
