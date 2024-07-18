//
//  ChatRoomViewController.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 03/07/2024.
//

import UIKit
import RxSwift
import iOSPhotoEditor
import CommonUI
class ChatRoomViewController: BaseViewController {
    
    @IBOutlet weak var btnPin: UIButton!
    @IBOutlet weak var lblPinMessage: UILabel!
    @IBOutlet weak var lblPin: UILabel!
    @IBOutlet weak var imgPinThumb: UIImageView!
    @IBOutlet weak var pinnedView: UIView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var tblMessage: UITableView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageBGView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var stickerBGView: UIView!
    @IBOutlet weak var stickerCollectionView: UICollectionView!
    @IBOutlet weak var btnSticker: UIButton!
    @IBOutlet weak var btnDownArrow: UIButton!
    
    let chatRoomViewModel = ChatRoomViewModel.shared
    
    var messageList = [Message]()
    var filterMessageList: [Message] = []
    var selectedUser : UserData?
    var currentUser : UserData?
    var selectedImageStr = String()
    var isShowMorePopup = false
    let morePopupView = MorePopupView()
    let stickerList : [UIImage] = [.sticker1 , .sticker2 , .sticker3 , .sticker4 , .sticker5 , .sticker6]
    var isShowStickerView = false
    var selectedSticker = UIImage()
    var selectedStickerString = String()
    var pinnedMessageList = [Message]()
    let searchBar = UISearchBar()
    var isFilter = false
    
    var reactionScrollIdx = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupTableView()
        setNavigationBar()
        setupCollectionView()
        bottomViewHeight.constant = 120.0
        self.btnClose.isHidden = true
        self.pinnedView.isHidden = true
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
    
    @objc func addReaction(_ sender: UIMenuItem) {
        guard let indexPath = tblMessage.indexPathForSelectedRow else { return }
        messageList[indexPath.row].reaction = sender.title
        tblMessage.reloadRows(at: [indexPath], with: .automatic)
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
            if let txt = $0 ,
               !self.selectedStickerString.isEmpty ,
               !self.selectedImageStr.isEmpty {
                self.setTextMode()
            }
        }
        .disposed(by: disposeBag)
        
        btnDownArrow.rx.tap.bind { _ in
            let reactionMsg = self.messageList.filter({!($0.reaction ?? "").isEmpty})
            if !reactionMsg.isEmpty ,
               self.reactionScrollIdx < reactionMsg.count{
                let messageId = reactionMsg[self.reactionScrollIdx].messageId ?? ""
                if let idx = self.messageList.firstIndex(where: {$0.messageId ?? "" == messageId}) ,
                   idx < self.messageList.count {
                    self.reactionScrollIdx += 1
                    self.tblMessage.scrollToRow(at: IndexPath(row: idx, section: 0), at: .bottom, animated: true)
                    if self.reactionScrollIdx >= reactionMsg.count {
                        self.btnDownArrow.isHidden = true
                    }
                }
                else {
                    self.scrollToBottom()
                    self.btnDownArrow.isHidden = true
                }
            }
            
        }
        .disposed(by: disposeBag)
        btnPin.rx.tap.bind { _ in
            print("Click Pin ...")
            
        }
        .disposed(by: disposeBag)
        
