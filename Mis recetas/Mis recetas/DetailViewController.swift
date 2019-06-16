//
//  DetailViewController.swift
//  Mis recetas
//
//  Created by Alan Nevot on 7/8/17.
//  Copyright © 2017 Alan Nevot. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var ratingButton: UIButton!
    
    
    var recipe : Recipe!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.recipeImageView.image = self.recipe.image
        self.tableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.25)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.25)
        self.title = self.recipe.name

        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension

        self.ratingButton.setImage(UIImage(named: self.recipe.rating), for: .normal)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func close(segue: UIStoryboardSegue) {

        if let reviewVC = segue.source as? ReviewViewController {

            if let rating = reviewVC.ratingSelected {

                self.recipe.rating = rating
                self.ratingButton.setImage(UIImage(named: self.recipe.rating), for: .normal)

            }
        }
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

extension DetailViewController : UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            //return 3
            return 2
        case 1:
            return self.recipe.ingredients.count
        case 2:
            return self.recipe.steps.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailRecipeCell", for: indexPath) as! RecipeDetailViewCellTableViewCell

        cell.backgroundColor = UIColor.clear

        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.keyLabel.text = "Nombre: "
                cell.valueLabel.text = self.recipe.name
            case 1:
                cell.keyLabel.text = "Tiempo: "
                cell.valueLabel.text = "\(self.recipe.time!)Min."
            /*case 2:
                cell.keyLabel.text = "Favorita: "
                if self.recipe.isFavourite {
                    cell.valueLabel.text = "Sí"
                }
                else
                {
                    cell.valueLabel.text = "No"
                }
            */
            default:
                break;
            }
        case 1:
            /*
            if indexPath.row == 0 {
                cell.keyLabel.text = "Ingredientes: "
            }
            else
            {
                cell.keyLabel.text = ""
            }
            */
            cell.keyLabel.text = ""
            cell.valueLabel.text = self.recipe.ingredients[indexPath.row]

        case 2:
            /*
            if indexPath.row == 1 {
                cell.keyLabel.text = "Instrucciones: "
            }
            else
            {
                cell.keyLabel.text = ""
            }
            */
            cell.keyLabel.text = ""
            cell.valueLabel.text = self.recipe.steps[indexPath.row]

        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        var title = ""

        switch section {
        case 1:
            title = "Ingredientes"
        case 2:
            title = "Instrucciones"
        default:
            break
        }

        return title
    }
}

extension DetailViewController : UITableViewDelegate {


}
