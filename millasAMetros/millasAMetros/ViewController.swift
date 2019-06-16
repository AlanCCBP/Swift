//
//  ViewController.swift
//  millasAMetros
//
//  Created by Alan Nevot on 9/7/17.
//  Copyright © 2017 Alan Nevot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var distanceTextField: UITextField!
    @IBOutlet var fromUnit: UISegmentedControl!
    @IBOutlet var toUnit: UISegmentedControl!
    @IBOutlet var resultLabel: UILabel!

    let unitKm : Double = 1
    let unitMile : Double = 1.609
    let unitYard : Double = 1093.61

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.distanceTextField.delegate = self
        self.hideKeyBoardWhenTappingAround()

        resultLabel.text = "Escribe la distancia a convertir"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func convertPressed(_ sender: UIButton) {

        let selectedIndexFrom : Int = fromUnit.selectedSegmentIndex
        let selectedIndexTo : Int = toUnit.selectedSegmentIndex

        if let textFieldStr : String = distanceTextField.text, let textFieldVal : Double = Double(textFieldStr){

            var convertedValue : Double = 0

            switch selectedIndexFrom {
            case 0:

                /* From Km. */
                switch selectedIndexTo {
                case 1:
                    /* To Mi. */
                    convertedValue = textFieldVal * (unitKm / unitMile)
                case 2:
                    /* To Yd. */
                    convertedValue = textFieldVal * unitYard
                default:
                    convertedValue = 0
                }
            case 1:

                /* From Mi. */
                switch selectedIndexTo {
                case 0:
                    /* To Km. */
                    convertedValue = textFieldVal * unitMile
                case 2:
                    /* To Yd. */
                    convertedValue = textFieldVal * unitMile * unitYard
                default:
                    convertedValue = 0
                }
            case 2:

                /* From Yd. */
                switch selectedIndexTo {
                case 0:
                    /* To Km. */
                    convertedValue = textFieldVal * (unitKm / unitYard)
                case 1:
                    /* To Mi. */
                    convertedValue = textFieldVal * (unitMile / unitYard)
                default:
                    convertedValue = 0
                }
            default:
                convertedValue = 0
            }

            reloadView(textFieldVal: textFieldVal, convertedValue: convertedValue, convertFrom: selectedIndexFrom, convertTo: selectedIndexTo)

            }
        else
        {
            resultLabel.text = "Ingresa un número."
        }
    }

    func reloadView (textFieldVal : Double, convertedValue : Double, convertFrom : Int, convertTo : Int) {

        let initValue : String = String(format: "%.2f", textFieldVal)
        let endValue : String = String(format: "%.2f", convertedValue)

        switch convertFrom {
        case 0:

            /* From Km. */
            switch convertTo {
            case 1:
                /* To Mi. */
                resultLabel.text = "\(initValue)Km. = \(endValue)Mi."
            case 2:
                /* To Yd. */
                resultLabel.text = "\(initValue)Km. = \(endValue)Yd."
            default:
                resultLabel.text = "Ha seleccionado la misma unidad..."
            }
        case 1:

            /* From Mi. */
            switch convertTo {
            case 0:
                /* To Km. */
                resultLabel.text = "\(initValue)Mi. = \(endValue)Km."
            case 2:
                /* To Yd. */
                resultLabel.text = "\(initValue)Mi. = \(endValue)Yd."
            default:
                resultLabel.text = "Ha seleccionado la misma unidad..."
            }
        case 2:

            /* From Yd. */
            switch convertTo {
            case 0:
                /* To Km. */
                resultLabel.text = "\(initValue)Yd. = \(endValue)Km."
            case 1:
                /* To Mi. */
                resultLabel.text = "\(initValue)Yd. = \(endValue)Mi."
            default:
                resultLabel.text = "Ha seleccionado la misma unidad..."
            }
        default:
            resultLabel.text = "Ha ocurrido un error."
        }
    }
}

extension ViewController : UITextFieldDelegate {

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
