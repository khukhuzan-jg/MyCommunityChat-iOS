//
//  ReactionPopupController.swift
//  MyCommunityChat-iOS
//
//  Created by kukuzan on 11/07/2024.
//

import Foundation
import UIKit

enum MessageSettingType : String {
    case copyText = "Copy text"
    case copyMessageLink = "Copy message link"
    case forward = "Forward"
    case pinnedMessage = "Pin"
    case gotoOriginalMessage = "Go to original message"
    case selectMessgae = "Select message"
    
    func getTitle() -> String {
        return self.rawValue
    }
}

protocol ReactionHandling {
    var didTapReaction: ((String) -> Void)? { get set }
}

class ReactionPopupController: UIViewController {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(ReactionCell.self, forCellWithReuseIdentifier: ReactionCell.reuseIdentifier)
        return collectionView
    }()
    
    let tableView : UITableView = {
        let tblview = UITableView(frame: .zero)
        tblview.register(MessageSettingTableViewCell.self)
        tblview.separatorStyle = .none
        return tblview
    }()
    
    var messageSettingTypes : [MessageSettingType] = [.copyText, .pinnedMessage , .copyMessageLink, .forward, .gotoOriginalMessage, .selectMessgae]
    
    var options: [String] = []
    var selectionHandler: ((String) -> Void)?
    var forwardMessageHandler : (() -> Void)?
    var pinnedMessageHandler : (() -> Void)?
    var isPinned : Bool = false
    var messageSettingHandler : ((_ messageSettingType : MessageSettingType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 200),
            // Adjust height as needed
            containerView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    override var preferredContentSize: CGSize {
        get {
            // Adjust as needed
            return CGSize(width: 200, height: 300)
        }
        set {
            super.preferredContentSize = newValue
        }
    }
}

extension ReactionPopupController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return options.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ReactionCell.reuseIdentifier, for: indexPath
        ) as! ReactionCell
        cell.label.text = options[indexPath.item]
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let selectedOption = options[indexPath.item]
        selectionHandler?(selectedOption)
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        // Adjust item size as needed
        return CGSize(
            width: collectionView.frame.width / 4,
            height: 50
        )
    }
}

extension ReactionPopupController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageSettingTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(MessageSettingTableViewCell.self)
        cell.setupCell(type: messageSettingTypes[indexPath.row], isPinned: self.isPinned)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            forwardMessageHandler?()
        }
        else if indexPath.row == 1 {
            pinnedMessageHandler?()
        }
        else {
            
        }
        
    }
}
