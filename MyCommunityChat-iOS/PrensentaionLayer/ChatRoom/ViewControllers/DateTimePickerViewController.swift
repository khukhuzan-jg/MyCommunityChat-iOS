//
//  DateTimePickerViewController.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 12/07/2024.
//

import UIKit

class DateTimePickerViewController: BaseViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    var viewModel : ChatRoomViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func setupUI() {
        super.setupUI()
        
        lblTitle.text = "Please choose date and time"
        lblTitle.font = .RoboB18
        
        lblStartDate.text = "Start date"
        lblStartDate.font = .RoboB12
        lblStartDate.textColor = .lightGray
        
        lblEndDate.text = "End date"
        lblEndDate.font = .RoboB12
        lblEndDate.textColor = .lightGray
        
        btnSave.setTitle("Save", for: .normal)
        btnSave.titleLabel?.font = .RoboB16
        btnSave.setTitleColor(.white, for: .normal)
        
        startDatePicker.minimumDate = Date()
        
        viewModel?.startDateBehaviorRelay.accept(startDatePicker.date.toString(.type12))
        viewModel?.endDateBehaviorRelay.accept(endDatePicker.date.toString(.type12))
    }
    
    override func bindData() {
       
        viewModel?.isActiveSaveButtonBehaviorRelay.bind(onNext: {
            self.btnSave.alpha = $0 ? 1.0 : 0.5
            self.btnSave.isUserInteractionEnabled = $0
        })
        .disposed(by: disposeBag)
        
        btnSave.rx.tap.bind { _ in
            self.viewModel?.savedNotiSetting(settingType: .notiMuteCustom)
        }
        .disposed(by: disposeBag)
        
        startDatePicker.rx.date.bind { date in
            self.endDatePicker.minimumDate = self.startDatePicker.date
            self.viewModel?.startDateBehaviorRelay.accept(date.toString(.type12))
        }
        .disposed(by: disposeBag)
        
        endDatePicker.rx.date.bind { date in
            self.viewModel?.endDateBehaviorRelay.accept(date.toString(.type12))
        }
        .disposed(by: disposeBag)
        
        viewModel?.isSuccessfullySavedBehaviorRelay.bind(onNext: { isSuccess in
            if isSuccess {
                self.dismissVC()
            }
        })
        .disposed(by: disposeBag)
    }
}
