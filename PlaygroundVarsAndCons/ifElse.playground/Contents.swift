import UIKit
import Foundation

var isWoman : Bool = false
var deboSumar : Bool = true
var resultado : Int = 0
var unNumero : Int = 0
var otroNumero : Int = 0

if deboSumar {

    resultado = (2 + 2)

}

if unNumero >= otroNumero
{

    if unNumero == otroNumero
    {

        print("Ambos números son iguales.")

    }
    else
    {
        print("El primer número es mayor al segundo")
    }
}
else
{
    print("El primer número es más chico que el segundo.")
}


var aproboPrimerParcial : Bool = true
var aproboSegundoParcial : Bool = true


if aproboPrimerParcial && aproboSegundoParcial {

    print("Puede rendir final!")
}
else
{
    if !aproboPrimerParcial
    {
        print("Primero debe aprobar el primer parcial")
    }
    else
    {
        print("Primero debe aprobar el segundo parcial")
    }
}


if aproboPrimerParcial || aproboSegundoParcial {

    print("Puede rendir final!")
}
else
{
    if !aproboPrimerParcial
    {
        print("Primero debe aprobar el primer parcial")
    }
    else
    {
        print("Primero debe aprobar el segundo parcial")
    }
}