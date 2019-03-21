//
//  settingsViewController.swift
//  nBot
//
//  Created by Andrew Solesa on 2019-03-12.
//  Copyright © 2019 KSG. All rights reserved.
//

import Cocoa

class settingsViewController: NSViewController
{
    @IBOutlet weak var countryComboBox: NSComboBox!
    @IBOutlet weak var shoeNameTextField: NSTextField!
    @IBOutlet weak var shoeSizeComboBox: NSComboBox!
    @IBOutlet weak var shoeColorTextField: NSTextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func closeButtonPressed(_ sender: NSButton)
    {
        SharingManager.sharedInstance.country = countryComboBox.stringValue
        SharingManager.sharedInstance.shoeName = shoeNameTextField.stringValue
        SharingManager.sharedInstance.shoeSize = shoeSizeComboBox.stringValue
        SharingManager.sharedInstance.shoeColor = shoeColorTextField.stringValue
        
        self.dismiss(self)
    }
}
