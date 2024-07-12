//
//  SendImgeTableViewCell.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 04/07/2024.
//

import UIKit

class SendImgeTableViewCell: UITableViewCell {
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupcell(message : Message) {
        self.reactionLabel.text = message.reaction ?? ""
       
        if let msgType = message.messageType {
            self.bgView.backgroundColor = msgType == .sticker ? .clear : .senderChat
            if msgType == .image {
                if let imgData = NSData(base64Encoded: message.messageImage ?? "") {
                   let img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
                    self.imgSend.image = img
                    self.imgSend.contentMode = .scaleAspectFill
                }
            }
            else {
                if let imgData = NSData(base64Encoded: message.sticker ?? "") {
                   let img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
                    self.imgSend.image = img
                    self.imgSend.contentMode = .scaleAspectFit
                }
            }
        }
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        didTapReaction()
    }
    
    @objc func handleRemovePress(_ gesture: UITapGestureRecognizer) {
        reactionLabel.text = ""
    }
}
