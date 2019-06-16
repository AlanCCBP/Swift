//
//  FeedViewController.swift
//  TinSnapBook
//
//  Created by Alan Nevot on 7/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UIViewController {

    var posts : [Post] = []
    var timer : Timer = Timer()

    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        if self.revealViewController() != nil {

            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(PBRevealViewController.revealLeftView)
        }

        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Tira para recargar los posts")
        self.tableView.refreshControl?.addTarget(self, action: #selector(FeedViewController.requestPosts), for: .valueChanged)

        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(FeedViewController.askForDirectPhotos), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationController?.navigationBar.isHidden = false

        NotificationCenter.default.addObserver(self, selector: #selector(FeedViewController.requestPosts), name: Notification.Name(UsersFactory.notificationName), object: nil)

        _ = UsersFactory.sharedInstance.getUsers()

        self.posts.removeAll()
        self.requestPosts()
    }

    override func viewWillDisappear(_ animated: Bool) {

        NotificationCenter.default.removeObserver(self, name: Notification.Name(UsersFactory.notificationName), object: nil)

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func askForDirectPhotos () {

        let query = PFQuery(className: "DirectImage")

        query.whereKey("idUserReceiver", equalTo: (PFUser.current()?.objectId)!)

        do {
            let images = try query.findObjects()

            if images.count > 0 {

                let image = images.first!
                var receiver : User?

                if let idUserSender = image["idUserReceiver"] as? String {
                    receiver = UsersFactory.sharedInstance.findUser(idUser: idUserSender)
                }

                if let pfFile = image["image"] as? PFFile {
                    pfFile.getDataInBackground(block: { (data, error) in

                        if let imageData = data {

                            self.timer.invalidate()
                            image.deleteInBackground()

                            if let imageToShow = UIImage(data: imageData) {

                                let alertController = UIAlertController(title: "Tienes un nuevo mensaje", message: "Has recibido un mensaje de \(String(describing: receiver?.name))", preferredStyle: .alert)

                                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in

                                    let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))

                                    backgroundImageView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                                    backgroundImageView.alpha = 0.8
                                    backgroundImageView.tag = 29
                                    self.view.addSubview(backgroundImageView)

                                    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))

                                    imageView.image = imageToShow
                                    imageView.contentMode = .scaleAspectFit
                                    imageView.tag = 29

                                    self.view.addSubview(imageView)

                                    _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (timer) in

                                        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(FeedViewController.askForDirectPhotos), userInfo: nil, repeats: true)

                                        for v in self.view.subviews {

                                            if v.tag == 28 {
                                                v.removeFromSuperview()
                                            }
                                        }
                                    })
                                })

                                alertController.addAction(okAction)

                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    })
                }
            }
        } catch {
            print("Ha habido un error al recuperar las imágenes")
        }



    }

    @objc func requestPosts () {

        let query : PFQuery = PFQuery(className: "Post")

        query.whereKey("idUser", notEqualTo: (PFUser.current()?.objectId)!)
        query.order(byDescending: "createdAt")

        query.findObjectsInBackground { (objects, error) in

            if error != nil {
                print(error!.localizedDescription)
            }
            else
            {
                if let objects = objects {

                    for object in objects {

                        let objectID = object.objectId!
                        let creationDate = object.createdAt!
                        let message = object["message"] as! String

                        let postPosition = self.posts.count

                        let post : Post = Post(objectID: objectID, message: message, image: nil, user: nil, creationDate: creationDate)

                        self.posts.append(post)

                        let idUser = object["idUser"] as! String

                        if let user = UsersFactory.sharedInstance.findUser(idUser: idUser) {
                            self.posts[postPosition].user = user
                        }/*
                        else
                        {
                            let userName = (object["name"] as! String).components(separatedBy: "@")[0].capitalized

                            self.posts[postPosition].user = User(objectID: (PFUser.current()?.objectId)!, name: userName, email: (PFUser.current()?.email!)!)
                        }*/

                        let imageFile = object["imageFile"] as! PFFile

                        imageFile.getDataInBackground(block: { (data, error) in

                            if let data = data {

                                let downloadedImage = UIImage(data: data)

                                self.posts[postPosition].image = downloadedImage

                                self.tableView.refreshControl?.endRefreshing()
                                self.tableView.reloadData()
                            }
                        })
                    }
                }
            }
        }
    }
}

extension FeedViewController : UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedTableViewCell
        let post = self.posts[indexPath.row]

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        cell.dateLabel.text = formatter.string(from: post.creationDate)
        cell.contentLabel.text = post.message

        if post.user != nil {
            cell.usernameLabel.text = post.user?.name

            if let image = post.user?.image {
                cell.userImageView.image = image
            }
        }

        //Falta añadir la imagen.

        if post.image != nil {
            cell.postImageView.image = post.image
        }

        return cell
    }

}
