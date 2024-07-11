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
    }
    
    func bindData() {
        
    }
    
    func bindObserver() {
        
    }
    
    func presentReactionPopup(cell: UITableViewCell, selectedReaction: @escaping(String) -> Void) {
        let popupVC = ReactionPopupController()
        // Customize your reaction options
        popupVC.options = ["👍", "❤️", "😂", "😮", "😢", "😡"]
        popupVC.modalPresentationStyle = .popover
        popupVC.selectionHandler = { [weak self] selectedOption in
            print(selectedOption)
            selectedReaction(selectedOption)
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

