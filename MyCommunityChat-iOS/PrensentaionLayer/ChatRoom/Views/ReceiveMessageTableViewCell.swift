//
//  ReceiveMessageTableViewCell.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 03/07/2024.
//

import UIKit
import CommonExtension

class ReceiveMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var lblForward: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var reactionLabel: UILabel!
    
    var didTapReaction = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.bgView.backgroundColor = .primary
        self.lblMessage.numberOfLines = 0
        self.imgProfile.image = .icPlaceholder
        self.lblMessage.textColor = .white
        self.lblTime.textColor = .white
        self.imgProfile.contentMode = .scaleAspectFill
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        self.addGestureRecognizer(longPressGesture)
        
        let removeTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleRemovePress(_:)))
        reactionLabel.isUserInteractionEnabled = true
        reactionLabel.addGestureRecognizer(removeTapGesture)
        
        lblForward.text = ""
        lblForward.font = .RoboB12
        lblForward.textColor = .lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellData(message : Message , profile : UIImage) {
        let msgStr = (message.messageType ?? .text) == .forward ? (message.forwardMessage?["text"] ?? "") : message.messageText ?? ""
        lblForward.text = (message.messageType ?? .text) == .forward ? "Forward Message" : ""
        
        lblTime.text = message.createdAt ?? ""
        lblTime.font = .RoboB10
        lblTime.textColor = .lightGray
        
        self.lblMessage.font = .RoboR16
        self.lblMessage.textColor = .white
        
        self.imgProfile.image = profile
        
        self.reactionLabel.text = message.reaction ?? ""
       
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
        
        layoutIfNeeded()
        setNeedsLayout()
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        didTapReaction()
    }
    
    @objc func handleRemovePress(_ gesture: UITapGestureRecognizer) {
        reactionLabel.text = ""
    }
}
