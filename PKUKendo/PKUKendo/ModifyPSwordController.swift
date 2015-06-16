//
//  ModifyPSwordController.swift
//  PKU Kendo
//
//  Created by Karma Guo on 15/5/12.
//  Copyright (c) 2015年 PKUKendo. All rights reserved.
//

import UIKit
import AVOSCloud

class ModifyPSwordController: UITableViewController {

    @IBOutlet weak var originalPasswordField: UITextField!
    
    @IBOutlet weak var newPasswordField: UITextField!
    
    @IBOutlet weak var confirmNewPasswordField: UITextField!
    
    @IBAction func changePassword(sender: UIBarButtonItem) {
        if originalPasswordField.text == "" || newPasswordField.text == "" || confirmNewPasswordField.text == ""  {
            KVNProgress.showErrorWithStatus("密码不能为空")
            return
        }
        
        if newPasswordField.text != confirmNewPasswordField.text {
            KVNProgress.showErrorWithStatus("新密码不一致")
        }
        KVNProgress.showWithStatus(" ")
        AVUser.currentUser().updatePassword(originalPasswordField.text, newPassword: newPasswordField.text){
            (obj:AnyObject!, error:NSError!) -> Void in
            if error != nil {
                KVNProgress.dismiss()
                KVNProgress.showErrorWithStatus("修改失败")
            }
            else {
                KVNProgress.dismiss()
                KVNProgress.showSuccessWithStatus("修改成功")
                self.navigationController?.popViewControllerAnimated(true)
            }
            
        }
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确定", style: .Plain, target: self, action: "SaveUserPassword")
        //        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }

    @IBAction func SaveUserPassword(sender: UIBarButtonItem) {
   
    
    
    }
    
    
    
    
//    func SaveUserPassword(){
//        
//        
//        
//        
//    }
    
    
    
    
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
