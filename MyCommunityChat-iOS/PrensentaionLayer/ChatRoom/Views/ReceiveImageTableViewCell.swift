//
//  ReceiveImageTableViewCell.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 04/07/2024.
//

import UIKit

class ReceiveImageTableViewCell: UITableViewCell {

    @IBOutlet weak var lblForwardMessage: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgReceive: UIImageView!
    @IBOutlet weak var reactionLabel: UILabel!
    
    var didTapReaction = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.imgProfile.image = .icPlaceholder
        self.bgView.backgroundColor = .primary
        self.imgReceive.cornerRadius  = 10
        self.imgProfile.contentMode = .scaleAspectFill
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        self.addGestureRecognizer(longPressGesture)
        
        let removeTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleRemovePress(_:)))
        reactionLabel.isUserInteractionEnabled = true
        reactionLabel.addGestureRecognizer(removeTapGesture)
        
        lblForwardMessage.text = ""
        lblForwardMessage.font = .RoboB12
        lblForwardMessage.textColor = .lightGray
        
        self.backgroundColor = .clear
        self.imgReceive.backgroundColor = .clear
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupcell(message : Message , profile : UIImage , isSelectedMessage : Bool ) {
        self.reactionLabel.text = message.reaction ?? ""
       
        if let msgType = message.messageType {
            self.bgView.backgroundColor = msgType == .sticker ? .clear : .primary
            
            if msgType == .forward {
                print("Forward ::::: \(message.forwardMessage)")
                lblForwardMessage.text = "Forward Message"
                self.bgView.backgroundColor = .primary
                
                if let msgType = message.forwardMessage?["messageType"],
                   let messagegType = MessageType(rawValue: msgType) {
                    if messagegType == .image {
                        if let imgData = NSData(base64Encoded: message.forwardMessage?["image"] ?? "") {
                           let img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
                            self.imgReceive.image = img
                            self.imgReceive.contentMode = .scaleAspectFill
                        }
                    }
                    else {
                        if let imgData = NSData(base64Encoded: message.forwardMessage?["sticker"] ?? "") {
                           let img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
                            self.imgReceive.image = img
                            self.imgReceive.contentMode = .scaleAspectFit
                        }
                    }
                }
            }
            else {
                lblForwardMessage.text = ""
                if msgType == .image {
                    if let imgData = NSData(base64Encoded: message.messageImage ?? "") {
                       let img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
                        self.imgReceive.image = img
                        self.imgReceive.contentMode = .scaleAspectFill
                    }
                }
                else {
                    if let imgData = NSData(base64Encoded: message.sticker ?? "") {
                       let img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
                        self.imgReceive.image = img
                        self.imgReceive.contentMode = .scaleAspectFit
                    }
                }
            }

        }
        
        self.bgView.borderWidth = isSelectedMessage ? 2 : 0
        self.bgView.borderColor = isSelectedMessage ? .secondary : .clear
        
        
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
