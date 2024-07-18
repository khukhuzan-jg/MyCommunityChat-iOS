//
//  ChatRoomViewController+CollectionView.swift
//  MyCommunityChat-iOS
//
//  Created by kukuzan on 18/07/2024.
//

import UIKit

extension ChatRoomViewController {
    func setupCollectionView() {
        stickerCollectionView.register(cell: StickerCollectionViewCell.self)
        stickerCollectionView.backgroundColor = .clear
        stickerCollectionView.delegate = self
        stickerCollectionView.dataSource = self
        stickerCollectionView.reloadData()
    }
    
}

// MARK: - UICollectionView Delegate & Datasource
extension ChatRoomViewController: UICollectionViewDelegate , UICollectionViewDataSource {
    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return stickerList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.deque(
            StickerCollectionViewCell.self,
            index: indexPath
        )
        cell.setupCell(
            stickerImage: stickerList[indexPath.item] ,
            selectedSticker : chatRoomViewModel.selectedSticker.value
        )
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        chatRoomViewModel.selectedSticker.accept(stickerList[indexPath.item])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ChatRoomViewController: UICollectionViewDelegateFlowLayout {
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
