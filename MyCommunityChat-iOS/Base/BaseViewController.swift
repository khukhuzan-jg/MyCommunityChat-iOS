//
//  BaseViewController.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 04/07/2024.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Auth

class BaseViewController : UIViewController {
    let disposeBag = DisposeBag()
    let userManager = UserManager.shared
    override func viewDidLoad() {
        self.bindData()
        self.bindObserver()
        self.bindViewModel()
        self.setupUI()
    }
    
    func bindData() {
        
    }
    
    func bindObserver() {
        
    }
    
    func bindViewModel() {
        
    }
    
    func setupUI() {
        
    }
    
    func presentReactionPopup(cell: UITableViewCell , message : Message? = nil, selectedReaction: @escaping(String) -> Void , forwardMessage : @escaping () -> Void , isPinned : Bool,pinnedMessage : @escaping () -> Void) {
        let popupVC = ReactionPopupController()
        // Customize your reaction options
        popupVC.options = ["👍", "❤️", "😂", "😮", "😢", "😡"]
        popupVC.modalPresentationStyle = .popover
        popupVC.selectionHandler = { selectedOption in
            selectedReaction(selectedOption)
        }
        
        popupVC.messageSettingHandler = { settingType in
            popupVC.dismissVC()
            switch settingType {
            case .copyText:
                if let msg = message{
                    if  msg.messageType == .forward {
                        self.copyText(text: msg.forwardMessage?["text"] ?? "")
                    }
                    else {
                        self.copyText(text: msg.messageText ?? "")
                    }
                }
            case .forward :
                forwardMessage()
            case .selectMessgae :
                self.selectMessages()
            default :
                print(settingType.getTitle())
            }
            
        }
        
        popupVC.isPinned = isPinned
        popupVC.pinnedMessageHandler = {
            popupVC.dismissVC()
            pinnedMessage()
        }
        if let ppc = popupVC.popoverPresentationController {
            ppc.delegate = self
            ppc.sourceView = cell
            ppc.sourceRect = cell.bounds
        }
        self.present(popupVC, animated: true, completion: nil)
    }
    
    private func copyText(text : String) {
        // write to clipboard
        UIPasteboard.general.string = text
    }
    
    func selectMessages() {
        
    }
}

extension BaseViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(
        for controller: UIPresentationController
    ) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

