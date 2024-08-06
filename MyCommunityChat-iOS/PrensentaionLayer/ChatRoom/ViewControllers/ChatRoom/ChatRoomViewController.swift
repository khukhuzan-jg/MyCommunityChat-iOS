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
import CHIPageControl
import CommonExtension
import SwiftGifOrigin

class ChatRoomViewController: BaseViewController {
    
    @IBOutlet weak var pinPageControll: CHIPageControlAji!
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
    @IBOutlet weak var btnSticker: UIButton!
    @IBOutlet weak var btnDownArrow: UIButton!
    @IBOutlet weak var customImageAndGifView: CustomImageAndGifView!
    @IBOutlet weak var segmentBGView: UIView!
    @IBOutlet weak var conversationBGImageView: UIImageView!
    
    let chatRoomViewModel = ChatRoomViewModel.shared
    
    var messageList = [Message]()
    var filterMessageList: [Message] = []
    var selectedUser : UserData?
    var currentUser : UserData?
    var selectedImageStr = String()
    var isShowMorePopup = false
    let morePopupView = MorePopupView()
    var isShowStickerView = false
    var selectedSticker = UIImage()
    var selectedStickerString = String()
    var selectedGif = String()
    var selectedGifString = String()
    var pinnedMessageList = [Message]()
    let searchBar = UISearchBar()
    var isFilter = false
    
    var reactionScrollIdx = 0
    var pinScrollIdx = 1
    var isMessageSelectMode = false
    var selectedMessageList = [Message]()
    
    
    var segmentView = SegmentView(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initBinding()
    }
    
    private func initView() {
        setupTableView()
        setNavigationBar()
        bottomViewHeight.constant = 120.0
        self.btnClose.isHidden = true
        self.pinnedView.isHidden = true
        self.customImageAndGifView.isHidden = true
    }
    
    private func initBinding() {
        lblInfo.text = "Let's start our conversation!"
        lblInfo.font = .RoboB15
        lblInfo.textColor = .darkGray
        
        txtMessage.text = "Enter your message"
        txtMessage.textColor = UIColor.lightGray
        
        txtMessage.delegate = self
        
        let angle = CGFloat.pi/2
        pinPageControll.transform = CGAffineTransform(rotationAngle: angle)
        
        btnDownArrow.isHidden = true
        
        transparentNavigationBar()
    }
    
