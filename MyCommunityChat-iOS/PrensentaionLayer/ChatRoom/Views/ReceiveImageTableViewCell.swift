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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.imgProfile.image = .icPlaceholder
        self.bgView.backgroundColor = .primary
        self.imgReceive.cornerRadius  = 10
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
    
}
