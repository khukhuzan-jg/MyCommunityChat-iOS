//
//  SegmentView.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 05/08/2024.
//

import UIKit
import RxSwift

enum SegmentViewType : String {
    case groups = "Groups"
    case channels = "Channels"
    
    func getTitle() -> String {
        return self.rawValue
    }
}

protocol SegmentViewDelegate {
    func didTapGroups()
    func didTapChannels()
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
        
        groupView.backgroundColor = .secondary
        channelView.backgroundColor = .clear
        
        backgroundColor = .clear
        
    }
    
    override func bindObserver() {
        super.bindObserver()
        
        btnGroups.rx.tap.bind { _ in
            self.setButtonAction(type: .groups)
        }
        .disposed(by: disposeBag)
        
        btnChannel.rx.tap.bind { _ in
            self.setButtonAction(type: .channels)
        }
        .disposed(by: disposeBag)
    }
    
    private func setButtonAction(type : SegmentViewType) {
        
            self.groupView.backgroundColor = type == .groups ? .secondary : .clear
            self.channelView.backgroundColor = type == .channels ? .secondary : .clear
      
    }
}
