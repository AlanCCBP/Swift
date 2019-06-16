//
//  PostViewController.swift
//  TinSnapBook
//
//  Created by Alan Nevot on 14/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var textView: UITextView!
    @IBOutlet var imageView: UIImageView!

    var activityIndicator : UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.textView.delegate = self
        self.hideKeyboardWhenTappingAround()
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
    @IBAction func uploadImage(_ sender: UIButton) {

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

            self.imageView.image = image
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

    @IBAction func publish(_ sender: UIButton) {

        self.startActivityIndicator()

        let post = PFObject(className: "Post")

        post["idUser"] = PFUser.current()?.objectId
        post["message"] = self.textView.text

        let imageData = UIImageJPEGRepresentation(self.imageView.image!, 0.8)
        let imageFile = PFFile(name: "image.jpg", data: imageData!)
        post["image"] = imageFile

        post.saveInBackground { (success, error) in

            self.stopActivityIndicator()

            if error != nil {
                self.sendAlert(title: "No se ha podido guardar la imagen.", message: "Error: \(error!.localizedDescription).")
            }
            else
            {
                self.textView.text = ""
                self.imageView.image = #imageLiteral(resourceName: "send-photo")
                self.sendAlert(title: "Imagen publicada.", message: "El post se ha publicado con éxito.")
            }
        }
    }

    func sendAlert (title : String, message : String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
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

extension PostViewController : UITextViewDelegate {

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {

        textView.resignFirstResponder()

        return true
    }
}

extension PostViewController {

    func hideKeyboardWhenTappingAround () {

        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostViewController.dismissKeyboard))

        self.view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard () {

        self.view.endEditing(true)
    }

}
