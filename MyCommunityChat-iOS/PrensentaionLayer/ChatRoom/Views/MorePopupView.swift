//
//  MorePopupView.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 11/07/2024.
//

import UIKit

class MorePopupView: BaseView {

    @IBOutlet weak var tblMore: UITableView!
    
    var chatRoomViewModel : ChatRoomViewModel?
    
    let moreTitle : [ChatRoomMoreSetting] = [.notiUnMute,  .notiMuteOneDay , .notiMuteOneWeek , .notiMuteOneMonth , .notiMutePermanently,  .notiMuteCustom , .leaveGroup]
    var selectedMoreSetting : ChatRoomMoreSetting = .notiUnMute
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupUI() {
        super.setupUI()
        tblMore.register(UINib(nibName: String(describing: MorePopupTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MorePopupTableViewCell.self))
        tblMore.separatorStyle = .none
        tblMore.delegate = self
        tblMore.dataSource = self
        tblMore.reloadData()
    }
    
    func bindViewModel(viewModel : ChatRoomViewModel) {
        self.chatRoomViewModel = viewModel
    }
    
    func present() {
        let window = UIApplication.shared.windows.filter ({ $0.isKeyWindow }).first
        frame = CGRect(x: (window?.frame.size.width ?? 0.0) - 220, y: 92, width: 220, height: 300)
        window?.addSubview(self)
        window?.makeKeyAndVisible()
    }
    
    func dismiss() {
        let window = UIApplication.shared.windows.filter ({ $0.isKeyWindow }).first
        let popupView = window?.subviews.filter { $0 is MorePopupView } ?? []
        popupView.forEach { $0.removeFromSuperview() }
    }
    
    func reloadView() {
        self.tblMore.reloadData()
    }
}

extension MorePopupView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MorePopupTableViewCell.self), for: indexPath) as? MorePopupTableViewCell else {return UITableViewCell()}
        let moreTitle = moreTitle[indexPath.row]
        cell.setupCell(title:moreTitle.getTitle(), isSelectedTitle: moreTitle == selectedMoreSetting)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedMoreSetting = moreTitle[indexPath.row]
        chatRoomViewModel?.selectedMoreSetting.accept(self.selectedMoreSetting)
    }
}
