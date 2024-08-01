//
//  UserTableViewCell.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 03/07/2024.
//

import UIKit
import CommonUI
import Auth
class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
//    @IBOutlet weak var lblMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.imgUserProfile.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(user : UserData) {
        if let imgData = NSData(base64Encoded: user.image ?? "") {
            self.imgUserProfile.image = UIImage(data: Data(referencing: imgData))
        }
        
        self.lblUserName.text = user.name ?? ""
        self.lblUserName.font = .RoboR16
        self.lblUserName.textColor = .black
        
//        self.lblMessage.text = user.lastMessage ?? ""
//        self.lblMessage.font = .RoboR14
//        self.lblMessage.textColor = .lastMessage
//        
        self.lblTime.text = Date().toString(.type17 , timeZone: TimeZone.current.localizedName(for: .standard, locale: .current) ?? "MM") 
        self.lblTime.font = .RoboR12
        self.lblTime.textColor = .lastMessage
    }
    
}
