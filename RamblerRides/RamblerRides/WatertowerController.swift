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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cta.getTrain("watertower") { response, error in
            print(response)
        }
    }

}
