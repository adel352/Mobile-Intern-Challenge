//
//  CollectionListCell.swift
//  ShopifyChallenge
//
//  Created by Adel Araji on 2019-01-13.
//  Copyright © 2019 Adel Araji. All rights reserved.
//

import UIKit

class CollectionListCell: UITableViewCell{
    
    @IBOutlet var collectionImage: UIImageView!
    @IBOutlet var collectionName: UILabel!
    
    /*
     Function to configure the cell in the CollectionListViewController with the name and image of each collection
     */
    func configureCell(apiCall: CollectionListCall, row: Int){
        collectionName.text = apiCall.name [row] + " Collection"
        collectionImage.image = apiCall.images[row]
    }
    
    
}
