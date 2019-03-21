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
    
    var products: [ProductClass] = [] {
        didSet{
            //when collections are added reload the table view on the main thread
            DispatchQueue.main.async {
                self.detailsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailsTableView.delegate = self
        self.detailsTableView.dataSource = self
        
        
        self.collectionTitle.text = collectionObject?.title ?? ""
        self.collectionBody.text = collectionObject?.body ?? ""
        
        if let url = collectionObject?.src {
            downloadImage(url: url) { (data) in
                self.collectionImage.image = UIImage(data: data)
            }
        }
        guard let id = collectionObject?.id else {
            return
        }
        getCollects(collection_id: id) { (response) in
            guard let response = response else {
                return
            }
            
            let collects = (parseCollects(data: response))
            print (collects)
            
            getProducts(productIds: collects, success: { (response) in
                guard let response = response else {
                    return
                }

                self.products = (parseProducts(data: response))
                print (self.products)
            })
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        guard let headerView = detailsTableView.tableHeaderView else {
            return
        }
        let size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            detailsTableView.tableHeaderView = headerView
            detailsTableView.layoutIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 400
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "productCell") as! CollectionDetailsTableViewCell
        cell.productName.text = products[indexPath.row].title
        cell.productStock.text = String(products[indexPath.row].inventory ?? 0)
        cell.productImage.image = self.collectionImage.image
        
        return cell
    }
    
    
}
