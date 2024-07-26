//
//  HomeViewController.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 03/07/2024.
//

import Foundation
import UIKit
import Auth

class HomeViewController : BaseViewController {
    
    @IBOutlet weak var tblUsers: UITableView!
    @IBOutlet weak var lblWelcome: UILabel!
    
    var homeViewModel = HomeViewModel()
    
    var userList = [UserData]()
    var currentUser : UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        print("Current user in home \(userManager.currentUser)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblWelcome.text = "Welcome From Our Community!"
        lblWelcome.font = .RoboB15
        lblWelcome.textColor = .darkGray
    }
    
    override func bindData() {
        super.bindData()
        
        homeViewModel.userList.bind {
            if let users = $0 ,
               !users.isEmpty {
                self.userList = users.filter({$0.id != UIDevice.current.identifierForVendor?.uuidString ?? ""})
            }
            self.tblUsers.isHidden = self.userList.isEmpty
            self.lblWelcome.isHidden = !self.userList.isEmpty
            self.tblUsers.reloadData()
        }
        .disposed(by: disposeBag)
        
        homeViewModel.currentUser.bind {
            self.currentUser = $0
            self.setupNavigation()
        }
        .disposed(by: disposeBag)
        
        homeViewModel.isSuccessfullyLogout.bind { isSuccess in
            if isSuccess {
                self.userManager.isAlreadyLogin = false
                self.userManager.completionSaved(false)
                let sceneDelegate = UIApplication.shared.connectedScenes
                    .first!.delegate as! SceneDelegate
                let splashVC = SplashController()
                let splashNav = UINavigationController(rootViewController: splashVC)
                sceneDelegate.window!.rootViewController = splashNav
            }
            
        }
        .disposed(by: disposeBag)
    }
    
    override func bindObserver() {
        super.bindObserver()
    }
    
    private func setupNavigation() {
        var img : UIImage = .icDemo6
        if let imgData = NSData(base64Encoded: self.currentUser?.image ?? "") {
            img = UIImage(data: Data(referencing: imgData)) ?? UIImage()
            
        }
        
        // Create a custom profile view
        let profileView = ProfileView(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        profileView.setupData(image: img, name: self.currentUser?.name ?? "")
        // Wrap it in a UIBarButtonItem
        let profileBarButtonItem = UIBarButtonItem(customView: profileView)
        
        // Set it as the left or right bar button item based on your needs
        navigationItem.leftBarButtonItem = profileBarButtonItem
        
        
        let logout = UIBarButtonItem(image: .icLogout.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.logout))
        
        navigationItem.rightBarButtonItem = logout
        
    }
    
    @objc func logout() {
        print("Tap logout")
        setupLogoutAlert()
    }
    private func setupTableView() {
        tblUsers.register(UINib(nibName: String(describing: UserTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserTableViewCell.self))
        tblUsers.delegate = self
        tblUsers.dataSource = self
        tblUsers.separatorStyle = .none
        tblUsers.reloadData()
    }
    
    private func setupLogoutAlert() {
        let alert = UIAlertController(title: "Information", message: "Are you sure to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
            self.homeViewModel.logoutUser(userId: self.currentUser?.id ?? "")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserTableViewCell.self), for: indexPath) as? UserTableViewCell else {return UITableViewCell()}
        cell.setupData(user: userList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let controller = ChatRoomViewController()
//        controller.currentUser = self.currentUser
//        controller.selectedUser = self.userList[indexPath.row]
//        self.navigationController?.pushViewController(controller, animated: true)
        
        let controller = ImageLayoutViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


