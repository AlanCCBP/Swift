//
//  DiscoverViewController.swift
//  TinSnapBook
//
//  Created by Alan Nevot on 12/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class DiscoverViewController: UIViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!

    var users : [User] = []
    var idx = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        if self.revealViewController() != nil {

            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(PBRevealViewController.revealLeftView)
        }

        users = UsersFactory.sharedInstance.getUnknownPeople()

        self.reloadView()

        let gestureRecognizer = UIPanGestureRecognizer()

        gestureRecognizer.addTarget(self, action: #selector(DiscoverViewController.imageDragged(gestureRecognizer:)))
        self.userImageView.isUserInteractionEnabled = true
        self.userImageView.addGestureRecognizer(gestureRecognizer)

    }

    func imageDragged (gestureRecognizer : UIPanGestureRecognizer) {

        let translation = gestureRecognizer.translation(in: self.view)
        let imageView = gestureRecognizer.view
        let rotationAngle = ((imageView?.center.x)! - self.view.bounds.width / 2) / 180.0
        var rotation = CGAffineTransform(rotationAngle: rotationAngle)
        let scaleFactor = min(80/abs(((imageView?.center.x)! - self.view.bounds.width)), 1)
        var scaleAndRotate = rotation.scaledBy(x: scaleFactor, y: scaleFactor)


        imageView?.transform = scaleAndRotate

        imageView?.center = CGPoint(x: (self.view.bounds.width / 2) + translation.x, y: (self.view.bounds.height / 2) + translation.y)

        if gestureRecognizer.state == .ended {
            if (imageView?.center.x)! < CGFloat(100) {
                print("Debemos rechazar al usuario")
            }
            else if (imageView?.center.x)! >= self.view.bounds.width {

                self.users[idx].isFriend = true

                let friendship = PFObject(className: "UserFriends")

                friendship["idUser"] = PFUser.current()?.objectId
                friendship["idUserFriend"] = self.users[idx].objectID

                let acl = PFACL()

                acl.getPublicReadAccess = true
                acl.getPublicWriteAccess = true

                friendship.acl = acl
                friendship.saveInBackground()

                self.users = UsersFactory.sharedInstance.getUnknownPeople()

                self.reloadView()
            }

            rotation = CGAffineTransform(rotationAngle: 0)
            scaleAndRotate = rotation.scaledBy(x: 1, y: 1)
            imageView?.transform = scaleAndRotate

            self.reloadView()
            imageView?.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)

        }
    }

    func reloadView() {

        idx += 1

        if idx >= self.users.count {
            idx = 0
        }

        let user = users[idx]

        if let image = user.image {

            self.userImageView.image = image

        }
        else
        {
            self.userImageView.image = #imageLiteral(resourceName: "no-friend")
        }

        self.userNameLabel.text = user.name
        self.userImageView.image = user.image

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */



}
