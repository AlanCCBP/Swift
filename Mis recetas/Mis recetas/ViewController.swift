//
//  ViewController.swift
//  Mis recetas
//
//  Created by Alan Nevot on 31/7/17.
//  Copyright © 2017 Alan Nevot. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var recipes : [Recipe] = []


    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.hidesBarsOnSwipe = true

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }

    //MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let recipe : Recipe = self.recipes[indexPath.row]
        let cellId : String = "RecipeCell"

        let cell : RecipeCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RecipeCell

        cell.thumbnailImageView.image = recipe.image
        cell.nameLabel.text = recipe.name
        cell.timeLabel.text = "\(recipe.time!) Mins."
        cell.ingredientsLabel.text = "Ingredientes: \(recipe.ingredients.count)"

        /* Se puede hacer sin código, en User Defined Runtime Attributes
         
        cell.thumbnailImageView.layer.cornerRadius = 42
        cell.thumbnailImageView.clipsToBounds = true
        */

        /*if recipe.isFavourite {
            cell.accessoryType = .checkmark
        }
        else
        {
            cell.accessoryType = .none
        }
        */


        return cell

    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            self.recipes.remove(at: indexPath.row)

        }

        self.tableView.deleteRows(at: [indexPath], with: .fade)

    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let shareAction = UITableViewRowAction(style: .default, title: "Compartir") { (action, indexPath) in

            let shareDefaultText = "Estoy mirando la receta de \(self.recipes[indexPath.row].name!) en la app del curso de iOS 10 con Juan Gabriel..."

            let activityViewController = UIActivityViewController(activityItems: [shareDefaultText, self.recipes[indexPath.row].image], applicationActivities: nil)

            self.present(activityViewController, animated: true, completion: nil)

        }

        shareAction.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)

        let deleteAction = UITableViewRowAction(style: .destructive, title: "Borrar") { (action, indexPath) in

            self.recipes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)

        }

        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 202.0/255.0, alpha: 1.0)

        return [shareAction, deleteAction]
    }

    //MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        /*
         let recipe : Recipe = self.recipes[indexPath.row]

        let alertController = UIAlertController(title: recipe.name, message: "Valora este plato!", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)

        var favouriteActionTitle : String = "Favorito"
        var favouriteActionStyle : UIAlertActionStyle = UIAlertActionStyle.default


        if recipe.isFavourite {

            favouriteActionTitle = "No favorito"
            favouriteActionStyle = UIAlertActionStyle.destructive
        }

        let favouriteAction = UIAlertAction(title: favouriteActionTitle, style: favouriteActionStyle) { (action) in

            let recipe : Recipe = self.recipes[indexPath.row]

            recipe.isFavourite = !recipe.isFavourite
            self.tableView.reloadData()

        }

        alertController.addAction(cancelAction)
        alertController.addAction(favouriteAction)

        self.present(alertController, animated: true, completion: nil)
        */

        


    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showRecipeDetail" {

            if let indexPath = self.tableView.indexPathForSelectedRow {

                let selectedRecipe = self.recipes[indexPath.row]

                let destinationViewController = segue.destination as! DetailViewController

                destinationViewController.recipe = selectedRecipe

            }

        }
    }
}

