var shoppingList : [String] = [ "Patatas", "Huevos", "Cebolla", "Pimiento" ]

var luckyNumbers : [Int] = [ 7, 5, 13 ]

let weights : [Double] = [ 68.9, 50.0, 80.0 ]

let activeItems : [Bool] = [ true, false, false, true, true ]

shoppingList.append("Plátanos")

print(shoppingList.count)

luckyNumbers.append(3)

var dict : [ String : String ] = [ "APPL" : "Apple Computer Inc.", "GOOG" : "Google Inc.", "AMZN" : "Amazon Inc."]

print(dict)

dict[ "FB" ] = "Facebook Inc."
dict[ "TW" ] = "Twitter Inc."

print(dict)


var ejercicioDict : [ String : String ] = [ : ]

ejercicioDict[ "Alan" ] = "03-06-1988"
ejercicioDict[ "Solcito" ] = "23-11-1994"
ejercicioDict[ "Nona" ] = "21-12-1942"
ejercicioDict[ "Juan Gabriel Gomila" ] = "19-05-1888"

print(ejercicioDict["Juan Gabriel Gomila"])

if let oldJuanGabriel = ejercicioDict.updateValue("19-05-1988", forKey: "Juan Gabriel Gomila")
{
    print("La fecha de nacimiento de Juan Gabriel, estaba equivocada y era \(oldJuanGabriel).")

}

print("...pero en realidad, el valor correcto sería \(ejercicioDict["Juan Gabriel Gomila"]!)")

