//
//  ReceiveImageTableViewCell.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 04/07/2024.
//

import UIKit

class ReceiveImageTableViewCell: UITableViewCell {

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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupcell(message : Message , profile : UIImage ) {
        if let imgData = NSData(base64Encoded: message.messageImage ?? "") {
           let img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
            self.imgReceive.image = img
            self.imgReceive.contentMode = .scaleAspectFill
        }
        self.imgProfile.image = profile
        
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        didTapReaction()
    }
    
    @objc func handleRemovePress(_ gesture: UITapGestureRecognizer) {
        reactionLabel.text = ""
    }
}
