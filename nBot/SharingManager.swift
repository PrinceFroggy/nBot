//
//  SharingManager.swift
//  nBot
//
//  Created by Andrew Solesa on 2019-03-12.
//  Copyright © 2019 KSG. All rights reserved.
//

import Foundation

class SharingManager
{
    var country = ""
    var shoeName = ""
    var shoeSize = ""
    var shoeColor = ""
    var firstName = ""
    var lastName = ""
    var postalCode = ""
    var address = ""
    var municipality = ""
    var province: Int?
    var phone = ""
    var email = ""
    var cardName = ""
    var cardNumber = ""
    var expMonth = ""
    var expYear = ""
    var securityCode = ""
    
    static let sharedInstance = SharingManager()
}
