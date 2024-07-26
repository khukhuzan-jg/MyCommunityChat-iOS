//
//  ImageLayoutTableViewCell.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 25/07/2024.
//

import UIKit

class ImageLayoutTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var lblMessage: UILabel!
    
    var images : [UIImage] = [] {
        didSet {
            setupCollectionView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(images : [UIImage] , text : String) {
        print("Setup Cell")
        self.images = images
        lblMessage.text = text
//        imageCollectionView.reloadData()
    }
    
    
}
