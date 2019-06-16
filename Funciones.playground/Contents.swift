//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


func sayHello (firstName : String)
{
    /*
        Esta función se utiliza para dar la bienvenida al usuario.
        Recibe como parámetro el nombre del mismo, y no retorna valores, sólo muestra un Alert.
     */
    UIAlertController(title: "Bienvenido", message: "Bienvenido \(firstName), que tengas buenas tardes.", preferredStyle: UIAlertControllerStyle.alert)

}

sayHello(firstName: "Alan")

/*
    Esta función devuelve la potencia de una base elevada a un exponente.
 */

func power2 (base : Int, exponent : Int) -> Double
{

    return pow(Double(base), Double(exponent))

}

/*
 Esta función, obtiene y devuelve en forma de tuplas la información de la acción que se recibe por parámetro en forma de código de empresa.
 */

func stocksWithID (stockId : String) -> (id : String, name : String, stockPrice : Double) {

    var id : String = "NAME", name : String = "No disponible", stockPrice : Double = 0

    switch stockId {

    case "AAPL":
        id = "AAPL"
        name = "Apple Computer Inc."
        stockPrice = 149.5


    case "GOOG":
        id = "GOOG"
        name = "Google Inc."
        stockPrice = 941.53


    case "EBAY":
        id = "EBAY"
        name = "EBay Inc."
        stockPrice = 35.94


    case "FB":
        id = "AMZN"
        name = "Amazon Inc."
        stockPrice = 1020.04

    default:
        break
    }

    return (id, name, stockPrice)

}

let stock = "AAPL"
let result = stocksWithID(stockId: stock)


print ("Las acciones de \(result.name) (\(result.id)), actualmente están cotizando U$S\(result.stockPrice).")

