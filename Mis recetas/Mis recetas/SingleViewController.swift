//
//  SingleViewController.swift
//  Mis recetas
//
//  Created by Alan Nevot on 1/8/17.
//  Copyright © 2017 Alan Nevot. All rights reserved.
//

import UIKit

class SingleViewController: UIViewController {

    var recipes : [Recipe] = []

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.

        /* Lo comentamos porque lo hicimos gráficamente.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        */

        var unaReceta : Recipe = Recipe(name: "Tortilla de papas", image : #imageLiteral(resourceName: "tortilla"), time : 20, ingredients : [ "Papas", "Huevos", "Cebollas"], steps: ["Cortar las papas", "Freír", "Dar vuelta"])
        self.recipes.append(unaReceta)

        unaReceta = Recipe(name: "Milanesas con papas fritas", image : #imageLiteral(resourceName: "milanesa"), time : 20, ingredients : [ "Lomo fileteado", "Pan rallado", "Huevo"], steps: ["Empanar la carne con el huevo", "Freír"])
        self.recipes.append(unaReceta)

        unaReceta = Recipe(name: "Salmón con salsa de crema de champignones", image : #imageLiteral(resourceName: "salmon"), time : 20, ingredients : [ "Desescamar el pescado", "Calentar la crema", "Pasar el salmón por la plancha, 5 minutos por lado", "Cocinar champignones", "Servir"], steps: ["Cortar las papas", "Freír", "Dar vuelta"])
        self.recipes.append(unaReceta)

        unaReceta = Recipe(name: "Asado a la parrilla", image : #imageLiteral(resourceName: "asado"), time : 20, ingredients : ["Medio kilo de carne por persona", "Sal"], steps: ["Calentar la parrilla", "Colocar la carne", "A la media hora darla vuelta"])
        self.recipes.append(unaReceta)

        unaReceta = Recipe(name: "Nachos con queso", image : #imageLiteral(resourceName: "nachos"), time : 20, ingredients : [ "Nachos", "Queso cheddar", "Cerveza"], steps: ["Servir los nachos", "Derretir el queso cheddar"])
        self.recipes.append(unaReceta)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SingleViewController : UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let recipe : Recipe = self.recipes[indexPath.row]
        let cellId : String = "FullRecipeCell"

        let cell : FullRecipeCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FullRecipeCell

        cell.recipeImage.image = recipe.image
        cell.nameLabel.text = recipe.name

        return cell

    }

}