        btnSend.rx.tap.bind { _ in
            if let text = self.txtMessage.text {
                var type : MessageType = .image
                if !self.selectedImageStr.isEmpty {
                    type = .image
                }
                else if !self.selectedStickerString.isEmpty {
                    type = .sticker
                }
                else {
                    type = .text
                }
                
                let message = Message(messageText: text, messageImage: self.selectedImageStr, messageType: type, createdAt: "", lastMessage: "", senderId: self.currentUser?.id ?? "" , sticker: self.selectedStickerString , senderName: self.currentUser?.name)
                self.chatRoomViewModel.sendMessage(message: message)
                self.txtMessage.text = ""
                self.selectedStickerString = ""
                self.selectedSticker = UIImage()
                self.bottomViewHeight.constant = 120.0
                self.btnClose.isHidden = true
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
            self.filterMessageList = self.messageList
            self.btnDownArrow.isHidden = self.messageList.count < 7
            self.lblInfo.isHidden = !self.messageList.isEmpty
            self.tblMessage.isHidden = self.messageList.isEmpty
            self.tblMessage.reloadData()
            
            let reaction = self.messageList.filter({!($0.reaction ?? "").isEmpty})
            if !reaction.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.scrollToBottom()
                })
            }
            
            let pinnedMessages = self.messageList.filter{ $0.isPinned == true }
            if pinnedMessages.isEmpty {
                self.pinnedView.isHidden = true
            }else{
                self.pinnedMessageList = pinnedMessages
                self.pinnedMessageShow(isHidden: false)
            }
            
            
        }
        .disposed(by: disposeBag)
        
        btnClose.rx.tap.bind { _ in
            self.setTextMode()
        }
        .disposed(by: disposeBag)
        
        chatRoomViewModel.selectedMoreSetting.bind { type in
            
            switch type {
            case .notiMuteOneDay , .notiMuteOneWeek , .notiMuteOneMonth , .notiMutePermanently:
                self.chatRoomViewModel.savedNotiSetting(settingType: type)
            case .notiMuteCustom:
                let vc = DateTimePickerViewController()
                vc.viewModel = self.chatRoomViewModel
                self.navigationController?.present(vc, animated: true)
            default :
                break
                
            }
            self.morePopupView.reloadView()
            self.morePopupView.dismiss()
        }
        .disposed(by: disposeBag)
        
        btnSticker.rx.tap.bind { _ in
            self.isShowStickerView.toggle()
            self.bottomViewHeight.constant = self.isShowStickerView ? 250 : 120
        }
        .disposed(by: disposeBag)
        
        chatRoomViewModel.selectedSticker.bind {
            self.selectedStickerString = $0.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
            self.selectedSticker = $0
            self.stickerCollectionView.reloadData()
        }
        .disposed(by: disposeBag)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        self.morePopupView.bindViewModel(viewModel: chatRoomViewModel)
    }
    
    func scrollToBottom()  {
        let point = CGPoint(x: 0, y: self.tblMessage.contentSize.height + self.tblMessage.contentInset.bottom - self.tblMessage.frame.height)
        if point.y >= 0{
            self.tblMessage.setContentOffset(point, animated: true)
        }
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
    
    private func setupCollectionView() {
        stickerCollectionView.register(cell: StickerCollectionViewCell.self)
        stickerCollectionView.backgroundColor = .clear
        stickerCollectionView.delegate = self
        stickerCollectionView.dataSource = self
        stickerCollectionView.reloadData()
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
        navigationItem.rightBarButtonItems = [moreBtn, searchBtn]
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }
    
    @objc func searchAction() {
        search(shouldShow: true)
    }
    
    @objc func moreAction() {
        isShowMorePopup.toggle()
        showMoreView(isShow: isShowMorePopup)
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showSearchBarButton(shouldShow: Bool) {
        if shouldShow {
            self.setNavigationBar()
        } else {
            navigationItem.rightBarButtonItems = nil
            navigationItem.leftBarButtonItems = nil
            navigationItem.hidesBackButton = true
        }
    }
    
    private func search(shouldShow: Bool) {
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
    }
    
    private func chooseImage(sourceType : UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    private func showMoreView(isShow : Bool) {
        if isShow {
            morePopupView.present()
        }
        else {
            morePopupView.dismiss()
        }
    }
    
    private func updateMessage(msg : Message) {
        self.chatRoomViewModel.updateMessage(message: msg)
    }
    
    private func pinnedMessageShow(isHidden : Bool){
        
        self.pinnedView.isHidden = isHidden
        
        if let lastPinMessage = self.pinnedMessageList.first{
            if (lastPinMessage.messageType ?? .text) == .text {
                self.imgPinThumb.isHidden = true
                self.lblPinMessage.text = lastPinMessage.messageText
            }else{
                
                self.imgPinThumb.isHidden = false
                self.lblPinMessage.text = "Photo"
                
            }
        } else {
            self.pinnedView.isHidden = true
        }
        
    }
    func updateSearchResults(text: String?) {
        guard let searchText = text else { return }
        filterMessageList = messageList.filter { message in
            return message.messageText?.contains(searchText) ?? false
        }
        isFilter = true
        tblMessage.reloadData()
    }
}

extension ChatRoomViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterMessageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var message = self.filterMessageList[indexPath.row]
        
        /// note : Text message
        if (message.messageType ?? .text) == .text {
            if (message.senderId ?? "") == (self.currentUser?.id ?? "") {
                let senderCell = tableView.deque(SendMessageTableViewCell.self)
                senderCell.setupCellData(message: message, isFilter: isFilter)
                senderCell.didTapReaction = { [weak self] in
                    self?.presentReactionPopup(cell: senderCell, selectedReaction: { [weak self] reaction in
                        senderCell.reactionLabel.text = reaction
                        message.reaction = reaction
                        self?.updateMessage(msg: message)
                    }, forwardMessage: {
                        let forwardVC = ForwardViewController()
                        forwardVC.currentUser = self?.currentUser
                        forwardVC.selectedessage = message
                        forwardVC.modalPresentationStyle = .pageSheet
                        self?.present(forwardVC, animated: true)
                    }, isPinned: message.isPinned ?? false, pinnedMessage: {
                        if let pinned = message.isPinned {
                            message.isPinned = !pinned
                            
                        }else{
                            message.isPinned = true
                        }
                        
                        self?.updateMessage(msg: message)
                    })
                }
            
                return senderCell
            }
            else {
                let receiverCell = tableView.deque(ReceiveMessageTableViewCell.self)
                
                var img : UIImage = .icPlaceholder
                if let imgData = NSData(base64Encoded: self.selectedUser?.image ?? "") {
                    img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
                    
                }
                receiverCell.setupCellData(message: message , profile: img)
                receiverCell.didTapReaction = { [weak self] in
                    self?.presentReactionPopup(cell: receiverCell, selectedReaction: { [weak self] reaction in
                        receiverCell.reactionLabel.text = reaction
                        message.reaction = reaction
                        self?.updateMessage(msg: message)
                    }, forwardMessage: {
                        let forwardVC = ForwardViewController()
                        forwardVC.currentUser = self?.currentUser
                        forwardVC.selectedessage = message
                        forwardVC.modalPresentationStyle = .pageSheet
                        self?.present(forwardVC, animated: true)
                    }, isPinned: message.isPinned ?? false, pinnedMessage: {
                        if let pinned = message.isPinned {
                            message.isPinned = !pinned
                            
                        }else{
                            message.isPinned = true
                        }
                        
                        self?.updateMessage(msg: message)
                    })
                }
                return receiverCell
            }
        }
        /// note : forward message
        else if (message.messageType ?? .text) == .forward {
            if let  messageType = message.forwardMessage?["messageType"] ,
               let msgType = MessageType(rawValue: messageType) {
                switch msgType {
                case .text:
                    
                        if (message.senderId ?? "") == (self.currentUser?.id ?? "") {
                            let senderCell = tableView.deque(SendMessageTableViewCell.self)
                            senderCell.setupCellData(message: message, isFilter: isFilter)
                            senderCell.didTapReaction = { [weak self] in
                                self?.presentReactionPopup(cell: senderCell, selectedReaction: { [weak self] reaction in
                                    senderCell.reactionLabel.text = reaction
                                    message.reaction = reaction
                                    self?.updateMessage(msg: message)
                                }, forwardMessage: {
                                    let forwardVC = ForwardViewController()
                                    forwardVC.currentUser = self?.currentUser
                                    forwardVC.selectedessage = message
                                    forwardVC.modalPresentationStyle = .pageSheet
                                    self?.present(forwardVC, animated: true)
                                }, isPinned: message.isPinned ?? false, pinnedMessage: {
                                    if let pinned = message.isPinned {
                                        message.isPinned = !pinned
                                        
                                    }else{
                                        message.isPinned = true
                                    }
                                    
                                    self?.updateMessage(msg: message)
                                })
                            }
                        
                            return senderCell
                        }
                        else {
                            let receiverCell = tableView.deque(ReceiveMessageTableViewCell.self)
                            
                            var img : UIImage = .icPlaceholder
                            if let imgData = NSData(base64Encoded: self.selectedUser?.image ?? "") {
                                img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
                                
                            }
                            receiverCell.setupCellData(message: message , profile: img)
                            receiverCell.didTapReaction = { [weak self] in
                                self?.presentReactionPopup(cell: receiverCell, selectedReaction: { [weak self] reaction in
                                    receiverCell.reactionLabel.text = reaction
                                    message.reaction = reaction
                                    self?.updateMessage(msg: message)
                                }, forwardMessage: {
                                    let forwardVC = ForwardViewController()
                                    forwardVC.currentUser = self?.currentUser
                                    forwardVC.selectedessage = message
                                    forwardVC.modalPresentationStyle = .pageSheet
                                    self?.present(forwardVC, animated: true)
                                }, isPinned: message.isPinned ?? false, pinnedMessage: {
                                    if let pinned = message.isPinned {
                                        message.isPinned = !pinned
                                        
                                    }else{
                                        message.isPinned = true
                                    }
                                    
                                    self?.updateMessage(msg: message)
                                })
                            }
                            return receiverCell
                        }
                default :
                    
                        if (message.senderId ?? "") == (self.currentUser?.id ?? "") {
                            let senderCell = tableView.deque(SendImgeTableViewCell.self)
                            senderCell.setupcell(message: message)
                            senderCell.didTapReaction = { [weak self] in
                                self?.presentReactionPopup(cell: senderCell, selectedReaction: { [weak self] reaction in
                                    senderCell.reactionLabel.text = reaction
                                    message.reaction = reaction
                                    self?.updateMessage(msg: message)
                                }, forwardMessage: {
                                    let forwardVC = ForwardViewController()
                                    forwardVC.currentUser = self?.currentUser
                                    forwardVC.selectedessage = message
                                    forwardVC.modalPresentationStyle = .pageSheet
                                    self?.present(forwardVC, animated: true)
                                }, isPinned: message.isPinned ?? false, pinnedMessage: {
                                    if let pinned = message.isPinned {
                                        message.isPinned = !pinned
                                        
                                    }else{
                                        message.isPinned = true
                                    }
                                    
                                    self?.updateMessage(msg: message)
                                })
                            }
                            return senderCell
                        }
                        else {
                            let receiverCell = tableView.deque(ReceiveImageTableViewCell.self)
                            
                            var img : UIImage = .icPlaceholder
                            if let imgData = NSData(base64Encoded: self.selectedUser?.image ?? "") {
                                img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
                                
                            }
                            receiverCell.setupcell(message: message, profile: img)
                            receiverCell.didTapReaction = { [weak self] in
                                self?.presentReactionPopup(cell: receiverCell, selectedReaction: { [weak self] reaction in
                                    receiverCell.reactionLabel.text = reaction
                                    message.reaction = reaction
                                    self?.updateMessage(msg: message)
                                }, forwardMessage: {
                                    let forwardVC = ForwardViewController()
                                    forwardVC.currentUser = self?.currentUser
                                    forwardVC.selectedessage = message
                                    forwardVC.modalPresentationStyle = .pageSheet
                                    self?.present(forwardVC, animated: true)
                                }, isPinned: message.isPinned ?? false, pinnedMessage: {
                                    if let pinned = message.isPinned {
                                        message.isPinned = !pinned
                                        
                                    }else{
                                        message.isPinned = true
                                    }
                                    
                                    self?.updateMessage(msg: message)
                                })
                            }
                            return receiverCell
                        }
                    
                }
            }
        }
        /// note : image or sticker message
        else {
            if (message.senderId ?? "") == (self.currentUser?.id ?? "") {
                let senderCell = tableView.deque(SendImgeTableViewCell.self)
                senderCell.setupcell(message: message)
                senderCell.didTapReaction = { [weak self] in
                    self?.presentReactionPopup(cell: senderCell, selectedReaction: { [weak self] reaction in
                        senderCell.reactionLabel.text = reaction
                        message.reaction = reaction
                        self?.updateMessage(msg: message)
                    }, forwardMessage: {
                        let forwardVC = ForwardViewController()
                        forwardVC.currentUser = self?.currentUser
                        forwardVC.selectedessage = message
                        forwardVC.modalPresentationStyle = .pageSheet
                        self?.present(forwardVC, animated: true)
                    }, isPinned: message.isPinned ?? false, pinnedMessage: {
                        print("Pin Mess....")
                    })
                }
                return senderCell
            }
            else {
                let receiverCell = tableView.deque(ReceiveImageTableViewCell.self)
                
                var img : UIImage = .icPlaceholder
                if let imgData = NSData(base64Encoded: self.selectedUser?.image ?? "") {
                    img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
                    
                }
                receiverCell.setupcell(message: message, profile: img)
                receiverCell.didTapReaction = { [weak self] in
                    self?.presentReactionPopup(cell: receiverCell, selectedReaction: { [weak self] reaction in
                        receiverCell.reactionLabel.text = reaction
                        message.reaction = reaction
                        self?.updateMessage(msg: message)
                    }, forwardMessage: {
                        let forwardVC = ForwardViewController()
                        forwardVC.currentUser = self?.currentUser
                        forwardVC.selectedessage = message
                        forwardVC.modalPresentationStyle = .pageSheet
                        self?.present(forwardVC, animated: true)
                    }, isPinned: message.isPinned ?? false, pinnedMessage: {
                        print("Pin Mess....")
                    })
                }
                return receiverCell
            }
        }
        return UITableViewCell()
    }
}

