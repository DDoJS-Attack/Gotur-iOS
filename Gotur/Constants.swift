//
//  Constants.swift
//  Gotur
//
//  Created by ismail on 17/02/2018.
//  Copyright © 2018 DDosJS-Attack. All rights reserved.
//

import Foundation
import UIKit

// Hard coded user id
let UID = "5a884c04947e116eed78b2f7"

// Hard coded courier id
let CID = "5a88606e59efcb2d3f60fef6"

// Fonts
let primaryFont = UIFont.systemFont(ofSize: 15)
let primaryBigFont = UIFont.systemFont(ofSize: 24)

// Colors
let primaryColor = UIColor(red: 0.00, green: 0.54, blue: 0.48, alpha: 1.0);
let primaryLightColor = UIColor(red: 0.31, green: 0.73, blue: 0.67, alpha: 1.0);
let primaryDarkColor = UIColor(red: 0.00, green: 0.36, blue: 0.31, alpha: 1.0);
let primaryTextColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0);

// LocalizedStrings
let signInUser = NSLocalizedString("Sign in as user", comment: "")
let signInCourier = NSLocalizedString("Sign in as courier", comment: "")
let doYouWantToDeliverThisPacket = NSLocalizedString("Do you want to deliver this packet?", comment: "")
let yesString = NSLocalizedString("Yes", comment: "")
let noString = NSLocalizedString("No", comment: "")
let clickToEnterSourceAddress = NSLocalizedString("Click to enter source address", comment: "")
let clickToEnterDestinationAddress = NSLocalizedString("Click to enter destination address", comment: "")
let enterWeightOfItem = NSLocalizedString("Enter the weight of the item", comment: "")
let enterPriceOfItem = NSLocalizedString("Enter the price of the item", comment: "")
let enterNameOfItem = NSLocalizedString("Enter the name of the item", comment: "")
let saveString = NSLocalizedString("Save", comment: "")
let myLocationString = NSLocalizedString("My Location", comment: "") // Not used
let cancelString = NSLocalizedString("Cancel", comment: "")
let okString = NSLocalizedString("Ok", comment: "")
let errorSourceAddress = NSLocalizedString("Source address must be initialized", comment: "")
let errorDestinationAddress = NSLocalizedString("Destination address must be initialized", comment: "")
let errorEmptyWeight = NSLocalizedString("Please enter the weight", comment: "")
let errorEmptyPrice = NSLocalizedString("Please enter the price", comment: "")
let errorIncorrectWeight = NSLocalizedString("Please enter the weight correctly", comment: "")
let errorIncorrectPrice = NSLocalizedString("Please enter the price correctly", comment: "")
let myPackagesButtonTitle = NSLocalizedString("My Packages", comment: "")
let errorEmptyName = NSLocalizedString("Please enter the name", comment: "")
let errorCharacterCount3To24 = NSLocalizedString("Characters must be between 3 and 24", comment: "")
