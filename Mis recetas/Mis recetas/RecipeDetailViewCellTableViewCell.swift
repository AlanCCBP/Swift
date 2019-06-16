//
//  RecipeDetailViewCellTableViewCell.swift
//  Mis recetas
//
//  Created by Alan Nevot on 8/8/17.
//  Copyright © 2017 Alan Nevot. All rights reserved.
//

import UIKit

class RecipeDetailViewCellTableViewCell: UITableViewCell {

    @IBOutlet var keyLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
