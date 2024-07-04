//
//  AvatarItemCell.swift
//  Auth
//
//  Created by kukuzan on 04/07/2024.
//

import UIKit
import CommonUI
import CommonExtension

class AvatarItemCell: NibBasedCollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func render(flag: Bool) {
        containerView.backgroundColor = flag ? .silver : .white
        containerView |> borderStyle(
            flag ? .secondaryYellow : .white,
            flag ? 2 : 0,
            flag ? 50 : 0
        )
    }

}
