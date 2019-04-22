//
//  TableViewCell1.swift
//  3APL_GBL
//
//  Created by Aiman Bahouala on 15/11/2018.
//  Copyright © 2018 GBL. All rights reserved.
//

import UIKit

class TableViewCell1: UITableViewCell {
    
    @IBOutlet weak var NomLabel: UILabel!
    @IBOutlet weak var PrenomLabel: UILabel!
    
    @IBOutlet weak var koi: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
