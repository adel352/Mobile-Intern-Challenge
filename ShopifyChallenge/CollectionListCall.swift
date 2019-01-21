//
//  CollectionListCall.swift
//  ShopifyChallenge
//
//  Created by Adel Araji on 2019-01-12.
//  Copyright © 2019 Adel Araji. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class CollectionListCall {
    
    
    var collectionListDelegate: CollectionListProtocol?
    
    //Arrays storing the data for the each collection list
    var id = [Int]()
    var name = [String]()
    var body = [String]()
    var imageURL = [String]()
    var images = [UIImage]()
    
    //An array of DispatchGroup for each image API call, once the image for each collection is fetched: the second request for collecting the next image will be sent
    var group = [DispatchGroup]()
    
    
    /*
     This functions calls the API containing the data for the custom collection list page and parses the JSON
     The CollectionListViewController will be notified once the data is fetched
     */
    func loadUsersFromApi() {
        Alamofire.request(COLLECTIONS_LIST_URL).validate().responseJSON { (response) in
            switch response.result {
                
            case .success(let JSON):
                guard let value = JSON as? [String: Any] else {return}
                guard let jsonArray = value["custom_collections"] as? [[String: Any]] else {return}
                
                //Iterate through the JSON array and save the needed values for Aerodynamic, durable and small
                for(index,value) in jsonArray.enumerated() {
                    guard let handle = jsonArray[index]["handle"] as? String else {return}
                    
                    if (handle == "aerodynamic-collection" || handle  == "durable" || handle == "small-collection") {
                        
                        self.id.append(jsonArray[index]["id"] as! Int)
                        var name = (jsonArray[index]["title"] as! String).replacingOccurrences(of: " collection", with: "")
                        self.name.append(name)
                        self.body.append(jsonArray[index]["body_html"] as! String)
                        
                        //parse image json
                        guard let imageJson = jsonArray[index]["image"] as? [String: Any] else {return}
                        self.imageURL.append(imageJson["src"] as! String)
                    }
                }
                
                //Send the request to fetch the image for each collection
                //The logic here waits for each image to be sent before sending the next request
                for (index,value) in self.imageURL.enumerated() {
                    self.group.append(DispatchGroup())
                    self.group[index].enter()
                    
                    if (index != 0){
                        self.group[index-1].notify(queue: .main){//wait for previous before starting
                            self.sendImageRequest(url: self.imageURL[index], rowIndex: index)
                        } 
                    } else {
                        self.sendImageRequest(url: self.imageURL[index], rowIndex: index)
                    }
                    
                }
                
                //Make sure all rows are populated with their images before notifying the view controller
                self.group[self.imageURL.count-1].notify(queue: .main){
                    self.collectionListDelegate?.didReceiveTableData(result: jsonArray as [AnyObject])
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /*
     This functions sends the HTTP request for a specific url and row index
     The corresponding dispatch group will leave at the end notifying the http request for the next row to go through
     */
    private func sendImageRequest(url: String, rowIndex: Int) {
        Alamofire.request(url).validate().responseImage { (response) in
            switch response.result {
            case .success:
                
                guard let imageData = response.data else {return}
                var trueImage = UIImage(data: imageData)
                self.images.append(trueImage!)
                self.group[rowIndex].leave()
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
}