    override func setupUI() {
        super.setupUI()
//        let blurEffect = UIBlurEffect(style:.extraLight)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = segmentBGView.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        segmentBGView.backgroundColor = .white.alpha(0.01)
        segmentBGView.addSubview(segmentView)
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        
        segmentView.anchor(top: segmentBGView.topAnchor, leading: segmentBGView.leadingAnchor, bottom: segmentBGView.bottomAnchor, trailing: segmentBGView.trailingAnchor, padding: .zero)
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
            self.customImageAndGifView.isHidden = true
            self.imageView.isHidden = false
            self.imageBGView.isHidden = false
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.scrollToBottom()
                    })
                    self.btnDownArrow.isHidden = true
                }
            }
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.scrollToBottom()
                })
                self.btnDownArrow.isHidden = true
            }
            
        }
        .disposed(by: disposeBag)
        btnPin.rx.tap.bind { _ in
            let reactionMsg = self.messageList.filter({$0.isPinned ?? false})
            if !reactionMsg.isEmpty ,
               self.reactionScrollIdx < reactionMsg.count{
                let messageId = reactionMsg[self.reactionScrollIdx].messageId ?? ""
                if let idx = self.messageList.firstIndex(where: {$0.messageId ?? "" == messageId}) ,
                   idx < self.messageList.count {
                    self.pinScrollIdx += 1
                    self.pinPageControll.set(progress: self.pinnedMessageList.count - self.pinScrollIdx, animated: true)
                    self.tblMessage.scrollToRow(at: IndexPath(row: idx, section: 0), at: .bottom, animated: true)
                    self.btnDownArrow.isHidden = true
                    self.pinnedMessageShow(isHidden: false, isPinClick: true)
                }
                else {
                    self.scrollToBottom()
                    self.btnDownArrow.isHidden = true
                }
            }
            
        }
        .disposed(by: disposeBag)
        
        btnSend.rx.tap.bind { _ in
            if let text = self.txtMessage.text {
                var type : MessageType = .image
                if !self.selectedImageStr.isEmpty {
                    type = .image
                }
                else if !self.selectedGifString.isEmpty {
                    type = .gif
                }
                else if !self.selectedStickerString.isEmpty {
                    type = .sticker
                }
                else {
                    type = .text
                }
                
                if type == .text && (text.isEmpty || text == "Enter your message") {
                    
                    self.selectedImageStr = ""
                    self.selectedStickerString = ""
                    self.selectedSticker = UIImage()
                    self.imageBGView.isHidden = true
//                    self.stickerBGView.isHidden = true
                    self.bottomViewHeight.constant = 120.0
                    self.btnClose.isHidden = true
                    
                    return
                }
                
                let message = Message(
                    messageText: text,
                    messageImage: self.selectedImageStr,
                    messageType: type,
                    createdAt: "",
                    lastMessage: "",
                    senderId: self.currentUser?.id ?? "" ,
                    sticker: self.selectedStickerString ,
                    gif: self.selectedGifString,
                    senderName: self.currentUser?.name
                )
                self.chatRoomViewModel.sendMessage(message: message)
                if type == .text {
                    self.txtMessage.text = ""
                }
                self.selectedImageStr = ""
                self.selectedStickerString = ""
                self.selectedSticker = UIImage()
                self.selectedGifString = ""
                self.selectedGif = ""
                self.imageBGView.isHidden = true
                self.customImageAndGifView.isHidden = true
                self.bottomViewHeight.constant = 120.0
                self.btnClose.isHidden = true
            }
        }
        .disposed(by: disposeBag)
        
        chatRoomViewModel.successfullySendMessage.bind { isSuccess in
            if isSuccess {
                self.chatRoomViewModel.getMessage()
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
            
            let pinnedMessages = self.messageList.filter{ $0.isPinned == true }
            if pinnedMessages.isEmpty {
                self.pinnedView.isHidden = true
            }else{
                self.pinnedMessageList = pinnedMessages
                self.pinPageControll.numberOfPages = self.pinnedMessageList.count
                self.pinPageControll.set(progress: self.pinnedMessageList.count - 1, animated: true)
                
                self.pinnedMessageShow(isHidden: false, isPinClick: false)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                if !self.chatRoomViewModel.isUpdateBehaviorRelay.value {
                    self.scrollToBottom()
                    self.btnDownArrow.isHidden = true
                }
                
            })
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
            self.imageBGView.isHidden = true
            self.imageView.image = nil
            self.selectedImageStr = ""
            self.btnClose.isHidden = true
            self.isShowStickerView.toggle()
            UIView.animate(withDuration: 0.3) {
                if self.isShowStickerView {
                    self.customImageAndGifView.isHidden = false
                    self.customImageAndGifView.collectionView.reloadData()
                } else {
                    self.customImageAndGifView.isHidden = true
                }
            }
        }
        .disposed(by: disposeBag)
        
        chatRoomViewModel.selectedSticker.bind { [weak self] selectedSticker in
            self?.selectedStickerString = selectedSticker.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
            self?.selectedSticker = selectedSticker
            self?.customImageAndGifView.collectionView.reloadData()
        }
        .disposed(by: disposeBag)

        chatRoomViewModel.selectedGif.bind { [weak self] selectedGif in
            self?.selectedGifString = selectedGif
            self?.selectedGif = selectedGif
            UIView.performWithoutAnimation {
                self?.customImageAndGifView.collectionView.reloadData()
            }
        }
        .disposed(by: disposeBag)
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        self.morePopupView.bindViewModel(viewModel: chatRoomViewModel)
    }
    
    func scrollToBottom()  {
        let row = self.tblMessage.numberOfRows(inSection: 0)
        if row > 1 {
            self.tblMessage.scrollToBottom(isAnimated: true)
        }
    }
    
    private func setTextMode() {
        self.bottomViewHeight.constant = 120.0
        self.imageView.image = nil
        self.selectedImageStr = ""
        self.btnClose.isHidden = true
    }
    
    private func showBottomSheet() {
        let alert = UIAlertController(title: "Choose image", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.chooseImage(sourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.chooseImage(sourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
            self.imageView.isHidden = true
            self.imageBGView.isHidden = true
            self.bottomViewHeight.constant = 120
        }))
        
        self.navigationController?.present(alert, animated: true)
    }
    
    
    
    @objc func doneAction() {
        self.selectedMessageList.removeAll()
        self.chatRoomViewModel.selectedMessagesBehaviorRelay.accept(self.selectedMessageList)
        self.isMessageSelectMode = false
        self.tblMessage.reloadData()
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
    
    private func pinnedMessageShow(isHidden : Bool, isPinClick : Bool){
        
        self.pinnedView.isHidden = isHidden
        
        if isPinClick {
            if pinnedMessageList.count > (pinScrollIdx - 1){
                let lastPinMessage = pinnedMessageList[pinScrollIdx - 1]
                if (lastPinMessage.messageType ?? .text) == .text {
                    self.imgPinThumb.isHidden = true
                    self.lblPinMessage.text = lastPinMessage.messageText
                }else{
                    
                    self.imgPinThumb.isHidden = false
                    self.lblPinMessage.text = "Photo"
                    
                    if let imgData = NSData(base64Encoded: lastPinMessage.messageImage ?? "") {
                        let img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
                        self.imgPinThumb.image = img
                        self.imgPinThumb.contentMode = .scaleAspectFill
                    }
                }
            }
        }else{
            if let lastPinMessage = self.pinnedMessageList.first{
                if (lastPinMessage.messageType ?? .text) == .text {
                    self.imgPinThumb.isHidden = true
                    self.lblPinMessage.text = lastPinMessage.messageText
                }else{
                    
                    self.imgPinThumb.isHidden = false
                    self.lblPinMessage.text = "Photo"
                    
                    if let imgData = NSData(base64Encoded: lastPinMessage.messageImage ?? "") {
                        let img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
                        self.imgPinThumb.image = img
                        self.imgPinThumb.contentMode = .scaleAspectFill
                    }
                    
                }
            } else {
                self.pinnedView.isHidden = true
            }
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

extension ChatRoomViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        
        
        self.customImageAndGifView.isHidden = true
        
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // Change search text color
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .white
        }
        
        // Change cancel button color
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitleColor(.white, for: .normal)
        }
    }
}

