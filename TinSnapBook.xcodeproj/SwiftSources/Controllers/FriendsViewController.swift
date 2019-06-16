//
//  FriendsViewController.swift
//  TinSnapBook
//
//  Created by Alan Nevot on 12/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class FriendsViewController: UITableViewController {

    @IBOutlet var menuButton: UIBarButtonItem!

    var users : [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        if self.revealViewController() != nil {

            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(PBRevealViewController.revealLeftView)
        }

        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Tira para recargar los amigos")
        self.refreshControl?.addTarget(self, action: #selector(FriendsViewController.loadUsers), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.loadUsers()
    }

    @objc func loadUsers () {
        self.users = UsersFactory.sharedInstance.getFriends()
        self.refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.

        if segue.identifier == "showDetail" {

            let destinationVC = segue.destination as! PublicProfileViewController

            destinationVC.user = self.users[(self.tableView.indexPathForSelectedRow?.row)!]

        }        
     }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! UserTableViewCell

        let user = self.users[indexPath.row]

        cell.username.text = user.name

        if let image = user.image {
            cell.userImageView.image = image
        }

        cell.userImageView.layer.cornerRadius = 30
        cell.userImageView.clipsToBounds = true

        cell.textLabel?.text = self.users[indexPath.row].name

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = self.tableView.cellForRow(at: indexPath)

        if self.users[indexPath.row].isFriend {

            cell?.accessoryType = .none

            self.users[indexPath.row].isFriend = false

            let query = PFQuery(className: "UserFriends")

            query.whereKey("idUser", equalTo: (PFUser.current()?.objectId)!)
            query.whereKey("idUserFriend", equalTo: self.users[indexPath.row].objectID)

            query.findObjectsInBackground(block: { (objects, error) in

                if error != nil {
                    print(error!.localizedDescription)
                }
                else
                {
                    if let objects = objects {

                        for object in objects {
                            object.deleteInBackground()
                        }
                    }
                }
            })
        }
        else
        {
            self.users[indexPath.row].isFriend = true

            let friendship = PFObject(className: "UserFriends")

            friendship["idUser"] = PFUser.current()?.objectId
            friendship["idUserFriend"] = self.users[indexPath.row].objectID

            let acl = PFACL()

            acl.getPublicReadAccess = true
            acl.getPublicWriteAccess = true

            friendship.acl = acl
            friendship.saveInBackground()
        }
    }
}
