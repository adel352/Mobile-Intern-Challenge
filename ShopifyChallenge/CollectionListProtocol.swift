//
//  CollectionListProtocol.swift
//  ShopifyChallenge
//
//  Created by Adel Araji on 2019-01-14.
//  Copyright © 2019 Adel Araji. All rights reserved.
//

import Foundation

//Protocol to communicate between the CollectionListViewController(receiver) and CollectionListCall (sender) in order to reload the table once the data is received
protocol CollectionListProtocol {
    func didReceiveTableData(result: [AnyObject]?)
}
