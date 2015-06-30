//
//  ModifyGenderController.swift
//  PKU Kendo
//
//  Created by Karma Guo on 15/5/15.
//  Copyright (c) 2015年 PKUKendo. All rights reserved.
//

import UIKit
import AVOSCloud

var me = User()

class ModifyGenderController: UITableViewController {

    @IBOutlet var maleCell: UITableViewCell!
    
    @IBOutlet var femaleCell: UITableViewCell!
    
    let male = 0, female = 1
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        maleCell.accessoryType = .Checkmark
//        femaleCell.accessoryType = .None
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if me.gender == "保密" {
            maleCell.accessoryType = .Checkmark
            femaleCell.accessoryType = .None
        }
        else if me.gender == "男" {
            maleCell.accessoryType = .Checkmark
            femaleCell.accessoryType = .None
        }
        else {
            maleCell.accessoryType = .None
            femaleCell.accessoryType =  .Checkmark
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if indexPath.row == male{
            maleCell.accessoryType = .Checkmark
            femaleCell.accessoryType = .None
            saveGender("男")
        }
        else{
            femaleCell.accessoryType = .Checkmark
            maleCell.accessoryType = .None
            saveGender("女")
        }
        
        
        
    }
    
    
    func saveGender(gender: String){
        
        AVUser.currentUser().setObject(gender, forKey: "gender")
        KVNProgress.showWithStatus(" ")
        AVUser.currentUser().saveInBackgroundWithBlock(){
            (success:Bool, error:NSError!) -> Void in
            if success {
                me.gender = gender
                if AVUser.currentUser().objectForKey("Avartar") as? AVFile == nil{
                    if me.gender == "男"{
                        me.avartar = UIImage(named: "男生默认头像")
                    }else {
                        me.avartar = UIImage(named: "女生默认头像")
                    }
                }
                KVNProgress.dismiss()
               // KVNProgress.showSuccessWithStatus("修改成功")
                me.gender = gender
                self.navigationController?.popViewControllerAnimated(true)
            }
            else {
                KVNProgress.dismiss()
            
                KVNProgress.showErrorWithStatus("网络错误")
            }
        }
        
        
    }
    
    
    
    // MARK: - Table view data source

   
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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
