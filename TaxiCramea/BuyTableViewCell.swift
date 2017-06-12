//
//  BuyTableViewCell.swift
//  TaxiCramea
//
//  Created by админ on 28.05.17.
//  Copyright © 2017 админ. All rights reserved.
//

import UIKit

class BuyTableViewCell: UITableViewCell {

    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var beforeTime: UILabel!
    @IBOutlet weak var toTime: UILabel!
    @IBOutlet weak var whereTextLabel: UILabel!
    @IBOutlet weak var whenceTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
