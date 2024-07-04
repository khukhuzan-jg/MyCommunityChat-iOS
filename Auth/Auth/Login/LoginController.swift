//
//  LoginController.swift
//  Auth
//
//  Created by kukuzan on 03/07/2024.
//

import UIKit
import CommonExtension
import CommonUI
import Domain
import Combine

public class LoginController: UIViewController {
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var phoneNumberView: UIView!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    public init() {
        super.init(nibName: "LoginController", bundle: .authBundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isContinueButtonEnabled: Bool = false {
        didSet {
            continueButton |> setMainButtonStyle(isEnabled: isContinueButtonEnabled ? true : false)
        }
    }
    private var viewModel = LoginVM()
    private var cancellables = Set<AnyCancellable>()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        navigationController?.isNavigationBarHidden = true
        phoneNumberLabel |> setLabelFontStyle(.RoboR16)
        codeLabel |> setLabelFontStyle(.RoboR18)
        phoneNumberTextField |> setTextFieldTextFont(.RoboR18)
        codeView |> borderStyle(.secondaryYellow, 2, 8)
        phoneNumberView |> borderStyle(.secondaryYellow, 2, 8)
        continueButton |> setMainButtonStyle(isEnabled: false)
        phoneNumberTextField.delegate = self
        phoneNumberTextField.addTarget(self, action: #selector(onValidate), for: .editingChanged)
    }

    @objc func onValidate() {
        guard let phoneNumber = phoneNumberTextField.text,
              !phoneNumber.isEmpty,
              phoneNumber.isValidPhoneNumber()
        else {
            isContinueButtonEnabled = false
            return
        }
       
        return isContinueButtonEnabled = true
    }
    
    private func bindAuth() {
        onValidate()
        let number = "+95\(phoneNumberTextField.text ?? "")"
        viewModel.transform(number) { [weak self] success in
            if success {
                self?.navigateToOTP(phoneNumber: number)
            }
        }
    }
    
    @IBAction
    private func didTapContinue(_ sender: UIButton) {
       bindAuth()
    }
    
    private func navigateToOTP(phoneNumber: String) {
        let otpVC = OTPController(phoneNumber: phoneNumber)
        navigationController?.pushViewController(otpVC, animated: true)
    }
}

extension LoginController: UITextFieldDelegate {
    public func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        phoneNumberTextField.resignFirstResponder()
        return true
    }
}
