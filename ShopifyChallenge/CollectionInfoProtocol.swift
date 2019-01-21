//
//  CollectionInfoProtocol.swift
//  ShopifyChallenge
//
//  Created by Adel Araji on 2019-01-15.
//  Copyright © 2019 Adel Araji. All rights reserved.
//

import Foundation

//Protocol to share the collection title and id between the 2 view controllers
protocol CollectionInfoProtocol {
    func didReceiveCollectionInfo(collectionName: String, id: Int)
}
