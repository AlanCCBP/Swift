//
//  ProfileViewController.swift
//  TinSnapBook
//
//  Created by Alan Nevot on 12/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var genderSwitch: UISwitch!
    @IBOutlet var birthdayLabel: UIButton!

    var user : User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        if self.revealViewController() != nil {

            self.menuButton.target = self.revealViewController()
            self.menuButton.action = #selector(PBRevealViewController.revealLeftView)
        }

        user = UsersFactory.sharedInstance.currentUser!

        self.nameTextField.text = self.user?.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logout(_ sender: UIBarButtonItem) {

        PFUser.logOut()

        performSegue(withIdentifier: "logout", sender: nil)

    }

    @IBAction func pickPhoto(_ sender: UIButton) {
        
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

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.user?.image = image
        }

        self.dismiss(animated: true, completion: nil)
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

    @IBAction func switchChanged(_ sender: UISwitch) {

        self.user?.gender = self.genderSwitch.isOn

        if self.genderSwitch.isOn {
            self.genderLabel.text = "Mujer"
        }
        else
        {
            self.genderLabel.text = "Hombre"
        }
    }

    @IBAction func saveToParse(_ sender: UIButton) {

        let pfUser = PFUser.current()!

        pfUser["nickname"] = self.nameTextField.text
        pfUser["gender"] = self.user?.gender
        pfUser["birthday"] = self.user?.birthday

        let imageData = UIImageJPEGRepresentation(self.userImageView.image!, 0.8)
        let imageFile = PFFile(name: pfUser.username! + ".jpeg", data: imageData!)

        pfUser["imageFile"] = imageFile

        pfUser.saveInBackground { (success, error) in

            if success {

                let alertController = UIAlertController(title: "Usuario actualizado", message: "Tu usuario se ha actualizado correctamente.", preferredStyle: .alert)

                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                alertController.addAction(okAction)

                self.present(alertController, animated: true, completion: nil)
                
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        user = UsersFactory.sharedInstance.currentUser!

        self.nameTextField.text = self.user?.name
        self.nameTextField.delegate = self

        if let image = user?.image {
            self.userImageView.image = image
        }
        else
        {
            self.userImageView.image = #imageLiteral(resourceName: "no-friend")
        }

        if let birthday = self.user?.birthday {

            let formatter = DateFormatter()

            formatter.dateStyle = .short
            formatter.timeStyle = .none

            self.birthdayLabel.setTitle(formatter.string(from: birthday), for: .normal)
        }
        else
        {
            self.birthdayLabel.setTitle("Desconocida", for: .normal)
        }

        if let gender = self.user?.gender {
            if gender {
                self.genderSwitch.isOn = true
                self.genderLabel.text = "Mujer"
            }
            else
            {
                self.genderSwitch.isOn = false
                self.genderLabel.text = "Hombre"
            }
        }
        else
        {
            self.genderLabel.text = "Desconocido"
        }
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

extension ProfileViewController : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true
    }

}
