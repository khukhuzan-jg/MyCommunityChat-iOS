//
//  ChatRoomViewController+TableView.swift
//  MyCommunityChat-iOS
//
//  Created by kukuzan on 18/07/2024.
//

import UIKit

extension ChatRoomViewController {
    func setupTableView() {
        tblMessage.register(SendMessageTableViewCell.self)
        tblMessage.register(ReceiveMessageTableViewCell.self)
        tblMessage.register(SendImgeTableViewCell.self)
        tblMessage.register(ReceiveImageTableViewCell.self)
        
        tblMessage.delegate = self
        tblMessage.dataSource = self
        tblMessage.separatorStyle = .none
        tblMessage.showsVerticalScrollIndicator = false
        tblMessage.showsHorizontalScrollIndicator = false
        tblMessage.reloadData()
    }
    
    func updateMessage(msg : Message) {
        self.chatRoomViewModel.updateMessage(message: msg)
    }
}

// MARK: - UITableView Delegate & UITableView Data Soruce
extension ChatRoomViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return self.filterMessageList.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let message = self.filterMessageList[indexPath.row]
        let isSender = (message.senderId ?? "") == (self.currentUser?.id ?? "")
        
        switch message.messageType ?? .text {
        case .text:
            return configureTextCell(
                for: tableView,
                with: message,
                isSender: isSender
            )
        case .forward:
            if let messageType = message.forwardMessage?["messageType"],
               let msgType = MessageType(rawValue: messageType),
               msgType != .text
            {
                return configureImageCell(
                    for: tableView,
                    with: message,
                    isSender: isSender
                )
            }
            return configureTextCell(
                for: tableView,
                with: message,
                isSender: isSender
            )
        default:
            return configureImageCell(
                for: tableView,
                with: message,
                isSender: isSender
            )
        }
    }

    private func configureTextCell(
        for tableView: UITableView,
        with message: Message,
        isSender: Bool
    ) -> UITableViewCell {
        if isSender {
            let cell = tableView.deque(SendMessageTableViewCell.self)
            cell.setupCellData(
                message: message,
                isFilter: isFilter
            )
            setupMessageActions(
                for: cell,
                message: message
            )
            return cell
        } else {
            let cell = tableView.deque(ReceiveMessageTableViewCell.self)
            let profileImage = getProfileImage()
            cell.setupCellData(
                message: message, profile: profileImage)
            setupMessageActions(
                for: cell,
                message: message
            )
            return cell
        }
    }

    private func configureImageCell(
        for tableView: UITableView,
        with message: Message,
        isSender: Bool
    ) -> UITableViewCell {
        if isSender {
            let cell = tableView.deque(SendImgeTableViewCell.self)
            cell.setupcell(message: message)
            setupImageActions(for: cell, message: message)
            return cell
        } else {
            let cell = tableView.deque(ReceiveImageTableViewCell.self)
            let profileImage = getProfileImage()
            cell.setupcell(message: message, profile: profileImage)
            setupImageActions(for: cell, message: message)
            return cell
        }
    }

    private func setupMessageActions(
        for cell: UITableViewCell,
        message: Message
    ) {
        if let cell = cell as? SendMessageTableViewCell {
            cell.didTapReaction = { [weak self] in
                self?.handleReaction(for: cell, message: message)
            }
        } else if let cell = cell as? ReceiveMessageTableViewCell {
            cell.didTapReaction = { [weak self] in
                self?.handleReaction(for: cell, message: message)
            }
        }
    }

    private func setupImageActions(for cell: UITableViewCell, message: Message) {
        if let cell = cell as? SendImgeTableViewCell {
            cell.didTapReaction = { [weak self] in
                self?.handleReaction(for: cell, message: message)
            }
        } else if let cell = cell as? ReceiveImageTableViewCell {
            cell.didTapReaction = { [weak self] in
                self?.handleReaction(for: cell, message: message)
            }
        }
    }

    private func handleReaction(
        for cell: UITableViewCell,
        message: Message
    ) {
        var message = message
        presentReactionPopup(cell: cell, selectedReaction: { [weak self] reaction in
            if let cell = cell as? SendMessageTableViewCell {
                cell.reactionLabel.text = reaction
            } else if let cell = cell as? ReceiveMessageTableViewCell {
                cell.reactionLabel.text = reaction
            } else if let cell = cell as? SendImgeTableViewCell {
                cell.reactionLabel.text = reaction
            } else if let cell = cell as? ReceiveImageTableViewCell {
                cell.reactionLabel.text = reaction
            }
            message.reaction = reaction
            self?.updateMessage(msg: message)
        }, forwardMessage: {
            let forwardVC = ForwardViewController()
            forwardVC.currentUser = self.currentUser
            forwardVC.selectedessage = message
            forwardVC.modalPresentationStyle = .pageSheet
            self.present(forwardVC, animated: true)
        }, isPinned: message.isPinned ?? false, pinnedMessage: {
            message.isPinned = !(message.isPinned ?? false)
            self.updateMessage(msg: message)
        })
    }

    private func getProfileImage() -> UIImage {
        if let imgData = NSData(base64Encoded: self.selectedUser?.image ?? "") {
            return UIImage(data: Data(referencing: imgData)) ?? UIImage()
        }
        return .icPlaceholder
    }

}
