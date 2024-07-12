//
//  StickerCollectionViewCell.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 11/07/2024.
//

import UIKit
class StickerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var imgSticker: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
    }
    
    
    func setupCell(stickerImage : UIImage , selectedSticker : UIImage) {
        let img : UIImage? = stickerImage == selectedSticker ? .checkmark.withTintColor(.white) : nil
        imgSticker.image = stickerImage
        imgSelected.image = img
    }

}
