//
//  ReceiveMessageTableViewCell.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 03/07/2024.
//

import UIKit
import CommonExtension

class ReceiveMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.bgView.backgroundColor = .primary
        self.lblMessage.numberOfLines = 0
        self.imgProfile.image = .icPlaceholder
        self.lblMessage.textColor = .white
        self.lblTime.textColor = .white
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellData(message : Message , profile : UIImage) {
        let msgStr = message.messageText ?? ""
        lblTime.text = message.createdAt ?? ""
        lblTime.font = .RoboB10
        lblTime.textColor = .lightGray
        
        self.lblMessage.font = .RoboR16
        self.lblMessage.textColor = .white
        
        self.imgProfile.image = profile
        
        if let phone = msgStr.findPhoneNumber(),
           let range = msgStr.range(of: phone) {
            let attributedString = NSMutableAttributedString(string: msgStr)
            let nsRange = NSRange(range, in: msgStr)
            attributedString.setAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue], range: nsRange)
            
            print(attributedString)
            self.lblMessage.attributedText = attributedString
            
            self.lblMessage.addRangeGesture(stringRange: phone) {
                print("Tap :::::::")
                if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
                  UIApplication.shared.openURL(url)
                }
            }
        }
        else {
            self.lblMessage.text = msgStr
        }
        
        
    }
    
}
