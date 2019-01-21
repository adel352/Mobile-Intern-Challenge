//
//  CollectionDetailsCall.swift
//  ShopifyChallenge
//
//  Created by Adel Araji on 2019-01-15.
//  Copyright © 2019 Adel Araji. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class CollectionDetailsCall {
    
    //Arrays storing the data for the each product in a collection
    var productId = [Int]()
    var name = [String]()
    var availableInventory = [Int]()
    var body = [String]()
    var vendor = [String]()
    var imageURL = [String]()
    var images = [UIImage]()
    
    //Set of 3 main group of Async tasks: 1-fetching product IDs, 2-fetching Data(except images) for each product, 3-fetching image for each product, each task needs to be executed after the other since they need information from the previous request
    let group1 = DispatchGroup()
    let group2 = DispatchGroup()
    let group3 = DispatchGroup()
    
    //In step 2 and 3 from the previous group, multilple request (for each row) must be sent, group 4 belongs to the data fetching (no imnages) and group 5 for the image fetching
    var group4 = [DispatchGroup]()
    var group5 = [DispatchGroup]()
    
    var productDetailDelegate: ProductDetailsProtocol?
    
    /*
     This functions calls the API containing the data of each product for a specific collections id and parses the JSON
     The CollectionDetailsViewController will be notified once the data is fetched
     */
    func loadDetailsInfo(collectionId: Int) {
        self.group1.enter()
        
        //Getting the product ids
        populateProductIds(collectionId: collectionId)
        
        self.group1.notify(queue: .main){
            //Waiting to get the productIds and then get all their details
            self.group2.enter()
            self.populateDataForEachProduct()
            
            //Below is only reached when the info about each product is collected (async task for each is done)
            self.group2.notify(queue: .main){
                self.group3.enter()
                self.populateImageForEachProduct()
                self.group3.notify(queue: .main){
                    //Sending signal to populate the cell once all the data is received
                    self.productDetailDelegate?.didReceiveProductDetails()
                }
            }
        }
    }
    
    /*
     Gets the product ids in a specific collection by passing it the collection id
     */
    private func populateProductIds(collectionId: Int) {
        
        //Get the first URL corresponding to the collection id in order to get the product ids
        let productIdURL = PRODUCT_IDS_BASIC_URL + String(collectionId) + DETAILS_ACCESS_TOKEN
        
        //Send Request to get product ids
        Alamofire.request(productIdURL).validate().responseJSON { (response) in
            switch response.result {
                
            case .success(let JSON):
                //self.group.enter()
                guard let value = JSON as? [String: Any] else {return}
                guard let jsonArray = value["collects"] as? [[String: Any]] else {return}
                
                //Iterate through the jsonArray
                for(index,value) in jsonArray.enumerated() {
                    self.productId.append(jsonArray[index]["product_id"] as! Int)
                    
                }
                
                self.group1.leave()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /*
     Gets the data for each product except the images
     */
    private func populateDataForEachProduct() {
        
        for(index,value) in self.productId.enumerated() {
            
            let url = DETAILS_LIST_URL + String(self.productId[index]) + DETAILS_ACCESS_TOKEN//url for each product
            group5.append(DispatchGroup())
            group5[index].enter()
            if (index != 0) {
                self.group5[index-1].notify(queue: .main){//wait for previous before starting
                    self.sendProductDataRequest(index: index, url: url)
                }
            }else {
                sendProductDataRequest(index: index, url: url)
            }
        }
        // Waiting for Last Async task
        self.group5[productId.count-1].notify(queue: .main){
            self.group2.leave()
        }
        
    }
    
    /*
     Gets the image for each product
     */
    private func populateImageForEachProduct() {
        
        for(index,value) in self.imageURL.enumerated() {
            
            let url = self.imageURL[index]
            group4.append(DispatchGroup())
            group4[index].enter()
            if (index != 0){
                self.group4[index-1].notify(queue: .main){//wait for previous before starting
                    self.sendImageRequest(index: index, url: url)
                }
            } else {
                sendImageRequest(index: index, url: url)
            }
            
            
        }
        // Waiting for Last Async task
        self.group4[imageURL.count-1].notify(queue: .main){
            self.group3.leave()
        }
        
    }
    
    /*
     Sending request to get the data (except for images) for each product
     */
    private func sendProductDataRequest(index: Int, url: String) {
        
        Alamofire.request(url).validate().responseJSON { (response) in
            switch response.result {
            case .success(let JSON):
                guard let value = JSON as? [String: Any] else {return}
                guard let jsonArray = value["products"] as? [[String: Any]] else {return}
                
                self.name.append(jsonArray[0]["title"] as! String)
                self.body.append(jsonArray[0]["body_html"] as! String)
                self.vendor.append(jsonArray[0]["vendor"] as! String)
                
                //get variant dictionnary
                guard let variantsDict = jsonArray[0]["variants"] as? [[String: Any]] else {return}
                var availableItems = 0
                for(index,value) in variantsDict.enumerated() {
                    
                    availableItems = availableItems + (variantsDict[index]["inventory_quantity"] as! Int)
                }
                self.availableInventory.append(availableItems)
                
                //Get Image URL, get the images dictionnary first
                guard let imagesDict = jsonArray[0]["images"] as? [[String: Any]] else {return}
                
                self.imageURL.append(imagesDict[0]["src"] as! String)
                self.group5[index].leave()
                
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    /*
     Sending request to get the image for each product
     */
    private func sendImageRequest(index: Int, url: String) {
        Alamofire.request(url).validate().responseImage { (response) in
            switch response.result {
            case .success:
                
                guard let imageData = response.data else {return}
                var trueImage = UIImage(data: imageData)
                self.images.append(trueImage!)
                self.group4[index].leave()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
