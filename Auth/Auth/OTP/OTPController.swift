//
//  OTPController.swift
//  Auth
//
//  Created by kukuzan on 03/07/2024.
//

import UIKit
import CommonUI
import CommonExtension
import Domain
import Combine

class OTPController: UIViewController {
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var otpTextField: AEOTPTextField!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var resendOTPButton: UIButton!
 
    public init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
        super.init(nibName: "OTPController", bundle: .authBundle)
    }
    
    var isContinueButtonEnabled: Bool = false {
        didSet {
            continueButton |> setMainButtonStyle(isEnabled: isContinueButtonEnabled ? true : false)
        }
    }
    
    var phoneNumber: String
    var timer: Timer?
    var seconds = 60
    private var viewModel = OTPVM()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationController?.isNavigationBarHidden = true
        startTimer()
        desLabel |> setLabelFontStyle(.RoboR16)
        timerLabel |> setLabelFontStyle(.RoboR16)
        resendOTPButton |> setButtonTitleStyle(.RoboR16, .secondaryYellow, underline: true)
        phoneNumberLabel |> setLabelFontStyle(.RoboR15)
        let phoneNumberText = "Enter OTP Code. We have send to \(phoneNumber)"
        phoneNumberLabel.attributedText = phoneNumberText.changeSubStringFont(
            subStr: phoneNumber,
            font: .RoboR15,
            color: .secondaryYellow
        )
        setupTextField()
        continueButton |> setMainButtonStyle(isEnabled: false)
        resendOTPButton.isHidden = true
    }
    
    private func setupTextField() {
        otpTextField.otpDelegate = self
        otpTextField.otpBackgroundColor = UIColor.white
        otpTextField.otpFilledBorderColor = .secondaryYellow
        otpTextField.otpFilledBorderWidth = 2
        otpTextField.autocorrectionType = .yes
        otpTextField.textContentType = .oneTimeCode
        otpTextField.configure(with: 6)
        otpTextField.addTarget(self, action: #selector(onValidate), for: .editingChanged)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds > 0 {
            seconds -= 1
            timerLabel.text = "\(seconds) s"
        } else {
            timer?.invalidate()
            timer = nil
            timerLabel.isHidden = true
            resendOTPButton.isHidden = false
        }
    }
    
    @objc func onValidate() {
        guard let otpCode = otpTextField.text,
              !otpCode.isEmpty else {
            isContinueButtonEnabled = false
            return
        }
        return isContinueButtonEnabled = true
    }
    
    private func bindOTPAuth() {
        let smsCode = otpTextField.text ?? ""
        viewModel.transform(smsCode) { [weak self] success in
            if success {
                self?.navigateToProfile()
            }
        }
    }
    
    private func navigateToProfile() {
        let profileVC = ProfileController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @IBAction
    private func didTapContinue(_ sender: UIButton) {
        bindOTPAuth()
    }
}

extension OTPController: AEOTPTextFieldDelegate {
    func didUserFinishEnter(the code: String) {
        print(code)
    }
    
    func didUserBackEnter(the isBack: Bool) {
        print(isBack)
    }
    
    
}
