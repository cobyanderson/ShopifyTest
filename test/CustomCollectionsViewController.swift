//
//  ViewController.swift
//  test
//
//  Created by Samuel Coby Anderson on 2/23/19.
//  Copyright © 2019 Samuel Coby Anderson. All rights reserved.
//

import UIKit

class CustomCollectionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var CollectionsTableView: UITableView!
    
    var collections: [CollectionClass] = [] {
        didSet{
            //when collections are added reload the table view on the main thread
            DispatchQueue.main.async {
                self.CollectionsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CollectionsTableView.delegate = self
        self.CollectionsTableView.dataSource = self
        
        getCollections { (response) in
            guard let response = response else {
                return
            }
            self.collections = parseCollections(data: response)
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.CollectionsTableView.dequeueReusableCell(withIdentifier: "collectionCell") as! CustomCollectionTableViewCell
        cell.collectionTitle.text = collections[indexPath.row].title ?? ""
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionSegue" {
            guard let controller = segue.destination as? CollectionDetailsViewController else {
                return
            }
            guard let index = self.CollectionsTableView.indexPathForSelectedRow?.row else {
                return
            }
            controller.collectionObject = collections[index]
            
        }
    }
    

}

