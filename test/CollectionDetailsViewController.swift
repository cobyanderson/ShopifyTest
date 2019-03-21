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
        
        
        self.collectionTitle.text = collectionObject?.title?.uppercased() ?? ""
        self.collectionBody.text = collectionObject?.body ?? ""
        
        //removes the separators by making them invisible
        self.detailsTableView.separatorColor = UIColor.clear
        
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
            
            getProducts(productIds: collects, success: { (response) in
                guard let response = response else {
                    return
                }

                self.products = parseProducts(data: response)
            })
        }
        
    }
//    func downloadImages(products: [ProductClass]) {
//        for product in products {
//            if let src = product.src {
//                downloadImage(url: src) { (data) in
//                    product.image = UIImage(data: data)
//                    self.products.append(product)
//                }
//            }
//        }
//
//    }
    
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

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "productCell") as! CollectionDetailsTableViewCell
        cell.productName.text = products[indexPath.row].title
        cell.productStock.text = String(products[indexPath.row].inventory ?? 0)
        
        // if there's no product image, use the collection image
        cell.productImage.image = self.collectionImage.image!
        if let image = products[indexPath.row].image {
            cell.productImage.image = image
        }
        else if let src = products[indexPath.row].src {
            downloadImage(url: src) { (data) in
                self.products[indexPath.row].image = UIImage(data: data)
                // save the image
                cell.productImage.image = self.products[indexPath.row].image
                // update the default image of the cell with the new one
                self.UpdateCell(i: indexPath)
            }
        }
        cell.productImage.backgroundColor = UIColor.random()
//        cell.contentView.backgroundColor = UIColor.random()
        
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        CellAnimator.animate(cell: cell)
    }
    
    func UpdateCell(i: IndexPath) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.detailsTableView.beginUpdates()
            self.detailsTableView.reloadRows(
                at: [i],
                with: .fade)
            self.detailsTableView.endUpdates()
        })
    }
  
    
    
}
