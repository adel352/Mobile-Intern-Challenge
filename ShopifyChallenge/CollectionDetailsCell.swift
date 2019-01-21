//
//  CollectionDetailsCell.swift
//  ShopifyChallenge
//
//  Created by Adel Araji on 2019-01-15.
//  Copyright © 2019 Adel Araji. All rights reserved.
//

import Foundation
import UIKit

class CollectionDetailsCell: UITableViewCell {
    
    @IBOutlet var productImage: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var productVendor: UILabel!
    @IBOutlet var productCollection: UILabel!
    @IBOutlet var productInventory: UILabel!
    @IBOutlet var productDescription: UILabel!

    /*
     Function to configure the cell in the CollectionLDetailsViewController with the appropriate data
     */
    func configureCell(apiCall: CollectionDetailsCall, row: Int, collectionName: String){
        var parsedName = apiCall.name[row].replacingOccurrences(of: collectionName, with: "")
        productName.text =  parsedName
        productCollection.text = "Collection: " + collectionName
        productVendor.text = "Vendor: " + apiCall.vendor[row]
        productInventory.text = "Available Inventory: " + String(apiCall.availableInventory[row])
        productDescription.text = "Description: " + apiCall.body[row]
        productImage.image = apiCall.images[row]
    }
}
