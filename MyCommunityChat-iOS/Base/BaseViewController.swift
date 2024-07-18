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
    
    func presentReactionPopup(cell: UITableViewCell , selectedReaction: @escaping(String) -> Void , forwardMessage : @escaping () -> Void,isPinned : Bool,pinnedMessage : @escaping () -> Void) {
        let popupVC = ReactionPopupController()
        // Customize your reaction options
        popupVC.options = ["👍", "❤️", "😂", "😮", "😢", "😡"]
        popupVC.modalPresentationStyle = .popover
        popupVC.selectionHandler = { selectedOption in
            selectedReaction(selectedOption)
        }
        
        popupVC.forwardMessageHandler = {
            print("Forward message Tap")
            popupVC.dismissVC()
            forwardMessage()
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
}

extension BaseViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(
        for controller: UIPresentationController
    ) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

