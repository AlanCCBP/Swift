import Foundation


for var i in 1...100 {
    print("Voy por la iteración \(i) de 100.")
}

for var i in (1...100).reversed() {
    print ("Todavía quedan \(i) cervezas en la heladera...")
}

for var i in 1...10 {
    print ("2 elevado a la \(i) es = \(pow(Decimal(2), i)).")
}

var moviesArray : [String] = []

moviesArray.append("Jobs")
moviesArray.append("Red social")
moviesArray.append("No te metas con Zohan")
moviesArray.append("F&F")
moviesArray.append("Wolf of Wallstreet")

for (index, aMovie) in moviesArray.enumerated() {
    print("La película en la posición \(index) es la \(aMovie)")

    if(aMovie == "Jobs")
    {
        print("[ Realmente, esta ☝️ es mi película favorita. ]")
    }
}

