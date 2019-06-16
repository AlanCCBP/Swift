//
//  UsersFactory.swift
//  TinSnapBook
//
//  Created by Alan Nevot on 16/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import MapKit

class UsersFactory: NSObject {

    static let sharedInstance = UsersFactory()
    static let notificationName = "UsersLoaded"

    var users : [User] = []
    var currentUser : User?

    override init() {
        super.init()
        loadUsers()
        self.loadMainUser()
    }

    func loadMainUser () {

        let user = PFUser.current()!

        let objectID = user.objectId
        let defaultUserName = user.username?.components(separatedBy: "@")[0].capitalized
        let customUserName = user["nickname"] as? String
        let email = user.email

        if let imageFile = user["imageFile"] as? PFFile {
            imageFile.getDataInBackground { (data, error) in
                if let data = data {
                    self.currentUser?.image = UIImage(data: data)
                }
            }
        }

        PFGeoPoint.geoPointForCurrentLocation { (geoPoint, error) in

            if let point = geoPoint {
                self.currentUser?.location = CLLocationCoordinate2DMake(point.latitude, point.longitude)
                PFUser.current()?["geopoint"] = point
                PFUser.current()?.saveInBackground()
            }
        }

        self.currentUser = User(objectID: objectID!, name: ((customUserName == nil) ? defaultUserName : customUserName)!, email: email!)

        if let gender = user["gender"] as? Bool {
            self.currentUser!.gender = gender
        }

        if let birthday = user["birthday"] as? Date {
            self.currentUser!.birthday = birthday
        }
    }

    func getUsers () -> [User] {

        self.loadUsers()
        self.loadMainUser()
        return self.users

    }

    func getFriends () -> [User] {

        var friends : [User] = []

        for user in self.users {

            if user.isFriend {
                friends.append(user)
            }
        }

        return friends
    }

    func getUnknownPeople () -> [User] {

        var noFriends : [User] = []

        for user in self.users {

            if !user.isFriend {
                noFriends.append(user)
            }
        }

        return noFriends
    }

    func loadUsers () {
        let query = PFUser.query()

        query?.whereKey("objectId", notEqualTo: (PFUser.current()?.objectId)!)

        let geopoint : PFGeoPoint = PFUser.current()?["geoPoint"] as! PFGeoPoint

        query?.whereKey("geoPoint", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: geopoint.latitude - 1, longitude: geopoint.longitude - 1), toNortheast: PFGeoPoint(latitude: geopoint.latitude + 1, longitude: geopoint.longitude + 1))

        query?.findObjectsInBackground(block: { (objects, error) in

            if error != nil {
                print(error!.localizedDescription)
            }
            else
            {
                self.users.removeAll()

                for object in objects! {

                    if let user = object as? PFUser {

                        let email = user.email
                        let defaultUserName = user.username?.components(separatedBy: "@")[0].capitalized
                        let customUserName = user["nickname"] as? String
                        let objectID = user.objectId
                        let myUser = User(objectID: objectID!, name: ((customUserName != nil) ? customUserName : defaultUserName)!, email: email!)

                        if let geopoint = user["geoPoint"] as? PFGeoPoint {
                            let location = CLLocationCoordinate2DMake(geopoint.latitude, geopoint.longitude)
                            myUser.location = location
                        }

                        if let gender = user["gender"] as? Bool {
                            myUser.gender = gender
                        }

                        if let birthday = user["birthday"] as? Date {
                            myUser.birthday = birthday
                        }

                        if let imageFile = user["imageFile"] as? PFFile {
                            imageFile.getDataInBackground { (data, error) in
                                if let data = data {
                                    myUser.image = UIImage(data: data)
                                }
                            }
                        }

                        let query = PFQuery(className: "UserFriends")

                        query.whereKey("idUser", equalTo: (PFUser.current()?.objectId)!)
                        query.whereKey("idUserFriend", equalTo: myUser.objectID)

                        query.findObjectsInBackground(block: { (object, error) in

                            if error != nil {
                                print(error!.localizedDescription)
                            }
                            else
                            {
                                if let objects = objects {

                                    if objects.count > 0 {
                                        myUser.isFriend = true
                                    }
                                }
                            }
                        })
                    }
                }

                NotificationCenter.default.post(name: Notification.Name(UsersFactory.notificationName), object: nil)
            }
        })
    }

    func findUser (idUser : String) -> User? {

        for user in self.users {

            if idUser == user.objectID {

                return user

            }
        }
        return nil
    }

    func findUserAt (index : Int) -> User? {

        if index >= 0 && index < self.users.count {

            return self.users[index]
        }

        return nil
    }
}
