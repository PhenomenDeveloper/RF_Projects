//
//  ViewController.swift
//  Keychain
//
//  Created by KOLESNIKOV Lev on 26/11/2019.
//  Copyright © 2019 SwiftOverflow. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class ViewController: UIViewController {
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveSuccessful: Bool = KeychainWrapper.standard.set("Complete Task", forKey: "successfulTask")
        
        let retrievedString: String? = KeychainWrapper.standard.string(forKey: "successfulTask")
        
        testLabel.text = retrievedString
        
        print(retrievedString)
        // Do any additional setup after loading the view.
    }


}

