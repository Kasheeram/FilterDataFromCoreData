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
        
        if self.someEntityExists(){
            print("check values: \(self.someEntityExists())")
        }else{
            saveToCoreData()
        }
        
    }
    
    @IBAction func showData(_ sender: Any) {
        let storyBoard = UIStoryboard(name:"Main",bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    func saveToCoreData(){
        
        Alamofire.request(url, method: .post, parameters: param).responseString{ response in
            let JSONData = response.data!
            do{
                let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .allowFragments) as! NSArray
                
                print(readableJSON)
                for i in 0..<readableJSON.count
                {
                    let obj = readableJSON[i] as! [String:AnyObject]
                    var tempDict:[String:Any] = [:]
                    var dicData = ["name":"Kashee","age":"26","lastName":"Kushwaha","address":"Majhguwan"]
                    tempDict["category_id"] = obj["category_id"] as! String
                    tempDict["category_name"] = obj["category_name"] as! String
                    tempDict["customer_id"] = obj["customer_id"] as! String
                    tempDict["parent_id"] = obj["parent_id"] as! String
                    self.medicineDtls.append(tempDict as [String : AnyObject])
                    
                    // storing data to Core Data
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let context = appDelegate.persistentContainer.viewContext
                    let category = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: context)
                    category.setValue(obj["category_id"] as! String, forKey: "category_id")
                    category.setValue(obj["category_name"] as! String, forKey: "category_name")
                    category.setValue(obj["customer_id"] as! String, forKey: "customer_id")
                    category.setValue(obj["parent_id"] as! String, forKey: "parent_id")
                    // storing dictionary value directly to CoreData
                    category.setValue(dicData, forKey: "dicData")
                    
                    do{
                        try context.save()
                        print("SAVED")
                    }catch{
                        
                    }
                    
                }
                //  print(self.medicineDtls)
                //  self.tableView.reloadData()
                
            }catch{
                
            }
            
            //  Fetching data Array of Dictionary by making Query // not from coredata
            let firstNamePredicate = NSPredicate(format: " parent_id == %@", "0")
            self.filtered = (self.medicineDtls as NSArray).filtered(using: firstNamePredicate) as! [[String : AnyObject]]
            print(self.filtered)
            
            
        }
    }
    
    
    func someEntityExists() -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        fetchRequest.includesSubentities = false
        
        var entitiesCount = 0
        
        do {
            entitiesCount = try context.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        
        return entitiesCount > 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

