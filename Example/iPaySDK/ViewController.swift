//
//  ViewController.swift
//  iPaySDK
//
//  Created by Tasnim Alam Shovon on 11/04/2018.
//  Copyright (c) 2018 Tasnim Alam Shovon. All rights reserved.
//

import UIKit
import iPaySDK

class ViewController: UIViewController, iPaySDKDelegate {
    func oauthDidSuccess() {
        DispatchQueue.main.async {
            self.tokenLabel.text = "oAuth was successful"
            self.connectButton.setTitle("Linked with iPay", for: .normal)
            self.connectButton.backgroundColor = UIColor.green
            self.connectButton.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    func oauthDidFail() {
        DispatchQueue.main.async {
            self.connectButton.setTitle("Link with iPay", for: .normal)
            self.connectButton.backgroundColor = UIColor.red
            self.connectButton.setTitleColor(UIColor.black, for: .normal)
            self.tokenLabel.text = "oAuth Failed"
        }
    }
    
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var tokenLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        iPaySDK.shared.environment = .Development
        iPaySDK.shared.configure(withClientId: "xyz")
        iPaySDK.shared.delegate = self
    }
    

    @IBAction func connectTapped(_ sender: UIButton) {
        iPaySDK.shared.userInitiateSession()
    }
    
}

