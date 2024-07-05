//
//  ProfileImageView.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 05/07/2024.
//

import UIKit

class ProfileView: UIView {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        // Set your profile image
        imageView.image = .icPlaceholder
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .RoboB16
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add profile image view
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        // Add name label
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70).isActive = true
    }
    
    func setupData(image : UIImage , name : String) {
        profileImageView.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.image = image
        nameLabel.text = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