extension ChatRoomViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {

        
        self.stickerCollectionView.isHidden = true
        
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
        photoEditor.photoEditorDelegate = self
        //Colors for drawing and Text, If not set default values will be used
        //photoEditor.colors = [.red, .blue, .green]
        
        //Stickers that the user will choose from to add on the image
        for i in 0...10 {
            photoEditor.stickers.append(UIImage(named: i.description )!)
        }
        
        
        
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            
            
            photoEditor.image = image
            
            imageView.image = image
            selectedImageStr = image.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
            bottomViewHeight.constant = 250.0
            self.btnClose.isHidden = false
            
            
        } else  {
            
            guard let url = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? URL else {
                return
            }
            let image = UIImage(contentsOfFile: url.absoluteString)
            imageView.image = image
            selectedImageStr = image?.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
            bottomViewHeight.constant = 250.0
            self.btnClose.isHidden = false
            //photoEditor.video = url
        }
        
        
        //To hide controls - array of enum control
        //photoEditor.hiddenControls = [.crop, .draw, .share]
        photoEditor.modalPresentationStyle = UIModalPresentationStyle.currentContext //or .overFullScreen for transparency
        
        
        
        picker.dismiss(animated: true) {
            self.bottomViewHeight.constant = 250.0
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(0.2))) {
            self.present(photoEditor, animated: true, completion: nil)
        }
        
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {

        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }

}

extension ChatRoomViewController: PhotoEditorDelegate {
    func doneEditing(video: URL) {
        
        
    }
    
    
    func doneEditing(image: UIImage) {
        imageView.image = image
        selectedImageStr = image.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
        bottomViewHeight.constant = 250.0
        self.btnClose.isHidden = false
    }
    
    func canceledEditing() {
        print("Canceled")
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


// MARK: - UICollectionView Delegate & Datasource
extension ChatRoomViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width/3 - 5
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stickerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(StickerCollectionViewCell.self, index: indexPath) 
        cell.setupCell(stickerImage: stickerList[indexPath.item] , selectedSticker : chatRoomViewModel.selectedSticker.value)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        chatRoomViewModel.selectedSticker.accept(stickerList[indexPath.item])
    }
    
    
}

extension ChatRoomViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.search(shouldShow: false)
        searchBar.endEditing(true)
        searchBar.text = ""
        filterMessageList = messageList
        isFilter = false
        tblMessage.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateSearchResults(text: searchText)
    }
    
}

