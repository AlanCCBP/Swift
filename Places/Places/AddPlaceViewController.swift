//
//  AddPlaceViewController.swift
//  Places
//
//  Created by Alan Nevot on 27/8/17.
//  Copyright © 2017 Alan Nevot. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class AddPlaceViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var imageView: UIImageView!

    @IBOutlet var textFieldName: UITextField!

    @IBOutlet var textFieldType: UITextField!

    @IBOutlet var textFieldAddress: UITextField!

    @IBOutlet var textFieldPhone: UITextField!

    @IBOutlet var textFieldWeb: UITextField!

    @IBOutlet var buttonDislike: UIButton!

    @IBOutlet var buttonLike: UIButton!

    @IBOutlet var buttonGreat: UIButton!

    var place : Place?
    var rating : String?

    let defaultColor : UIColor = UIColor(red: 236.0/255.0, green: 134.0/255.0, blue: 144.0/255.0, alpha: 1.0)
    let selectedColor : UIColor = UIColor.red

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        self.textFieldName.delegate = self
        self.textFieldType.delegate = self
        self.textFieldAddress.delegate = self
        self.textFieldPhone.delegate = self
        self.textFieldWeb.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0 {

            // Hay que gestionar la selección de la imagen del lugar.

            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){

                let imagePicker = UIImagePickerController()

                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self

                self.present(imagePicker, animated: true, completion: nil)

            }
        }

        tableView.deselectRow(at: indexPath, animated: true)

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        self.imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true

        let leadingConstraint = NSLayoutConstraint(item: self.imageView, attribute: .leading, relatedBy: .equal, toItem: self.imageView.superview, attribute: .leading, multiplier: 1, constant: 0)

        leadingConstraint.isActive = true

        let trailingConstraint = NSLayoutConstraint(item: self.imageView, attribute: .trailing, relatedBy: .equal, toItem: self.imageView.superview, attribute: .trailing, multiplier: 1, constant: 0)

        trailingConstraint.isActive = true

        let topConstraint = NSLayoutConstraint(item: self.imageView, attribute: .top, relatedBy: .equal, toItem: self.imageView.superview, attribute: .top, multiplier: 1, constant: 0)

        topConstraint.isActive = true

        let bottomConstraint = NSLayoutConstraint(item: self.imageView, attribute: .bottom, relatedBy: .equal, toItem: self.imageView.superview, attribute: .bottom, multiplier: 1, constant: 0)

        bottomConstraint.isActive = true

        dismiss(animated: true, completion: nil)

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true

    }

    @IBAction func savePressed(_ sender: UIBarButtonItem) {

        if let name = self.textFieldName.text,
            let type = self.textFieldType.text,
            let address = self.textFieldAddress.text,
            let phone = self.textFieldPhone.text,
            let web = self.textFieldWeb.text,
            let theImage = self.imageView.image,
            let rating = self.rating {

            if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer {

                let context = container.viewContext

                self.place = NSEntityDescription.insertNewObject(forEntityName: "Place", into: context) as? Place

                self.place?.name = name
                self.place?.type = type
                self.place?.location = address
                self.place?.telephone = phone
                self.place?.website = web
                self.place?.rating = rating

                self.place?.image = UIImagePNGRepresentation(theImage)! as NSData

                self.savePlaceToICloud(place: self.place!)

                do {
                    try context.save()
                } catch {
                    print("Ha habido un error al guardar el lugar en CoreData.")
                }
            }

            self.performSegue(withIdentifier: "unwindToMainViewController", sender: self)
        }
        else
        {
            let alertController = UIAlertController(title: "Falta algún dato", message: "Revisa que lo tengas todo configurado...", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

            alertController.addAction(okAction)

            self.present(alertController, animated: true, completion: nil)

        }
    }

    func savePlaceToICloud ( place : Place!) {

        let record = CKRecord(recordType: "Place")

        record.setValue(place.name, forKey: "name")
        record.setValue(place.type, forKey: "type")
        record.setValue(place.location, forKey: "location")
        record.setValue(place.telephone, forKey: "telephone")
        record.setValue(place.website, forKey: "website")

        let originalImage = UIImage(data: place.image! as Data)
        let scaleFactor = Int((originalImage?.size.width)!) > 1024 ? 1024/(originalImage?.size.width)! : 1.0
        let scaledImage = UIImage(data: place.image! as Data, scale: scaleFactor)
        //let imageFilePath = NSTemporaryDirectory() + place.name

        do {

            let imagePath : URL = self.getDocumentsDirectory().appendingPathComponent(place.name)

            if let imageJPEG = UIImageJPEGRepresentation(scaledImage!, 0.8) {

                try imageJPEG.write(to: imagePath, options: [.atomicWrite])

            }

            //try UIImageJPEGRepresentation(scaledImage!, 0.8)?.write(to: URL(string: imageFilePath)!, options: [.atomicWrite])

            let imageAsset = CKAsset(fileURL: imagePath)

            record.setValue(imageAsset, forKey: "image")

            let publicDatabase = CKContainer.default().publicCloudDatabase

            publicDatabase.save(record) { (record, error) in

                if error != nil {
                    print(error!.localizedDescription)
                }

                do {

                    try FileManager.default.removeItem(at: imagePath)

                } catch {
                    print(error.localizedDescription)
                }
            }

        } catch {
            print("Error al guardar la imagen en iCloud.")
        }
    }

    func getDocumentsDirectory () -> URL {

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]

        return documentsDirectory

    }

    @IBAction func ratingPressed(_ sender: UIButton) {

        switch sender.tag {
        case 1:
            //Dislike
            self.rating = "Dislike"
            self.buttonDislike.backgroundColor = selectedColor
            self.buttonLike.backgroundColor = defaultColor
            self.buttonGreat.backgroundColor = defaultColor

        case 2:
            //Good
            self.rating = "Good"
            self.buttonDislike.backgroundColor = defaultColor
            self.buttonLike.backgroundColor = selectedColor
            self.buttonGreat.backgroundColor = defaultColor

        case 3:
            //Great
            self.rating = "Great"
            self.buttonDislike.backgroundColor = defaultColor
            self.buttonLike.backgroundColor = defaultColor
            self.buttonGreat.backgroundColor = selectedColor

        default:
            break
        }
    }

    // MARK: - Table view data source

    /*
     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }

     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete implementation, return the number of rows
     return 0
     }*/

    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

     // Configure the cell...

     return cell
     }
     */

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */

    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */

    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
