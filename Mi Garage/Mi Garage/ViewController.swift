//
//  ViewController.swift
//  Mi Garage
//
//  Created by Alan Nevot on 30/7/17.
//  Copyright © 2017 Alan Nevot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var myGarage : [Car] = []
    var myCar : Car!

    var carID : Int = 0

    @IBOutlet var carImage: UIImageView!
    @IBOutlet var brandLabel: UILabel!
    @IBOutlet var modelLabel: UILabel!
    @IBOutlet var milleageLabel: UILabel!
    @IBAction func changeCar(_ sender: UIButton) {

        carID += 1

        if carID >= myGarage.count
        {
            carID = 0
        }

        updateView()

    }

    @IBAction func acelerar(_ sender: UIButton) {
        self.myCar.accelerate()
    }

    @IBAction func aumentarKms(_ sender: UIButton) {

        self.myCar.addKms(kmsToAdd: 15)
        updateView()

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        myCar = Car(hp: 550, brand: "Ferrari", model: "458 Italia", color: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), milleage: 1500, image: #imageLiteral(resourceName: "ferrari"))
        myGarage.append(myCar)

        myCar = Car(hp: 65, brand: "Fiat", model: "127 Pick-Up", color: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), milleage: 280000, image: #imageLiteral(resourceName: "fiat"))
        myGarage.append(myCar)

        myCar = Car(hp: 110, brand: "Citroën", model: "Jumper", color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), milleage: 315000, image: #imageLiteral(resourceName: "citroen"))
        myGarage.append(myCar)

        myCar = Car(hp: 94, brand: "Chevrolet", model: "Corsa", color: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), milleage: 107500, image: nil)
        myGarage.append(myCar)

        updateView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateView () {

        myCar = myGarage[carID]

        UIView.animate(withDuration: 1.5, delay: 0.25, options: [.curveLinear, .allowUserInteraction], animations: {

            if self.myCar.image != nil {

                self.carImage.image = self.myCar.image

            }
            else
            {
                self.carImage.image = nil
            }

            self.brandLabel.text = "Marca y modelo: \(self.myCar.brand) \(self.myCar.model)"
            self.modelLabel.text = "Potencia (HP): \(self.myCar.hp)"
            self.milleageLabel.text = "Kilometraje actual: \(self.myCar.milleage)"
            self.view.backgroundColor = self.myCar.color

        }) {(completed) in
            print("Animación completa. Se muestra: \(self.myCar.description). La velocidad máxima en autopistas argentinas es de \(Car.maxSpeed())Km/h.")
        }
    }
}

