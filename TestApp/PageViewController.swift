//
//  PageViewController.swift
//  TestApp
//
//  Created by JAN FREDRICK on 08/03/21.
//  Copyright © 2021 JFSK. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON
import JGProgressHUD

class PageViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var topPadding : CGFloat = 0
    var bottomPadding : CGFloat = 0
    
    var role : String = ""
    var username : String = ""
    
    var tableView : UITableView!
    
    var usersArray : [NSManagedObject] = []
    var cloudDataArray : NSArray = []
    
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        self.title = "\(role.capitalized) User : \(username)"
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: topPadding + navBarHeight, width: screenWidth, height: screenHeight - navBarHeight - topPadding - bottomPadding))
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if role.lowercased() == "normal" {
            /// Call api to get data & show
            showMsg(title: "Error with Link", msg: "callApi() function unable to proceed & has been commented in code line : 51 of 'PageViewController'", buttonString: "understood")
            //callApi()
        }
        
        self.tableView.reloadData()
    }
    
    func callApi() {
        
        hud.textLabel.text = "fetching"
        hud.show(in: self.view, animated: true)
        
        AF.request("http://jsonplaceholder.typicode.com/photos").responseJSON { (response) in
            
            self.hud.dismiss(afterDelay: 1.0)
            
            if response.error != nil {
                print("unable to get data, reason = \(String(describing: response.error?.localizedDescription))")
                return
            }
            
            let dataJSON = JSON(response.data!)
            
            print(dataJSON)
            
            self.tableView.reloadData()
        }
    }
    
    /// Table View Delegate Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if role.lowercased() == "admin" {
            return usersArray.count
        }else if role.lowercased() == "normal" {
            return cloudDataArray.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if role.lowercased() == "admin" {
            
            let objectData = usersArray[indexPath.row]
            
            cell.textLabel!.text = "Id : \(indexPath.row + 1)\nUsername : \(objectData.value(forKey: "username") as! String)\nRole : \(objectData.value(forKey: "usertype") as! String)\nEmail : \(objectData.value(forKey: "username") as! String)@danamon.com"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            cell.textLabel?.numberOfLines = 0
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if role.lowercased() == "admin" {
            return CGFloat(100)
        }
        return CGFloat(60)
    }
    
}
