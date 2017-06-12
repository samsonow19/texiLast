//
//  Order.swift
//  TaxiCramea
//
//  Created by Alexey Sinitsa on 31.05.17.
//  Copyright © 2017 админ. All rights reserved.
//

import Foundation

class OrderModel {
    var id: String!
    var time: String!
    var whence: String!
    var whereOrder: String!
    var cost: String!
    var commision: String!
    var info: String!
    var contact: String!
    
    
    var name: String!
    var number: String!
    var flight: String!
    var comment: String!
    var beforeDate: String!
    
    var classAvto: String!
    var your: String!
    var region1: String!
    var region2: String!
    var countTransfer: String!
   
    var toDate: String!
   
    init(){
        
    }
    
    
    func loadShotOrder(data : NSDictionary) {
        self.id = getStrJSON(data: data, key: "id")
        self.time = getStrJSON(data: data, key: "traffic_date")
        self.whence = getStrJSON(data: data, key: "whence")
        self.whereOrder = getStrJSON(data: data, key: "destination")
        self.cost = getStrJSON(data: data, key: "price")
        self.region1 = getStrJSON(data: data, key: "region1")
    }
    
    
    func loadLongOrder(data : NSDictionary) { ///write
        
        print(data)
        self.your = String(describing: data["your"] as! NSNumber)
        self.info = data["info"] as! String
  //getStrJSON(data: data, key: "info")
        //self.your = self.getStrJSON(data: data, key: "your")
        print(self.your)
        self.commision = self.getStrJSON(data: data, key: "comission")
        self.cost = self.getStrJSON(data: data, key: "price")
        self.id = self.getStrJSON(data: data, key: "id")
        self.time = self.getStrJSON(data: data, key: "traffic_date")
        self.whence = self.getStrJSON(data: data, key: "whence")
        self.whereOrder = self.getStrJSON(data: data, key: "destination")
        
        self.name = self.getStrJSON(data: data, key: "name")
        self.number = self.getStrJSON(data: data, key: "number")
        self.flight = self.getStrJSON(data: data, key: "flight")
        self.comment = self.getStrJSON(data: data, key: "comment")
    }
    
    
    func loadBuyOrder(data : NSDictionary) {
        
        self.id = getStrJSON(data: data, key: "id")
        let time1 = getStrJSON(data: data, key: "data_to")
        self.beforeDate = time1.components(separatedBy: " ")[1]
        let time2 = getStrJSON(data: data, key: "data")
        self.toDate = time2.components(separatedBy: " ")[1]
        self.whereOrder = getStrJSON(data: data, key: "destination")
        self.whence = getStrJSON(data: data, key: "whence")
        self.time = time1.components(separatedBy: " ")[0]
 
    }
    
    
    func getStrJSON(data: NSDictionary, key: String) -> String{
        //let info : AnyObject? = data[key]
        if let info = data[key] as? String{
            return info
        }
        return ""
        
    }
    
 
}
