//
//  MailTableCell.swift
//  Birthdays_1
//
//  Created by Артём Синявцев on 07.12.2022.
//

import UIKit

class OneTableCell: UITableViewCell {
    
    @IBOutlet weak var dateTableLabel: UILabel!
    @IBOutlet weak var nameTableLabel: UILabel!
    @IBOutlet weak var fotoTableImageView: UIImageView!
    @IBOutlet weak var notificationTableLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}



