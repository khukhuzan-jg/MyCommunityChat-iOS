//
//  SendMessageTableViewCell.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 03/07/2024.
//

import UIKit
import CommonExtension

class SendMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var lblForward: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var reactionLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    var didTapReaction = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.bgView.backgroundColor = .senderChat
        self.lblMessage.numberOfLines = 0
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        self.addGestureRecognizer(longPressGesture)
        
        let removeTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleRemovePress(_:)))
        reactionLabel.isUserInteractionEnabled = true
        reactionLabel.addGestureRecognizer(removeTapGesture)
        
        lblForward.font = .RoboB12
        lblForward.text = ""
        lblForward.textColor = .lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellData(message : Message, isFilter: Bool , isselectedMessage : Bool) {
        let msgStr = (message.messageType ?? .text) == .forward ? (message.forwardMessage?["text"] ?? "") : message.messageText ?? ""
        
        lblForward.text = (message.messageType ?? .text) == .forward ? "Forward Message" : ""
        
        lblTime.text = message.createdAt ?? ""
        lblTime.font = .RoboB10
        lblTime.textColor = .lightGray
        
        self.lblMessage.font = .RoboR16
        self.lblMessage.textColor = .black
        self.lblMessage.backgroundColor = isFilter ? .yellow : .clear
        
        self.reactionLabel.text = message.reaction ?? ""
        
        if let phone = msgStr.findPhoneNumber(),
           let range = msgStr.range(of: phone) {
            let attributedString = NSMutableAttributedString(string: msgStr)
            let nsRange = NSRange(range, in: msgStr)
            attributedString.setAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue], range: nsRange)
            
            print(attributedString)
            self.lblMessage.attributedText = attributedString
            
            self.lblMessage.addRangeGesture(stringRange: phone) {
                print("Tap :::::::")
                if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
                  UIApplication.shared.openURL(url)
                }
            }
        }
        else {
            let mutableAttributedString = NSMutableAttributedString(string: msgStr)
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: msgStr, options: [], range: NSRange(location: 0, length: msgStr.utf16.count))
            
            for match in matches {
                guard let range = Range(match.range, in: msgStr) else { continue }
                var urlStr = msgStr[range]
                
                self.lblMessage.addRangeGesture(stringRange: String(urlStr)) {
                    print("Tap ::::::: \(urlStr)")
                    self.handleUrl(urlString: String(urlStr))
                }
                
                let nsRange = NSRange(range, in: msgStr)
                mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: match.range)
            }
            self.lblMessage.attributedText = mutableAttributedString
            
        }
        
        self.bgView.borderWidth = isselectedMessage ? 2 : 0
        self.bgView.borderColor = isselectedMessage ? .secondary : .clear
        
        
        layoutIfNeeded()
        setNeedsLayout()
    }

    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        didTapReaction()
    }
    
    @objc func handleRemovePress(_ gesture: UITapGestureRecognizer) {
        reactionLabel.text = ""
    }
    
    private func handleUrl(urlString : String) {
        var urlStr = urlString
        if !urlStr.contains("https://") || !urlStr.contains("http://") {
            urlStr = "https://" + urlStr
        }
        guard let url = URL(string: String(urlStr)) else {
                print("invalid url")
                return
            }
            UIApplication.shared.open(url, completionHandler: { success in
                if success {
                    print("opened")
                } else {
                    print("failed")
                    // showInvalidUrlAlert()
                }
            })
    }
    
}



