//
//  ViewController.swift
//  HelloWorld
//
//  Created by Alan Nevot on 5/7/17.
//  Copyright © 2017 Alan Nevot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet var helloLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        helloLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func buttonPressed(_ sender: UIButton) {

        //print("Alguien ha presionado el botón! 😈")

        /*let alertController : UIAlertController = UIAlertController(title: "Botón pulsado", message: "Hola! Te dije que no me toques!", preferredStyle: .alert)

        let okAction : UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)

        alertController.addAction(okAction)

        present(alertController, animated: true, completion: nil)*/

        let theText : String = nameTextField.text!

        helloLabel.text = "Hola \(theText), cómo estás?"


    }
}

