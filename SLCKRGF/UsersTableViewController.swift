//
//  UsersTableViewController.swift
//  SLCKRGF
//
//  Created by brett ohland on 2015-03-01.
//  Copyright (c) 2015 ampersandsoftworks. All rights reserved.
//

import UIKit
import SlackerKit

class UsersTableViewController: UITableViewController {

    private var users: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let token = TokenManager.sharedInstance.slackToken {
            loadUsersWithToken(token)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Custom methods
    
    func loadUsersWithToken(token:String) {
        
        refreshControl?.beginRefreshing()
        
        SlackClient.sharedInstance.getUsersWithToken(token, success: { (users) -> () in
            self.refreshControl?.endRefreshing()
            self.users = users
            self.tableView.reloadData()
        }, failure: { (response) -> () in
            println("Failure from server \(response.description)")
        }) { (error) -> () in
            println("ERROR \(error.localizedDescription)")
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UITableViewCell
        
        if let currentUser = users?[indexPath.row] as? NSDictionary{
            if let userName = currentUser["name"] as? String {
                cell.textLabel?.text = userName
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Outlet Actions

    @IBAction func refresh(sender: AnyObject) {
        if let token = TokenManager.sharedInstance.slackToken {
            loadUsersWithToken(token)
        }
    }

}
