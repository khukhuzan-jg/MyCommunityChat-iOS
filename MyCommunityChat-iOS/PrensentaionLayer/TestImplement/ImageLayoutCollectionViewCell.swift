//
//  ImageLayoutCollectionViewCell.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 26/07/2024.
//

import UIKit

class ImageLayoutCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView = {
        let imgView = UIImageView(frame: .zero)
        
        return imgView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupUI() {
        self.contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
    }
    
    
    func setupCell(image : UIImage) {
        setupUI()
        self.imageView.image = image
        self.imageView.contentMode = .scaleAspectFill
        
        self.layoutSubviews()
        self.layoutIfNeeded()
    }

}
