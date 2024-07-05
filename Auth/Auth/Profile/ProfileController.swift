//
//  ProfileController.swift
//  Auth
//
//  Created by kukuzan on 03/07/2024.
//

import UIKit
import CommonUI
import CommonExtension

public class ProfileController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var infoLabel: [UILabel]!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var textFieldBorderView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    var userManager = UserManager.shared
    
    public init() {
        super.init(nibName: "ProfileController", bundle: .authBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isContinueButtonEnabled: Bool = false {
        didSet {
            continueButton |> setMainButtonStyle(isEnabled: isContinueButtonEnabled ? true : false)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }


    private func setupUI() {
        titleLabel |> setLabelFontStyle(.RoboB32)
        infoLabel.forEach {
            $0 |> setLabelFontStyle(.RoboB24)
        }
        avatarButton |> setButtonTitleStyle(.RoboB24, .secondaryYellow, underline: true)
        uploadButton |> setButtonTitleStyle(.RoboB24, .secondaryYellow, underline: true)
        nameLabel |> setLabelFontStyle(.RoboR16)
        textFieldBorderView |> borderStyle(.secondaryYellow, 2, 8)
        continueButton |> setMainButtonStyle(isEnabled: false)
        avatarImageView |> setImageBorderStyle(
            .secondaryYellow,
            radius: self.avatarImageView.frame.size.width / 2,
            width: 2
        )
        nameTextField.addTarget(self, action: #selector(onValidate), for: .editingChanged)
        avatarImageView.image = UIImage(named: "ic-placeholder")
    }
    
    @objc func onValidate() {
        guard let name = nameTextField.text,
              !name.isEmpty else {
            isContinueButtonEnabled = false
            return
        }
       
        return isContinueButtonEnabled = true
    }
    
    private func uploadImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction
    private func didTapContinue(_ sender: UIButton) {
        let user = setupUser()
        let _ = userManager.savedUser(user: user)
        userManager.completionSaved(true)
    }
    
    
    func setupUser() -> UserInfo {
        var imageStr = ""
        
        if let img = avatarImageView.image {
            imageStr = img.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
        }
        return UserInfo(name: nameTextField.text, image: imageStr, phone: "")
        
    }
    
    @IBAction
    private func didTapAvatar(_ sender: UIButton) {
        AlertDialog.AvatarActionAlert { [weak self] avatar in
            self?.avatarImageView.image = UIImage(named: avatar)
        }
    }
    
    @IBAction
    private func didTapUpload(_ sender: UIButton) {
        uploadImage()
    }
    
}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage else {
            return
        }
        
        avatarImageView.image = image
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}

