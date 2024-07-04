//
//  AvatarAlertView.swift
//  Auth
//
//  Created by kukuzan on 04/07/2024.
//

import UIKit
import CommonUI
import CommonExtension

class AvatarItem {
    var id: Int
    var avatar: String
    var isSelected: Bool = false
    
    init(
        id: Int,
        avatar: String,
        isSelected: Bool
    ) {
        self.id = id
        self.avatar = avatar
        self.isSelected = isSelected
    }
    
    static func dummy() -> [AvatarItem] {
        return [
            .init(id: 1, avatar: "ic-demo1", isSelected: false),
            .init(id: 2, avatar: "ic-demo2", isSelected: false),
            .init(id: 3, avatar: "ic-demo3", isSelected: false),
            .init(id: 4, avatar: "ic-demo4", isSelected: false),
            .init(id: 5, avatar: "ic-demo5", isSelected: false),
            .init(id: 6, avatar: "ic-demo6", isSelected: false),
        ]
    }
}

class AvatarAlertView: UIView, AlertContentProtocol {

    public var alertContent: UIView? { self }
    weak public var alert: AlertCancellableProtocol?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var useButton: UIButton!
    
    var onAction: ((String) -> Void)?
    var items = AvatarItem.dummy()
    private var selectedAvatar: String?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        useButton |> setMainButtonStyle(isEnabled: false)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
        collectionView.register(
            AvatarItemCell.self,
            forCellWithReuseIdentifier: "cell"
        )
    }
    
    @IBAction func didTapUse(_ sender: UIButton) {
        if let selectedAvatarString = selectedAvatar {
            onAction?(selectedAvatarString)
        }
        alert?.dismiss()
    }
    
}

extension AvatarAlertView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width/3 - 5
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        5
    }
}

extension AvatarAlertView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let selectedItem = items[indexPath.row]
        items.forEach { $0.isSelected = ($0.id == selectedItem.id) }
        selectedAvatar = selectedItem.avatar
        useButton |> setMainButtonStyle(isEnabled: true)
        collectionView.reloadData()
    }
}

extension AvatarAlertView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return items.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell", for: indexPath
        ) as? AvatarItemCell else {
            return UICollectionViewCell()
        }
        cell.render(flag: items[indexPath.row].isSelected)
        cell.avatarImage.image = UIImage(named: items[indexPath.row].avatar)
        return cell
    }
    
}

extension AlertDialog {
    public static func AvatarActionAlert(
        action: @escaping(String) -> Void = {_ in }
    ) {
        let content = AvatarAlertView.loadFromNib(bundle: .authBundle)
        content.onAction = action
        let alertDialog = AlertDialog()
        alertDialog.configure(content: content)
        alertDialog.present()
    }
}
