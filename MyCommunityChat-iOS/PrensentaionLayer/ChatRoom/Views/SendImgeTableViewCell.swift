//
//  SendImgeTableViewCell.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 04/07/2024.
//

import UIKit
import SwiftGifOrigin

class SendImgeTableViewCell: UITableViewCell {
    @IBOutlet weak var lblForward: UILabel!
    @IBOutlet weak var imgSend: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var reactionLabel: UILabel!
    
    var didTapReaction = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        self.imgSend.cornerRadius = 10
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        self.addGestureRecognizer(longPressGesture)
        
        let removeTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleRemovePress(_:)))
        reactionLabel.isUserInteractionEnabled = true
        reactionLabel.addGestureRecognizer(removeTapGesture)
        
        lblForward.font = .RoboB12
        lblForward.text = ""
        lblForward.textColor = .lightGray
        
        self.backgroundColor = .clear
        self.imgSend.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupcell(message : Message , isSelectedMessage : Bool) {
        self.reactionLabel.text = message.reaction ?? ""
       
        if let msgType = message.messageType {
            self.bgView.backgroundColor = msgType == .text ? .senderChat : .clear
            if msgType == .forward {
                print("Forward ::::: \(message.forwardMessage)")
                lblForward.text = "Forward Message"
                self.bgView.backgroundColor = .senderChat
                
                if let msgType = message.forwardMessage?["messageType"],
                   let messagegType = MessageType(rawValue: msgType) {
                    if messagegType == .image {
                        if let imgData = NSData(base64Encoded: message.forwardMessage?["image"] ?? "") {
                           let img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
                            self.imgSend.image = img
                            self.imgSend.contentMode = .scaleAspectFill
                        }
                    }
                    else {
                        if let imgData = NSData(base64Encoded: message.forwardMessage?["sticker"] ?? "") {
                           let img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
                            self.imgSend.image = img
                            self.imgSend.contentMode = .scaleAspectFit
                        }
                    }
                }
            }
            else {
                if msgType == .image {
                    if let imgData = NSData(base64Encoded: message.messageImage ?? "") {
                       let img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
                        self.imgSend.image = img
                        self.imgSend.contentMode = .scaleAspectFill
                    }
                }
                else {
                    if let stickerString = message.sticker, let gifString = message.gif {
                        if msgType == .gif {
                            self.imgSend.loadGif(name: gifString)
                            self.imgSend.contentMode = .scaleAspectFit
                        } else {
                            if let imgData = Data(base64Encoded: stickerString) {
                                let img = UIImage(data: imgData)
                                self.imgSend.image = img
                                self.imgSend.contentMode = .scaleAspectFit
                            }
                        }
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
