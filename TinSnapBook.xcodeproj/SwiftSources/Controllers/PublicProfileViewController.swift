//
//  PublicProfileViewController.swift
//  TinSnapBook
//
//  Created by Alan Nevot on 21/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class PublicProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var user : User?
    var posts : [Post] = []
    var activityIndicator : UIActivityIndicatorView!

    @IBOutlet var userImageView: UIImageView!

    @IBOutlet var userNameLabel: UILabel!

    @IBOutlet var birthdayLabel: UILabel!

    @IBOutlet var tableView: UITableView!

    @IBOutlet var friendsButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        if let image = self.user?.image {
            self.userImageView.image = image
        }
        else
        {
            self.userImageView.image = #imageLiteral(resourceName: "no-friend")
        }

        self.userNameLabel.text = self.user?.name

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        if let birthday = self.user?.birthday {
            self.birthdayLabel.text = "Nacido el \(formatter.string(from: birthday))"
        }
        else
        {
            self.birthdayLabel.text = "Fecha de nacimiento desconocida"
        }

        if let gender = self.user?.gender {
            if gender {
                self.friendsButton.setImage(#imageLiteral(resourceName: "friend-female"), for: .normal)
            }
            else
            {
                self.friendsButton.setImage(#imageLiteral(resourceName: "friend-male"), for: .normal)
            }
        }

        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Tira para recargar los posts")
        self.tableView.refreshControl?.addTarget(self, action: #selector(FeedViewController.requestPosts), for: .valueChanged)

        self.requestPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height / 2
        self.userImageView.clipsToBounds = true
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if segue.identifier == "showUserLocation" {

            let destinationVC = segue.destination as! UserMapViewController

            destinationVC.user = self.user

        }
    }

    @objc func requestPosts () {

        let query : PFQuery = PFQuery(className: "Post")

        query.whereKey("idUser", equalTo: (self.user?.objectID)!)
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

                        post.user = self.user
                        self.posts.append(post)

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

    @IBAction func friendsButtonPressed(_ sender: UIButton) {

        self.user?.isFriend = false
        self.friendsButton.setImage(#imageLiteral(resourceName: "no-friend"), for: .normal)

        let query = PFQuery(className: "UserFriends")

        query.whereKey("idUser", equalTo: (PFUser.current()?.objectId)!)
        query.whereKey("idUserFriend", equalTo: (self.user?.objectID)!)

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

    @IBAction func chatButtonPressed(_ sender: UIButton) {
    }

    @IBAction func showLocationPressed(_ sender: UIButton) {
    }

    @IBAction func sendPhotoPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Selecciona una imagen", message: "Desde dónde deseas obtener tu imagen?", preferredStyle: .actionSheet)

        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: { (action) in
            self.loadFromLibrary()
        })

        alertController.addAction(libraryAction)

        let cameraAction = UIAlertAction(title: "Cámara de fotos", style: .default, handler: { (action) in
            self.takePhoto()
        })

        alertController.addAction(cameraAction)

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

    func loadFromLibrary () {

        let imagePicker : UIImagePickerController = UIImagePickerController()

        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false

        self.present(imagePicker, animated: true, completion: nil)
    }

    func takePhoto () {

        let imagePicker : UIImagePickerController = UIImagePickerController()

        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false

        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {

            self.startActivityIndicator()

            let directImage = PFObject(className: "DirectImage")

            directImage["image"] = PFFile(name: "image.jpeg", data: UIImageJPEGRepresentation(image, 0.8)!)
            directImage["idUserSender"] = UsersFactory.sharedInstance.currentUser?.objectID
            directImage["idUserReceiver"] = self.user?.objectID

            let acl = PFACL()

            acl.getPublicReadAccess = true
            acl.getPublicWriteAccess = true

            directImage.acl = acl

            directImage.saveInBackground(block: { (success, error) in

                self.stopActivityIndicator()

                var title = "Envío fallido"
                var message = "Por favor, inténtalo de nuevo más tarde"

                if success {
                    title = "Imagen enviada"
                    message = "Tu imagen se ha enviado correctamente"
                }

                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)

                self.dismiss(animated: true, completion: nil)
            })
        }
    }

    func startActivityIndicator() {

        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()

    }

    func stopActivityIndicator() {

        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()

    }
}

extension PublicProfileViewController : UITableViewDataSource, UITableViewDelegate {

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
