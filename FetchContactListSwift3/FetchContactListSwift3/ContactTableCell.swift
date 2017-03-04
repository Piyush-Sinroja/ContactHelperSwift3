//
//  ContactTableCell.swift
//  FetchContactListSwift3
//
//  Created by piyush sinroja on 12/01/17.
//  Copyright © 2017 Piyush. All rights reserved.
//

import UIKit

class ContactTableCell: UITableViewCell {

    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
