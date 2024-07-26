//
//  ImageLayoutViewController.swift
//  MyCommunityChat-iOS
//
//  Created by Phyo Kyaw Swar on 25/07/2024.
//

import UIKit

class ImageLayoutViewController: UIViewController {

    var images : [UIImage] = [.image1 , .image2 , .image3 , .image4 , .image5 , .image6 , .image7 , .image8 , .image9 , .image10]
    
    @IBOutlet weak var tblImage: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupTableView()
    }
    
    private func setupTableView() {
//        tblImage.register(UINib(nibName: String(describing: ImageLayoutTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ImageLayoutTableViewCell.self))
        tblImage.register(ImageStackLayoutTableViewCell.self)
        tblImage.delegate = self
        tblImage.dataSource = self
        tblImage.reloadData()
    }

}

extension ImageLayoutViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.deque(ImageStackLayoutTableViewCell.self)
        cell.setupCell(images: self.images, text: "Testing text :::::: :D :D :D \(indexPath.row)")
        return cell
    }
    
}
