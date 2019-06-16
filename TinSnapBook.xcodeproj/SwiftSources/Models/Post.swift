//
//  Post.swift
//  TinSnapBook
//
//  Created by Alan Nevot on 15/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit

class Post: NSObject {

    var objectID : String!
    var message : String?
    var image : UIImage?
    var user : User?
    var creationDate : Date!

    init (objectID : String, message : String, image : UIImage?, user : User?, creationDate : Date) {

        self.objectID = objectID
        self.message = message
        self.image = image
        self.user = user
        self.creationDate = creationDate
    }
}
