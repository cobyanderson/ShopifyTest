//
//  ShopifyFetcher.swift
//  test
//
//  Created by Samuel Coby Anderson on 3/19/19.
//  Copyright © 2019 Samuel Coby Anderson. All rights reserved.
//

import Foundation
import UIKit

public func getCollections(success: @escaping ((NSDictionary?) -> Void)) {
    
    let formattedUrl = URL(string: "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")
    
    let session = URLSession.shared
    let request = URLRequest(url: formattedUrl!)
    
    session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
        
        guard error == nil else {
            print ("Error getting collections")
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.init(rawValue: 0))
            success(json as! NSDictionary)
        } catch {
            print ("Error converting collections data")
        }
        
    }).resume()
}

public func getCollects(collection_id: String, success: @escaping ((NSDictionary?) -> Void)) {
    
    let formattedUrl = URL(string: "https://shopicruit.myshopify.com/admin/collects.json?collection_id=\(collection_id)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")
    
    let session = URLSession.shared
    let request = URLRequest(url: formattedUrl!)
    
    session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
        
        guard error == nil else {
            print ("Error getting collects")
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.init(rawValue: 0))
            success(json as! NSDictionary)
        } catch {
            print ("Error converting collects data")
        }
        
    }).resume()
}

public func getProducts(productIds: [String], success: @escaping ((NSDictionary?) -> Void)) {
    
    var formattedString = ""
    for id in productIds {
        formattedString = formattedString + id + ","
    }
    
    let formattedUrl = URL(string: "https://shopicruit.myshopify.com/admin/products.json?ids=\(formattedString)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")
    
    let session = URLSession.shared
    let request = URLRequest(url: formattedUrl!)
    
    session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
        
        guard error == nil else {
            print ("Error getting products")
            return
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.init(rawValue: 0))
            success(json as! NSDictionary)
        } catch {
            print ("Error converting product data")
        }
        
    }).resume()
}


    
public func parseCollections(data: NSDictionary) -> ([CollectionClass]) {
    var collectionObjects: [CollectionClass] = []
    
    guard let collections = data["custom_collections"] as? [Any] else {
        print ("error")
        return collectionObjects
    }
    for collection in collections {
        guard let collection = collection as? [String: Any] else {
            print ("error converting collections")
            return collectionObjects
        }
        let collectionInstance = CollectionClass()
        collectionInstance.body = collection["body_html"] as? String
        collectionInstance.id = String(collection["id"] as? Int ?? 0)
        collectionInstance.title = (collection["title"] as? String ?? "").capitalized
        
        if let image_data = collection["image"] as? [String: Any] {
            if let image_url = image_data["src"] as? String {
                collectionInstance.src = image_url
            }
        }
        
        collectionObjects.append(collectionInstance)
    }
    return collectionObjects
    
}

public func parseCollects(data: NSDictionary) -> ([String]) {
    var productIds: [String] = []
    
    guard let collects = data["collects"] as? [Any] else {
        print ("error")
        return productIds
    }
    for collect in collects {
        guard let collect = collect as? [String: Any] else {
            print ("error converting collects")
            return productIds
        }
        if let productId = collect["product_id"] as? Int {
            productIds.append(String(productId))
        }
    }
    return productIds
    
}

public func parseProducts(data: NSDictionary) -> ([ProductClass]) {
    var productObjects: [ProductClass] = []
    
    guard let products = data["products"] as? [Any] else {
        print ("error parsing products")
        return productObjects
    }
    for product in products {
        if let product = product as? [String: Any] {
            
            var productObject = ProductClass()
            
            if let title = product["title"] as? String {
                productObject.title = title
            }
            
            if let variants = product["variants"] as? [[String : Any]] {
                var totalInventory = 0
                for variant in variants {
                    if let inventory = variant["inventory_quantity"] as? Int {
                        totalInventory += inventory
                    }
                }
                productObject.inventory = totalInventory
                
            }
            
            if let image = product["image"] as? [String : Any] {
                if let src = image["src"] as? String {
                    productObject.src = src
                }
            }
            productObjects.append(productObject)
            
        }
    }
    return productObjects
    
}




public func downloadImage(url: String, success: @escaping (Data) -> Void)  {
    
    let formattedUrl = URL(string: url)
    let session = URLSession.shared
    let request = URLRequest(url: formattedUrl!)
    
    session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
        
        guard let data = data else {
            return
        }
        success(data)
        
    }).resume()

}

