//
//  Car.swift
//  Mi Garage
//
//  Created by Alan Nevot on 30/7/17.
//  Copyright © 2017 Alan Nevot. All rights reserved.
//

import Foundation
import UIKit

class Car: NSObject {

    var hp : Int
    var brand : String
    var model : String
    var color : UIColor
    var milleage : Double
    var image : UIImage?

    override var description: String {

        return "El auto es un \(brand) \(model) de color \(color), tiene \(hp)HP, y hasta el momento recorrió \(milleage)Kms."

    }

    /* Default constructor */
    override init() {
        hp = 0
        brand = "Unknown"
        model = "Unknown"
        color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        milleage = 0

    }

    init(hp: Int, brand: String, model: String, color: UIColor, milleage: Double, image: UIImage?) {

        self.hp = hp
        self.brand = brand
        self.model = model
        self.color = color
        self.milleage = milleage

        if let image = image
        {
            self.image = image
        }
    }

    func addKms (kmsToAdd : Double!) {

        self.milleage += kmsToAdd

    }

    func accelerate (){
        print("Waaaaaammmmm")
    }

    class func maxSpeed () -> Int {
        return 120
    }

    func HPToCV () -> Double {

        return Double(self.hp) * 1.0138

    }
}
