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
    @IBOutlet weak var firstNameTextField: NSTextField!
    @IBOutlet weak var lastNameTextField: NSTextField!
    @IBOutlet weak var postalCodeTextField: NSTextField!
    @IBOutlet weak var addressTextField: NSTextField!
    @IBOutlet weak var municipalityTextField: NSTextField!
    @IBOutlet weak var provinceComboBox: NSComboBox!
    @IBOutlet weak var phoneTextField: NSTextField!
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var cardNameTextField: NSTextField!
    @IBOutlet weak var cardNumberTextField: NSTextField!
    @IBOutlet weak var expMonthTextField: NSTextField!
    @IBOutlet weak var expYearTextField: NSTextField!
    @IBOutlet weak var securityCodeTextField: NSTextField!
    
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
        SharingManager.sharedInstance.firstName = firstNameTextField.stringValue
        SharingManager.sharedInstance.lastName = lastNameTextField.stringValue
        SharingManager.sharedInstance.postalCode = postalCodeTextField.stringValue
        SharingManager.sharedInstance.address = addressTextField.stringValue
        SharingManager.sharedInstance.municipality = municipalityTextField.stringValue
        
        switch provinceComboBox.stringValue
        {
        case "Ontario":
            SharingManager.sharedInstance.province = 0
        case "British Columbia":
            SharingManager.sharedInstance.province = 1
        case "Manitoba":
            SharingManager.sharedInstance.province = 2
        case "Alberta":
            SharingManager.sharedInstance.province = 3
        case "New Brunswick":
            SharingManager.sharedInstance.province = 4
        case "Newfoundland and Labrador":
            SharingManager.sharedInstance.province = 5
        case "Northwest Territories":
            SharingManager.sharedInstance.province = 6
        case "Nova Scotia":
            SharingManager.sharedInstance.province = 7
        case "Nunavut":
            SharingManager.sharedInstance.province = 8
        case "Prince Edward Island":
            SharingManager.sharedInstance.province = 9
        case "Quebec":
            SharingManager.sharedInstance.province = 10
        case "Saskatchewan":
            SharingManager.sharedInstance.province = 11
        case "Yukon":
            SharingManager.sharedInstance.province = 12
        default:
            SharingManager.sharedInstance.province = 666
        }

        SharingManager.sharedInstance.phone = phoneTextField.stringValue
        SharingManager.sharedInstance.email = emailTextField.stringValue
        SharingManager.sharedInstance.cardName = cardNameTextField.stringValue
        SharingManager.sharedInstance.cardNumber = cardNumberTextField.stringValue
        SharingManager.sharedInstance.expMonth = expMonthTextField.stringValue
        SharingManager.sharedInstance.expYear = expYearTextField.stringValue
        SharingManager.sharedInstance.securityCode = securityCodeTextField.stringValue
        
        self.dismiss(self)
    }
}
