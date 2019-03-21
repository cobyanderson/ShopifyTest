//
//  ShopifyFetcher.swift
//  test
//
//  Created by Samuel Coby Anderson on 3/19/19.
//  Copyright © 2019 Samuel Coby Anderson. All rights reserved.
//

import Foundation
import UIKit

public func getCollections(success: @escaping ((_ collectionsDictionaries: NSDictionary?) -> Void)) {
    
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
        collectionInstance.id = collection["id"] as? Int
        collectionInstance.title = collection["title"] as? String
        
        if let image_data = collection["image"] as? [String: Any] {
            if let image_url = image_data["src"] as? String {
                collectionInstance.src = image_url
            }
        }
        
        collectionObjects.append(collectionInstance)
    }
    return collectionObjects
    
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

