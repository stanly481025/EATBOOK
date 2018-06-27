//
//  FoodTableViewController.swift
//  iOSFinalProject
//
//  Created by 陳育祥 on 2018/6/26.
//  Copyright © 2018年 陳育祥. All rights reserved.
//

import UIKit

class FoodTableViewController: UITableViewController {
    
    var food:[[String:String]] = []
    var name: [String.SubSequence]?
    
    @IBAction func clearPressed(_ sender: Any) {
        food.removeAll()
        tableView.reloadData()
    }
    @IBAction func qPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "這是一個你吃過什麼的App", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    @objc func getAddFoodNoti(noti:Notification) {
        let foodX = noti.userInfo as? [String:String]
        food.insert(foodX!, at: 0)
        let fileManager = FileManager.default
        let docUrls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docUrl = docUrls.first
        let url = docUrl?.appendingPathComponent("food.txt")
        (food as NSArray).write(to: url!, atomically: true)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Thread.sleep(forTimeInterval: 2)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let fileManager = FileManager.default
        let docUrls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docUrl = docUrls.first
        let url = docUrl?.appendingPathComponent("food.txt")
        let array = NSArray(contentsOf: url!)
        if array != nil {
            food = array as! [[String:String]]
        }
        let notiName = Notification.Name("AddFood")
        NotificationCenter.default.addObserver(self, selector: #selector(FoodTableViewController.getAddFoodNoti(noti:)), name: notiName, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return food.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! FoodTableViewCell
        // Configure the cell...
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.yellow
        }
        let dic = food[indexPath.row]
        let name = dic["name"]?.split(separator: ",")
        //let foodName = name![0]
        //let cal = name![1]
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd"
        //let date = dateFormatter.date(from: "\(name![2])")
        cell.foodLabel?.text = "\(name![0])"
        print(name![2])
        let date = name![2].split(separator: " ")
        cell.dateLabel?.text = "\(date[0])"
        let fileManager = FileManager.default
        let docUrls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docUrl = docUrls.first
        let url = docUrl?.appendingPathComponent(dic["photo"]!)
        cell.foodImageView?.image = UIImage(contentsOfFile: url!.path)
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        food.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
    
    
    
     /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
     /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let row = tableView.indexPathForSelectedRow?.row {
            let controller = segue.destination as? EditFoodTableViewController
            var tempF = food[row]
            let tempName = tempF["name"]?.split(separator: ",")
            controller?.name = "\(tempName![0])"
            controller?.cal = "\(tempName![1])"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let tempDate = dateFormatter.date(from: "\(tempName![2])")
            controller?.date = tempDate
            let fileManager = FileManager.default
            let docUrls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let docUrl = docUrls.first
            let url = docUrl?.appendingPathComponent(tempF["photo"]!)
            controller?.img = UIImage(contentsOfFile: url!.path)
        }
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
}

