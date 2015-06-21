//
//  ContactsViewController.swift
//  PKUKendo
//
//  Created by Karma Guo on 6/20/15.
//  Copyright (c) 2015 Karma Guo. All rights reserved.
//

import UIKit

class ContactsViewController: UITableViewController {
    var contact:Contact!
    
    @IBAction func call(sender: UIButton) {
        let requestURL = NSURL(string: "tel://\(contact.phone)")
        if requestURL != nil{
            UIApplication.sharedApplication().openURL(requestURL!)
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        (cell?.viewWithTag(1101) as! UILabel).text = contact.name
        (cell?.viewWithTag(1100) as! UIImageView).image = contact.avartar
        (cell?.viewWithTag(1100) as! UIImageView).layer.cornerRadius = (cell?.viewWithTag(1100) as! UIImageView).frame.width/2
        (cell?.viewWithTag(1100) as! UIImageView).layer.masksToBounds = true
//        cell.avartar.layer.cornerRadius = cell.avartar.frame.width/2
//        cell.avartar.layer.masksToBounds = true
        
        cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))
        (cell?.viewWithTag(1102) as! UILabel).text = contact.position
        
        cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))
        (cell?.viewWithTag(1103) as! UILabel).text = contact.gender
        
        cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1))
        if contact.phone != ""{
            (cell?.viewWithTag(1104) as! UIButton).setTitle("📞\(contact.phone)", forState: UIControlState.Normal)
            (cell?.viewWithTag(1104) as! UIButton).setTitle("📞\(contact.phone)", forState: UIControlState.Highlighted)
            (cell?.viewWithTag(1104) as! UIButton).setTitle("📞\(contact.phone)", forState: UIControlState.Selected)
        }else {
            (cell?.viewWithTag(1104) as! UIButton).enabled = false
            (cell?.viewWithTag(1104) as! UIButton).userInteractionEnabled = false
            (cell?.viewWithTag(1104) as! UIButton).setTitle("", forState: UIControlState.Disabled)
        }
        
        cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 2, inSection: 1))
        (cell?.viewWithTag(1105) as! UILabel).text = contact.weixin
        
        cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 1))
        (cell?.viewWithTag(1106) as! UILabel).text = contact.jiebie
        
        cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 1))
        (cell?.viewWithTag(1107) as! UILabel).text = contact.duan
        
        cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 5, inSection: 1))
        (cell?.viewWithTag(1108) as! UILabel).text = contact.yuanxi
        
        cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 6, inSection: 1))
        (cell?.viewWithTag(1109) as! UILabel).text = contact.nianji
        
    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("nameCell", forIndexPath: indexPath) as! UITableViewCell
//
//        
//        // Configure the cell...
//
//        return cell
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
