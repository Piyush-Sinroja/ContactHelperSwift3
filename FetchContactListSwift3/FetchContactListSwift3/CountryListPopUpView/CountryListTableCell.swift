//
//  CountryListTableCell.swift
//  ARDWM_Client
//
//  Created by piyush sinroja on 24/11/16.
//  Copyright © 2017 Piyush. All rights reserved.

import UIKit
class CountryListTableCell: UITableViewCell {

    
    @IBOutlet weak var countryName: UILabel!
    
    @IBOutlet weak var countryCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
