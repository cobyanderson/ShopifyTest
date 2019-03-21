//
//  CollectionDetailsViewController.swift
//  test
//
//  Created by Samuel Coby Anderson on 3/19/19.
//  Copyright © 2019 Samuel Coby Anderson. All rights reserved.
//

import UIKit

class CollectionDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet weak var collectionImage: UIImageView!
    @IBOutlet weak var collectionTitle: UILabel!
    @IBOutlet weak var collectionBody: UILabel!
    
    var collectionObject: CollectionClass?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionTitle.text = collectionObject?.title ?? ""
        self.collectionBody.text = collectionObject?.body ?? ""
        
        if let url = collectionObject?.src {
            downloadImage(url: url) { (data) in
                self.collectionImage.image = UIImage(data: data)
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
