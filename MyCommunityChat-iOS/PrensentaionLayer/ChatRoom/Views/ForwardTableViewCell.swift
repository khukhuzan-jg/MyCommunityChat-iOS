//
//  ForwardTableViewCell.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 16/07/2024.
//

import UIKit
import Kingfisher
class ForwardTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgRadio: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblName.font = .RoboB14
        lblName.textColor = .black
        imgView.contentMode = .scaleAspectFill
        
        selectionStyle = .none
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupCell(user : UserData , selectedUser : UserData? = nil , isSelectEnable : Bool) {
        lblName.text = user.name ?? ""
        if let imgData = NSData(base64Encoded: user.image ?? "") {
            self.imgView.image = UIImage(data: Data(referencing: imgData))
        }
        
        if let user = selectedUser {
            if let selectedUserId = selectedUser?.id ,
               !selectedUserId.isEmpty {
                imgRadio.image = UIImage(systemName: "checkmark.circle.fill")
            }
            else {
                imgRadio.image = nil
            }
        }
        else {
            imgRadio.image = nil
        }
    }
    
}
