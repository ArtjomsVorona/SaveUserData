//
//  SettingsViewController.swift
//  SaveUserData
//
//  Created by Artjoms Vorona on 22/11/2019.
//  Copyright © 2019 Artjoms Vorona. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var userDefaults = UserDefaults.standard
    
    @IBOutlet weak var allowTaskDeleteSwitch: UISwitch!
    @IBOutlet weak var randomTaskColorSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    
    @IBAction func allowTaskDeleteSwitchTapped(_ sender: UISwitch) {
        userDefaults.set(sender.isOn, forKey: "allowTaskDelete")
    }
    
    @IBAction func randomTaskColorSwitchTapped(_ sender: UISwitch) {
        userDefaults.set(sender.isOn, forKey: "randomTaskColor")
    }


    func updateView() {        
        if let allowDelete = userDefaults.object(forKey: "allowTaskDelete") {
            if allowDelete as! Bool {
                allowTaskDeleteSwitch.isOn = true
            } else {
                allowTaskDeleteSwitch.isOn = false
            }
        }
        
        if let randomColor = userDefaults.object(forKey: "randomTaskColor") {
            if randomColor as! Bool {
                randomTaskColorSwitch.isOn = true
            } else {
                randomTaskColorSwitch.isOn = false
            }
        }
    }

}
