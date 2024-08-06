//
//  ChatRoomViewController + Extension .swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 05/08/2024.
//

import Foundation
import UIKit

extension ChatRoomViewController {
    
    
    /// note : set transparent Navigation Bar
    func transparentNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.clear
        appearance.backgroundEffect = UIBlurEffect(style: .light) // or dark
        
        let scrollingAppearance = UINavigationBarAppearance()
        scrollingAppearance.configureWithTransparentBackground()
        scrollingAppearance.backgroundColor = .white // your view (superview) color
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = scrollingAppearance
        UINavigationBar.appearance().compactAppearance = scrollingAppearance
        
    }
    
    
    /// note : set navigation bar items
    func setNavigationBar() {
        
        let back = UIBarButtonItem(
            image: .icBackButton.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(self.backAction)
        )
        
        var img : UIImage = .icDemo6
        if let imgData = NSData(base64Encoded: self.selectedUser?.image ?? "") {
            img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
            
        }
        
        // Create a custom profile view
        let profileView = ProfileView(
            frame: CGRect(x: 10, y: 0, width: 200, height: 44)
        )
        profileView.setupData(
            image: img,
            name: self.selectedUser?.name ?? ""
        )
        // Wrap it in a UIBarButtonItem
        let profileBarButtonItem = UIBarButtonItem(customView: profileView)
        
        // Set it as the left or right bar button item based on your needs
        navigationItem.leftBarButtonItems = [back, profileBarButtonItem]
        
        let searchBtn = UIBarButtonItem(
            image: UIImage(
                systemName: "magnifyingglass"
            )?.withTintColor(.white, renderingMode: .alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(searchAction)
        )
        let moreBtn = UIBarButtonItem(
            image: .icMore.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(self.moreAction)
        )
        
        let doneBtn = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(self.doneAction)
        )
        
        var rightBarButtons = [UIBarButtonItem]()
        
        chatRoomViewModel.selectedMessagesBehaviorRelay.bind {
            rightBarButtons.removeAll()
            self.navigationItem.rightBarButtonItems = nil
            
            if !$0.isEmpty {
                rightBarButtons.insert(doneBtn, at: 0)
            }
            rightBarButtons.append(moreBtn)
            rightBarButtons.append(searchBtn)
            self.navigationItem.rightBarButtonItems = rightBarButtons
        }
        .disposed(by: disposeBag)
        
        
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }
}
