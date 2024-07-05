//
//  ChatRoomViewController.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 03/07/2024.
//

import UIKit
import RxSwift
class ChatRoomViewController: BaseViewController {

    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var tblMessage: UITableView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageBGView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    
    let chatRoomViewModel = ChatRoomViewModel.shared
    
    var messageList = [Message]()
    var selectedUser : UserData?
    var currentUser : UserData?
    var selectedImageStr = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        setNavigationBar()
        bottomViewHeight.constant = 120.0
        self.btnClose.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblInfo.text = "Let's start our conversation!"
        lblInfo.font = .RoboB15
        lblInfo.textColor = .darkGray
        
        txtMessage.text = "Enter your message"
        txtMessage.textColor = UIColor.lightGray
        
        txtMessage.delegate = self
    }
    
    override func bindData() {
        super.bindData()
        
        chatRoomViewModel.currentUser.accept(currentUser)
        chatRoomViewModel.selectedUser.accept(selectedUser)
        chatRoomViewModel.getMessage()
        
        
    }
    
    override func bindObserver() {
        super.bindObserver()
        
        btnCamera.rx.tap.bind { _ in
            print("Tap Camera")
            self.showBottomSheet()
        }
        .disposed(by: disposeBag)
        
        txtMessage.rx.text.bind {
            if let txt = $0 {
                self.setTextMode()
//                self.btnSend.alpha = txt.isEmpty ? 0.5 : 1.0
//                self.btnSend.isUserInteractionEnabled = !txt.isEmpty
            }
        }
        .disposed(by: disposeBag)
        
        
        
        btnSend.rx.tap.bind { _ in
            if let text = self.txtMessage.text {
                var type : MessageType = self.selectedImageStr.isEmpty ? .text : .image
                
                let message = Message(messageText: text, messageImage: self.selectedImageStr, messageType: type, createdAt: "", lastMessage: "", senderId: self.currentUser?.id ?? "")
                self.chatRoomViewModel.sendMessage(message: message)
                self.txtMessage.text = ""
                self.bottomViewHeight.constant = 120.0
                self.btnClose.isHidden = true
//                self.messageList.append(message)
//                self.tblMessage.reloadData()
//                if !self.messageList.isEmpty {
//                    self.tblMessage.beginUpdates()
//                    self.tblMessage.scrollToRow(at: IndexPath(row: self.messageList.count - 1, section: 0), at: .bottom, animated: true)
//                    self.tblMessage.endUpdates()
//                }
            }
        }
        .disposed(by: disposeBag)
        
        chatRoomViewModel.successfullySendMessage.bind { isSuccess in
            if isSuccess {
                self.chatRoomViewModel.getMessage()
//                self.chatRoomViewModel.successfullySendMessage.accept(false)
            }
        }
        .disposed(by: disposeBag)
       
        chatRoomViewModel.messageListBehaviorRelay.bind { messages in
            self.messageList = messages
            self.lblInfo.isHidden = !self.messageList.isEmpty
            self.tblMessage.isHidden = self.messageList.isEmpty
            self.tblMessage.reloadData()
            if !self.messageList.isEmpty ,
               self.messageList.count > 0 {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.tblMessage.beginUpdates()
                    self.tblMessage.scrollToRow(at: IndexPath(row: self.messageList.count - 1, section: 0), at: .bottom, animated: true)
                    self.tblMessage.endUpdates()
                })
                
            }
        }
        .disposed(by: disposeBag)
        
        btnClose.rx.tap.bind { _ in
            self.setTextMode()
        }
        .disposed(by: disposeBag)
    }
    
    private func setTextMode() {
        self.bottomViewHeight.constant = 120.0
        self.imageView.image = nil
        self.selectedImageStr = ""
        self.btnClose.isHidden = true
    }

    private func setupTableView() {
        tblMessage.register(UINib(nibName: String(describing: SendMessageTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SendMessageTableViewCell.self))
        tblMessage.register(UINib(nibName: String(describing: ReceiveMessageTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ReceiveMessageTableViewCell.self))
        
        tblMessage.register(UINib(nibName: String(describing: SendImgeTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SendImgeTableViewCell.self))
        tblMessage.register(UINib(nibName: String(describing: ReceiveImageTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ReceiveImageTableViewCell.self))
        
        tblMessage.delegate = self
        tblMessage.dataSource = self
        tblMessage.separatorStyle = .none
        tblMessage.showsVerticalScrollIndicator = false
        tblMessage.showsHorizontalScrollIndicator = false
        tblMessage.reloadData()
    }
    
    
    private func showBottomSheet() {
        let alert = UIAlertController(title: "Choose image", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.chooseImage(sourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.chooseImage(sourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        self.navigationController?.present(alert, animated: true)
    }
    
    private func setNavigationBar() {
        
        let back = UIBarButtonItem(image: .icBackButton.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backAction))
        
        var img : UIImage = .icDemo6
        if let imgData = NSData(base64Encoded: self.selectedUser?.image ?? "") {
            img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
            
        }
        
        // Create a custom profile view
        let profileView = ProfileView(frame: CGRect(x: 10, y: 0, width: 200, height: 44))
        profileView.setupData(image: img, name: self.selectedUser?.name ?? "")
        // Wrap it in a UIBarButtonItem
        let profileBarButtonItem = UIBarButtonItem(customView: profileView)
        
        // Set it as the left or right bar button item based on your needs
        navigationItem.leftBarButtonItems = [back , profileBarButtonItem]
        
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func chooseImage(sourceType : UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }

}

extension ChatRoomViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.messageList[indexPath.row]
        
        if (message.messageType ?? .text) == .text {
            if (message.senderId ?? "") == (self.currentUser?.id ?? "") {
                guard let senderCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SendMessageTableViewCell.self), for: indexPath) as? SendMessageTableViewCell else {return UITableViewCell()}
                senderCell.setupCellData(message: message)
                return senderCell
            }
            else {
                guard let receiverCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReceiveMessageTableViewCell.self), for: indexPath) as? ReceiveMessageTableViewCell else {return UITableViewCell()}
                
                var img : UIImage = .icPlaceholder
                if let imgData = NSData(base64Encoded: self.selectedUser?.image ?? "") {
                    img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
                    
                }
                receiverCell.setupCellData(message: message , profile: img)
                return receiverCell
            }
        }
        else {
            if (message.senderId ?? "") == (self.currentUser?.id ?? "") {
                guard let senderCell = tableView.dequeueReusableCell(withIdentifier: String(describing: SendImgeTableViewCell.self), for: indexPath) as? SendImgeTableViewCell else {return UITableViewCell()}
                senderCell.setupcell(message: message)
                return senderCell
            }
            else {
                guard let receiverCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReceiveImageTableViewCell.self), for: indexPath) as? ReceiveImageTableViewCell else {return UITableViewCell()}
                
                var img : UIImage = .icPlaceholder
                if let imgData = NSData(base64Encoded: self.selectedUser?.image ?? "") {
                    img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
                    
                }
                receiverCell.setupcell(message: message, profile: img)
                return receiverCell
            }
        }
        
    }
}

extension ChatRoomViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage else {
            return
        }
        
        imageView.image = image
        selectedImageStr = image.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
        bottomViewHeight.constant = 250.0
        self.btnClose.isHidden = false
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}

extension ChatRoomViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter your message" {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your message"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
}
