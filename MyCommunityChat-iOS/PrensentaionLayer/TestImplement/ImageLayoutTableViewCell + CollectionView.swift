//
//  ImageLayoutViewController + CollectionView.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 25/07/2024.
//

import UIKit
extension ImageLayoutTableViewCell {
    func setupCollectionView() {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            
            
            
            /// for full width items
            // Define first item Size for horizontal group
            let fullWidthItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3))
            
            // Create first item for horizontal group
            let horitonzalItem = NSCollectionLayoutItem(layoutSize: fullWidthItemSize)
            
            // Configure Item
            horitonzalItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 2)
            
            // Define items Size for vertical group
            let verticalItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.3))
            
            // Create items for vertica group
            let verticalItem = NSCollectionLayoutItem(layoutSize: verticalItemSize)
            
            // Configure item
            verticalItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0)
            
            // Define Vertical Group Size
            let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.3))
            
            // Create Vertical Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitem: verticalItem, count: 2)
            
            // Define Horizontal Group Size
            let horizontalSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
            
            // Create Horizontal Group
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalSize, subitems: [horitonzalItem, verticalGroup])
            
            //Create Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            
            return section
        }
//        
//        let layout = SavedCollectionViewLayout(images: self.images)
        
        imageCollectionView.register(ImageLayoutCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ImageLayoutCollectionViewCell.self))
        imageCollectionView.setCollectionViewLayout(layout, animated: true)
        imageCollectionView.backgroundColor = .clear
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.reloadData()
    }
    
}

// MARK: - UICollectionView Delegate & Datasource
extension ImageLayoutTableViewCell: UICollectionViewDelegate , UICollectionViewDataSource {
    func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return images.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageLayoutCollectionViewCell.self), for: indexPath) as? ImageLayoutCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setupCell(image: self.images[indexPath.item])
        
        return cell
    }
    
}


//class SavedCollectionViewLayout: UICollectionViewLayout {
//    private let columnsCount = 10 // 18 type columns
//    private let numberOfColumns = CGFloat(3.0)
//    private let minimumLineSpacing: CGFloat = 2
//    private let minimumInteritemSpacing: CGFloat = 2
//    private var cache: [UICollectionViewLayoutAttributes] = []
//    private var contentHeight: CGFloat = 0
//    private var contentWidth: CGFloat {
//        guard let collectionView = collectionView else {
//            return 0
//        }
//        let insets = collectionView.contentInset
//        return collectionView.bounds.width - (insets.left + insets.right)
//    }
//    override var collectionViewContentSize: CGSize {
//        return CGSize(width: contentWidth, height: contentHeight)
//    }
//    private var columnWidth: CGFloat {
//        return contentWidth / numberOfColumns
//    }
//    
//    var images = [UIImage]()
//    
//    init(images : [UIImage]) {
//        super.init()
//        self.images = images
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func prepare() {
//        guard
//            cache.isEmpty,
//            let collectionView = collectionView
//            else {
//                return
//        }
//
//        var yOffsetNext = CGFloat(0.0)
//
//        for item in 0..<collectionView.numberOfItems(inSection: 0) {
//            let indexPath = IndexPath(item: item, section: 0)
//
//            var xOffset = CGFloat(0.0), yOffset = CGFloat(yOffsetNext)
//
//            let rowColumn = indexPath.row % columnsCount
//
//            // handle x position
//            if (rowColumn == 1) || (rowColumn == 4) || (rowColumn == 7) || (rowColumn == 13)
//                || (rowColumn == 16) {
//                xOffset = CGFloat(columnWidth)
//            } else if (rowColumn == 5) || (rowColumn == 8) || (rowColumn == 10) || (rowColumn == 11)
//                || (rowColumn == 14) || (rowColumn == 17) {
//                xOffset = CGFloat(columnWidth * 2)
//            }
//
//            // handle y position for the next column
//            if (rowColumn == 1) || (rowColumn == 2) || (rowColumn == 5) || (rowColumn == 8)
//                || (rowColumn == 10) || (rowColumn == 11) || (rowColumn == 14) || (rowColumn == 17) {
//                yOffsetNext += columnWidth + minimumLineSpacing
//            }
//
//            // handle width and height
//            let size = getSizeColumn(indexPath: indexPath)
//
//            let frame = CGRect(x: xOffset,
//                               y: yOffset,
//                               width: size.width,
//                               height: size.height)
//
//            contentHeight = max(contentHeight, frame.maxY)
//
//            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//            attributes.frame = frame
//            cache.append(attributes)
//        }
//    }
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
//
//        // Loop through the cache and look for items in the rect
//        for attributes in cache {
//            if attributes.frame.intersects(rect) {
//                visibleLayoutAttributes.append(attributes)
//            }
//        }
//        return visibleLayoutAttributes
//    }
//
//    override func layoutAttributesForItem(at indexPath: IndexPath)
//        -> UICollectionViewLayoutAttributes? {
//            return cache[indexPath.item]
//    }
//
//    func emptyCache() {
//        self.cache.removeAll()
//    }
//
//    func getSizeColumn(indexPath: IndexPath) -> CGSize {
//        
////        let rowColumn = indexPath.row % columnsCount
//        var height = CGFloat(0.0), width = CGFloat(0.0)
//        if !self.images.isEmpty {
//            let currentImage = self.images[indexPath.row]
//            let scaleImage = imageWithImage(sourceImage: currentImage, scaledToWidth: contentWidth)
//            var imageWidth = scaleImage.size.width
//            var imageHeight = scaleImage.size.height
//            
//            height = imageHeight
//            if imageWidth >= contentWidth / 2 {
//                width = contentWidth
//            }
//            else if imageWidth <= CGFloat(contentWidth / CGFloat(columnsCount)) {
//                width = (contentWidth / CGFloat(columnsCount))
//            }
//            else {
//                width = (contentWidth / CGFloat(2))
//            }
//        }
//        
//        
////        if rowColumn == 1 {
////            width = CGFloat(columnWidth * 2)
////            height = CGFloat(columnWidth * 2) + minimumLineSpacing
////        } else if (rowColumn == 5) || (rowColumn == 8) || (rowColumn == 10)
////            || (rowColumn == 11) || (rowColumn == 14) || (rowColumn == 17) {
////            width = CGFloat(columnWidth)
////            height = CGFloat(columnWidth)
////        } else if rowColumn == 9 {
////            width = CGFloat(columnWidth * 2) - minimumInteritemSpacing
////            height = CGFloat(columnWidth * 2) + minimumLineSpacing
////        } else {
////            width = CGFloat(columnWidth) - minimumInteritemSpacing
////            height = CGFloat(columnWidth)
////        }
//        return CGSize(width: width, height: height)
//    }
//    
//    func imageWithImage (sourceImage:UIImage, scaledToWidth: CGFloat) -> UIImage {
//        let oldWidth = sourceImage.size.width
//        let scaleFactor = scaledToWidth / oldWidth
//
//        let newHeight = sourceImage.size.height * scaleFactor
//        let newWidth = oldWidth * scaleFactor
//
//        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
//        sourceImage.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage!
//    }
//}
