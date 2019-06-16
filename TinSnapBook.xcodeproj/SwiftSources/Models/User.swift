//
//  User.swift
//  TinSnapBook
//
//  Created by Alan Nevot on 12/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import CoreLocation

class User: NSObject {

    var objectID : String!
    var name : String!
    var email : String!
    var isFriend : Bool!
    var birthday : Date?
    var gender : Bool?
    var image : UIImage?
    var location : CLLocationCoordinate2D?

    init(objectID : String, name : String, email : String) {

        self.objectID = objectID
        self.name = name
        self.email = email

    }
}
