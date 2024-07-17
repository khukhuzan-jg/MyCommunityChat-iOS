//
//  ForwardViewController.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 16/07/2024.
//

import UIKit

class ForwardViewController: BaseViewController {
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tblUser: UITableView!
    
    var viewModel = ForwardViewModel()
    var userList = [UserData]()
    var selectedUser : UserData?
    var currentUser : UserData?
    var isSelectedEnable = false
    var selectedessage = Message()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.getAllUsers()
    }
    
    override func setupUI() {
        super.setupUI()
        self.setupTableView()
        self.btnSelect.isHidden = true
        
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.titleLabel?.font = .RoboB14
        
        btnSelect.setTitle("Send", for: .normal)
        btnSelect.titleLabel?.font = .RoboB14
    }
    
    
    override func bindData() {
        super.bindData()
        
        viewModel.currentUser.accept(currentUser)
        
        
        viewModel.userListBehaviorRelay.bind { users in
            self.userList = users ?? []
            self.tblUser.reloadData()
        }
        .disposed(by: disposeBag)
        
        btnCancel.rx.tap.bind { _ in
            self.dismissVC()
        }
        .disposed(by: disposeBag)
        
        viewModel.selectedUser.bind {
            if let user = $0 {
                self.btnSelect.isHidden = false
            }
            else {
                self.btnSelect.isHidden = true
            }
        }
        .disposed(by: disposeBag)
        
        btnSelect.rx.tap.bind { _ in
            self.viewModel.createForwardMessage(message: self.selectedessage) { message in
                self.viewModel.sendMessage(message: message)
            }
        }
        .disposed(by: disposeBag)
        
        viewModel.successfullySendMessage.bind { _ in
            self.dismissVC()
        }
        .disposed(by: disposeBag)
    }

    
    private func setupTableView() {
        tblUser.register(UINib(nibName: String(describing: ForwardTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ForwardTableViewCell.self))
        tblUser.separatorStyle = .none
        tblUser.delegate = self
        tblUser.dataSource = self
        tblUser.reloadData()
    }

}

extension ForwardViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.deque(ForwardTableViewCell.self)
        
        cell.setupCell(user: self.userList[indexPath.row] , selectedUser: self.selectedUser , isSelectEnable: self.isSelectedEnable)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.selectedUser.accept(self.userList[indexPath.row])
    }
}
