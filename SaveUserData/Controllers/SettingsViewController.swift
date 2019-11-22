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
        if userDefaults.bool(forKey: "allowTaskDelete") {
            allowTaskDeleteSwitch.isOn = true
        } else {
            allowTaskDeleteSwitch.isOn = false
        }
        
        if userDefaults.bool(forKey: "randomTaskColor") {
            randomTaskColorSwitch.isOn = true
        } else {
            randomTaskColorSwitch.isOn = false
        }
    }

}
