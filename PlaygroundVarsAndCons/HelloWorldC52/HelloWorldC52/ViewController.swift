//
//  ViewController.swift
//  HelloWorldC52
//
//  Created by Alan Nevot on 6/7/17.
//  Copyright © 2017 Alan Nevot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var nameLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        nameLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPressed(_ sender: UIButton) {

        let aName : String = nameTextField.text!

        nameLabel.text = "Hola \(aName)!👻👻"

        let alertController : UIAlertController = UIAlertController(title: "Bienvenido!", message: "Hola \(aName)! Bienvenido a mi aplicación!", preferredStyle: .alert)

        let okAction : UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)

        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)

    }

}

