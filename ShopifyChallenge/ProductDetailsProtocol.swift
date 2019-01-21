//
//  ProductDetailsProtocol.swift
//  ShopifyChallenge
//
//  Created by Adel Araji on 2019-01-15.
//  Copyright © 2019 Adel Araji. All rights reserved.
//

import Foundation

//Protocol to communicate between the CollectionDetailsViewController(receiver) and CollectionDetailsCall (sender) in order to reload the table once the data is received
protocol ProductDetailsProtocol {
    func didReceiveProductDetails()
}
