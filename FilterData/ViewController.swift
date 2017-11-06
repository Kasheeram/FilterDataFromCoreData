//
//  ViewController.swift
//  FilterData
//
//  Created by SpaceBasic on 6/11/17.
//  Copyright © 2017 SpaceBasic. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class ViewController: UIViewController {
    
    let url = "https://kitp.test.uniqolabel.co/api/mobile/v1/getCategories.php"
    let param :[String:String] = ["auth_id":"F3227309950C09A98779","auth_token":"AEA6DBF913391AE58E98DAC2524BB3EF3B76DFDD"]
    var filtered = [[String: AnyObject]]()
    var medicine=[String]()
    var medicineDtls = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        Alamofire.request(url, method: .post, parameters: param).responseString{ response in
            let JSONData = response.data!
            do{
                let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .allowFragments) as! NSArray
        
//                for i in 0..<readableJSON.count
//                {
//                    let obj = readableJSON[i] as! [String:AnyObject]
//                    var tempDict:[String:Any] = [:]
//                    tempDict["category_id"] = obj["category_id"] as! String
//                    tempDict["category_name"] = obj["category_name"] as! String
//                    tempDict["customer_id"] = obj["customer_id"] as! String
//                    tempDict["parent_id"] = obj["parent_id"] as! String
//                    self.medicineDtls.append(tempDict as [String : AnyObject])
//
//                    // storing data to Core Data
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    let context = appDelegate.persistentContainer.viewContext
//                    let category = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: context)
//                    category.setValue(obj["category_id"] as! String, forKey: "category_id")
//                    category.setValue(obj["category_name"] as! String, forKey: "category_name")
//                    category.setValue(obj["customer_id"] as! String, forKey: "customer_id")
//                    category.setValue(obj["parent_id"] as! String, forKey: "parent_id")
//
//                    do{
//                        try context.save()
//                        print("SAVED")
//                    }catch{
//
//                    }
//                }
               // print(self.medicineDtls)
//              self.tableView.reloadData()
                
                
                // Fetching data from Core Data by making Query
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
                request.predicate = NSPredicate(format: " parent_id == %@", "0")  //exception occurs on this string
                request.returnsObjectsAsFaults = false
               // var results: NSArray = NSArray()
                do{
                   let results = try context.fetch(request) as NSArray
                    
                    var arr = [[String:AnyObject]]()
                    var data=[String:AnyObject]()
                    if results.count > 0{
                        for result in results as! [NSManagedObject]{
                            if let medicineName = result.value(forKey: "category_id") as? String{
                                data["category_id"]=medicineName as AnyObject
                            }
                            if let doseAmount = result.value(forKey: "category_name") as? String{
                                data["category_name"] = doseAmount as AnyObject
                            }
                            if let numberofTimes = result.value(forKey: "customer_id") as? String{
                                data["customer_id"] = numberofTimes as AnyObject
                            }
                            if let numberofTimes = result.value(forKey: "parent_id") as? String{
                                data["parent_id"] = numberofTimes as AnyObject
                            }
                            arr.append(data)
//                            medicineDtls.append(data)
//                            tableView.reloadData()
                        }
                    }
                    
                    print(arr)
                }
                    
                catch{}
                
            }catch{
                
            }
            
            // Fetching data Array of Dictionary by making Query
            let firstNamePredicate = NSPredicate(format: " parent_id == %@", "0")
            self.filtered = (self.medicineDtls as NSArray).filtered(using: firstNamePredicate) as! [[String : AnyObject]]
            print(self.filtered)
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

