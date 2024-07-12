//
//  MorePopupTableViewCell.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 11/07/2024.
//

import UIKit

class MorePopupTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgSelect: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell() {
        self.selectionStyle = .none
        lblTitle.font = .RoboB14
        lblTitle.textColor = .darkGray
    }
    
    func setupCell(title : String , isSelectedTitle : Bool) {
        lblTitle.text = title
        lblTitle.textColor = isSelectedTitle ? .black : .lightGray
    }
    
}
