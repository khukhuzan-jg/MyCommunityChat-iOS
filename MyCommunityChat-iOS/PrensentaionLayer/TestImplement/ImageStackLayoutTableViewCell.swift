//
//  ImageStackLayoutTableViewCell.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 26/07/2024.
//

import UIKit
import CommonExtension

class ImageStackLayoutTableViewCell: UITableViewCell {

    var parentStackView : UIStackView = {
        let stk = UIStackView(frame: .zero)
        stk.axis = .vertical
        return stk
    }()
    
    var msgLabel : UILabel = {
        let lbl = UILabel(frame: .zero)
        
        return lbl
    }()
    
    var imgView : UIImageView = {
        let iv = UIImageView(frame: .zero)
        return iv
    }()
    
    var images : [UIImage] = []
    var currentIdx = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        self.contentView.addSubview(parentStackView)
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        parentStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        parentStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10).isActive = true
        parentStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        parentStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 10).isActive = true
        
    }
    
    
    func setupCell(images : [UIImage] , text : String) {
        self.images = images
        
        self.msgLabel.text = text
        
        self.imgView.image = images[currentIdx]
        
        var xValue : CGFloat = 0.0
        var yValue : CGFloat = 0.0
        
        images.forEach { image in
            
            let scaleWidth = image.size.width > image.size.height ? contentView.width : contentView.width / 2
            let scaleImg = image.imageWithImage(scaledToWidth: scaleWidth)
            print("Width ::::::: \(scaleImg.size.width) Height ::::::: \(scaleImg.size.height)")
            var imageStack : UIStackView?
            var imageView : UIImageView?
            
            if size.width >= self.contentView.width {
                imageStack = UIStackView(frame: CGRect(x: xValue, y: yValue, width: scaleImg.size.width, height: scaleImg.size.height))
                imageView = UIImageView(frame: imageStack?.frame ?? .zero)
                imageView?.image = image
                imageView?.contentMode = .scaleAspectFill
                imageStack?.addArrangedSubview(imageView!)
                
                parentStackView.addArrangedSubview(imageStack!)
                imageStack?.translatesAutoresizingMaskIntoConstraints = false
                imageStack?.leadingAnchor.constraint(equalTo: parentStackView.leadingAnchor, constant: 0).isActive = true
                imageStack?.trailingAnchor.constraint(equalTo: parentStackView.trailingAnchor, constant: 0).isActive = true
                imageStack?.widthAnchor.constraint(equalToConstant: size.width).isActive = true
                imageStack?.heightAnchor.constraint(equalToConstant: size.height).isActive = true
                
                xValue = imageStack?.frame.minX ?? 0.0
                yValue = (imageStack?.frame.maxY ?? 0.0) + scaleImg.size.height
                
                print("Width ::::::: \(xValue) Height ::::::: \(yValue) After Changed")
               
            }
//            else {
//                imageStack = UIStackView(frame: CGRect(x: xValue, y: yValue, width: size.width, height: size.height))
//                imageView = UIImageView(frame: imageStack?.frame ?? .zero)
//                imageView?.image = image
//                imageView?.contentMode = .scaleAspectFill
//                imageStack?.addArrangedSubview(imageView!)
//                
//                parentStackView.addArrangedSubview(imageStack!)
//                
//                xValue = imageStack?.frame.minX ?? 0.0
//                yValue = imageStack?.frame.maxY ?? 0.0
//            }
        }
       
        parentStackView.addArrangedSubview(msgLabel)
        
        parentStackView.layoutSubviews()
        parentStackView.layoutIfNeeded()
        
        self.contentView.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    
    
}
