//
//  CollectionListViewController.swift
//  ShopifyChallenge
//
//  Created by Adel Araji on 2019-01-13.
//  Copyright © 2019 Adel Araji. All rights reserved.
//

import UIKit
import Alamofire

class CollectionListViewController: UITableViewController, CollectionListProtocol {
    
    var collectionInfoDelegate :CollectionInfoProtocol?
    var apiCall = CollectionListCall()
    
    /*
        Gets called when all data for the Custom Collestions List page is fetched in order to reload the table with its appropriate info
     */
    func didReceiveTableData(result: [AnyObject]?) {
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCall.collectionListDelegate = self
        apiCall.loadUsersFromApi()
        self.title = "Custom Collections List"
    }
    
    //Prepare data for next view by sending it the name and id of the collection through the CollectionInfoProtocol
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let data = Data()
        if let destinationViewController = segue.destination as? CollectionDetailsViewController {
            collectionInfoDelegate = destinationViewController
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiCall.name.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CollectionListCell {
            //Populating each cell with its data
            cell.configureCell(apiCall: self.apiCall, row: indexPath.row)
            return cell
        }
        else {
            return CollectionListCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Sending the id and name of the collection list to the details view controller
        self.collectionInfoDelegate?.didReceiveCollectionInfo(collectionName: self.apiCall.name[indexPath.row], id: self.apiCall.id[indexPath.row])
        
    }
    
}
