//
//  TableViewController.swift
//  FilterData
//
//  Created by kashee on 04/04/18.
//  Copyright © 2018 SpaceBasic. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var medicineDtls = [[String:AnyObject]]()
    
   
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action: #selector(TableViewController.deleteDataFromCoreData))
        navigationItem.rightBarButtonItem = refreshButton
        title = "Filtered data from Core Data"
        
        readFromCoreData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineDtls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        cell.textLabel?.text = medicineDtls[indexPath.row]["category_name"] as! String
        return cell
    }
    
    
    func readFromCoreData(){
        
        // Fetching data from Core Data by making Query
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        
        // Directoly filtering from CoreData
        request.predicate = NSPredicate(format: " parent_id == %@", "0")  //exception occurs on this string
        request.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(request) as NSArray
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
                    if let numberofTimes = result.value(forKey: "dicData") as? [String:Any]{
                        data["dicData"] = numberofTimes as AnyObject

                    }
//                    print("Dic data: \(data)")
                    medicineDtls.append(data)
                    tableView.reloadData()
                }
            }
            
            print(data)
        }
            
        catch{}
    }
    
    @objc func deleteDataFromCoreData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        
        if let result = try? context.fetch(request) {
            for object in result {
                context.delete(object as! NSManagedObject)
            }
        }
    }

}
