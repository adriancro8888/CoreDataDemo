//
//  DashboardCell.swift
//  CoreDataCRUD
//
//  Created by Thomas Woodfin on 1/8/21.
//  Copyright © 2021 Thomas Woodfin. All rights reserved.
//

import UIKit

class DashboardCell: UITableViewCell {
    
    static let identifire = "DashboardCell"
    @IBOutlet weak private var nameLbl: UILabel!
    @IBOutlet weak private var emailLbl: UILabel!
    
    var deleteUser: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: UserResponse){
        nameLbl.text = data.name
        emailLbl.text = data.email
    }

    @IBAction func deleteAction(_ sender: Any) {
        deleteUser?()
    }
}
