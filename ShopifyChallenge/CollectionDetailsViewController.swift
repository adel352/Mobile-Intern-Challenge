//
//  CollectionDetailsViewController.swift
//  ShopifyChallenge
//
//  Created by Adel Araji on 2019-01-15.
//  Copyright © 2019 Adel Araji. All rights reserved.
//

import UIKit

class CollectionDetailsViewController: UITableViewController, CollectionInfoProtocol, ProductDetailsProtocol {
    
    @IBOutlet var loadingView: UIView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var loadingLabel: UILabel!
    
    var apiCall = CollectionDetailsCall()
    var collectionTitle = ""
    var collectionId = 0
    
    /*
     Gets called when all data for the Collection Details page is fetched in order to reload the table with its appropriate info
     */
    func didReceiveProductDetails() {
        self.tableView.reloadData()
    }
    
    /*
     Gets called when the collection id and name are received from the previous view controller after selecting a cell (a collection)
     */
    func didReceiveCollectionInfo(collectionName: String, id: Int) {
        collectionTitle = collectionName
        collectionId = id
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoadingScreen()
        apiCall.productDetailDelegate = self
        apiCall.loadDetailsInfo(collectionId: collectionId)
        self.title = collectionTitle + " Collection"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apiCall.name.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CollectionDetailsCell {
            
            cell.configureCell(apiCall: self.apiCall, row: indexPath.row, collectionName: self.collectionTitle)
            if(indexPath.row == self.apiCall.productId.count-1) {
                removeLoadingScreen()
            }
            return cell
        }
        else {
            return CollectionDetailsCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80;
    }
    
    /*
     Sets the activity indicator into the main view
     */
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets spinner
        spinner.style = .gray
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)
        
        tableView.addSubview(loadingView)
        
    }
    
    /*
     Removes the activity indicator from the main view
     */
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the spinner
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        loadingView.isHidden = true
        
    }
}
