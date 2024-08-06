//
//  SegmentView.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 05/08/2024.
//

import UIKit

enum SegmentViewType : String {
    case groups = "Groups"
    case channels = "Channels"
    
    func getTitle() -> String {
        return self.rawValue
    }
}
class SegmentView: BaseView {

    @IBOutlet weak var btnGroups: UIButton!
    @IBOutlet weak var groupView: UIView!
    @IBOutlet weak var btnChannel: UIButton!
    @IBOutlet weak var channelView: UIView!

    var selectedType : SegmentViewType = .groups
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        
        btnGroups.backgroundColor = .clear
        btnGroups.setTitle(SegmentViewType.groups.getTitle(), for: .normal)
        btnGroups.titleLabel?.font = .RoboB15
        btnGroups.setTitleColor(.black, for: .normal)
        
        btnChannel.backgroundColor = .clear
        btnChannel.setTitle(SegmentViewType.channels.getTitle(), for: .normal)
        btnChannel.titleLabel?.font = .RoboB15
        btnChannel.setTitleColor(.black, for: .normal)
        
        groupView.backgroundColor = .primary
        channelView.backgroundColor = .clear
        
        backgroundColor = .clear
        
    }
}
