//
//  FullRecipeCell.swift
//  Mis recetas
//
//  Created by Alan Nevot on 2/8/17.
//  Copyright © 2017 Alan Nevot. All rights reserved.
//

import UIKit

class FullRecipeCell: UITableViewCell {

    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
