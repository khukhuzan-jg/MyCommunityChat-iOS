//
//  MessageSettingTableViewCell.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 16/07/2024.
//

import UIKit

class MessageSettingTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
        selectionStyle = .none
        lblTitle.font = .RoboB12
        lblTitle.textColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(type : MessageSettingType, isPinned : Bool) {
        if type == .pinnedMessage {
            if isPinned {
                lblTitle.text = "Unpin"
            }else{
                lblTitle.text = "Pin"
            }
            
        }else{
            lblTitle.text = type.getTitle()
        }
        
    }
    
}
