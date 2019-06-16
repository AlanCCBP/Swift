//
//  ViewController.swift
//  TextViewSample
//
//  Created by Alan Nevot on 22/8/17.
//  Copyright © 2017 Alan Nevot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var textView: UITextView!

    let placeholder : String = "Introduce aquí tu texto..."
    let placeholderColor : UIColor = UIColor.lightGray
    let textViewColor : UIColor = UIColor.black



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.hideKeyBoardWhenTappingAround()

        textView.delegate = self
        textView.text = placeholder
        textView.textColor = placeholderColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {

        if textView.text == placeholder {

            textView.text = ""
            textView.textColor = textViewColor

        }

        textView.becomeFirstResponder()

    }

    func textViewDidEndEditing(_ textView: UITextView) {

        if textView.text == "" {

            textView.text = placeholder
            textView.textColor = placeholderColor

        }

        textView.resignFirstResponder()

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true
        
    }
}

extension UIViewController {

    func hideKeyBoardWhenTappingAround () {

        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyBoard))

        view.addGestureRecognizer(tap)

    }

    func dismissKeyBoard () {

        view.endEditing(true)
        
    }
}
