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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CollectionsTableView.delegate = self
        self.CollectionsTableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    

}

