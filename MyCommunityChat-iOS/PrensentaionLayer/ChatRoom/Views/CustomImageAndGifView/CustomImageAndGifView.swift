//
//  CustomImageAndGifView.swift
//  MyCommunityChat-iOS
//
//  Created by kukuzan on 03/08/2024.
//

import UIKit
import CommonUI
import CommonExtension
import SwiftGifOrigin

class CustomImageAndGifView: NibBasedView {
    
    @IBOutlet weak var gifButton: UIButton!
    @IBOutlet weak var stickerButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let stickerList : [UIImage] = [.sticker1 , .sticker2 , .sticker3 , .sticker4 , .sticker5 , .sticker6]
    let gifStringList: [String] = [
        "gif-1",
        "gif-2",
        "gif-3",
        "gif-4",
        "gif-5",
        "gif-6",
    ]
    var isStickerSelected: Bool = true
    let chatRoomViewModel = ChatRoomViewModel.shared
    var selectedGifIndex: IndexPath?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        updateUIButton(flag: true)
    }
    
    private func setupUI() {
        setupCollectionView()
        stickerButton |> setButtonFontStyle(.RoboB14)
        gifButton |> setButtonFontStyle(.RoboB14)
    }
    
    private func setupCollectionView() {
        collectionView.register(cell: StickerCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = false
        collectionView.reloadData()
    }
    
    private func updateUIButton(flag: Bool) {
        isStickerSelected = flag
        UIView.animate(withDuration: 0.3) { [weak self] in
            if flag {
                self?.stickerButton.backgroundColor = .senderChat
                self?.gifButton.backgroundColor = .clear
            } else {
                self?.stickerButton.backgroundColor = .clear
                self?.gifButton.backgroundColor = .senderChat
            }
        }
        // Reload only the visible cells
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        collectionView.reloadItems(at: visibleIndexPaths)
    }
    
    @IBAction
    private func didTapSticker(_ sender: UIButton) {
        updateUIButton(flag: true)
    }
    
    @IBAction func didTapGIF(_ sender: UIButton) {
        updateUIButton(flag: false)
    }
    
}

// MARK: - UICollectionView Delegate & Datasource
extension CustomImageAndGifView: UICollectionViewDelegate , UICollectionViewDataSource {
    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return isStickerSelected ? stickerList.count : gifStringList.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.deque(
            StickerCollectionViewCell.self,
            index: indexPath
        )

        if isStickerSelected {
            let stickerImage = stickerList[indexPath.item]
            cell.setupCell(
                stickerImage: stickerImage,
                selectedSticker: chatRoomViewModel.selectedSticker.value,
                isSticker: true
            )
        } else {
            let gifImage = gifStringList[indexPath.item]
            cell.setupCell(
                gifImageString: gifImage,
                selectedGif: chatRoomViewModel.selectedGif.value,
                isSticker: false
            )
        }
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        if isStickerSelected {
            chatRoomViewModel.selectedSticker.accept(stickerList[indexPath.item])
        } else {
            chatRoomViewModel.selectedGif.accept(gifStringList[indexPath.item])
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CustomImageAndGifView: UICollectionViewDelegateFlowLayout {
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
