//
//  StickerCollectionViewCell.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 11/07/2024.
//

import UIKit
import SwiftGifOrigin

class StickerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var imgSticker: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    func setupCell(
        stickerImage : UIImage? = nil,
        selectedSticker : UIImage? = nil,
        gifImageString: String? = nil,
        selectedGif: String? = nil,
        isSticker: Bool
    ) {
        if isSticker {
            let img : UIImage? = stickerImage == selectedSticker ? .checkmark.withTintColor(.white) : nil
            imgSticker.image = stickerImage
            imgSelected.image = img
        } else {
            let img : UIImage? = gifImageString == selectedGif ? .checkmark.withTintColor(.white) : nil
            imgSticker.loadGif(name: gifImageString ?? "")
            imgSelected.image = img
        }
    }

}
