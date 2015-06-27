//
//  LoginViewController.swift
//  PKU Kendo
//
//  Created by Karma Guo on 5/6/15.
//  Copyright (c) 2015 PKUKendo. All rights reserved.
//

import UIKit
import AVOSCloud



class ModifyNameController: UITableViewController ,UITextFieldDelegate{
    var nickName:String = ""
    @IBOutlet weak var nickNameField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickNameField.text = nickName
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        nickNameField.becomeFirstResponder()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: "SaveUserName")
//        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText:NSString = textField.text
        let newText:NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        saveButton.enabled = (newText.length>0) && !textField.text.isEmpty
        
        return true
    }
    
    @IBAction func SaveUserName() {
        if nickNameField.text != ""{
            AVUser.currentUser().setObject(nickNameField.text, forKey: "NickName")
            KVNProgress.showWithStatus(" ")
            AVUser.currentUser().saveInBackgroundWithBlock(){
                (success:Bool, error:NSError!) -> Void in
                if success {
                    KVNProgress.dismiss()
                    KVNProgress.showSuccessWithStatus("修改成功")
                    me.nickname = self.nickNameField.text
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else {
                    KVNProgress.dismiss()
                    KVNProgress.showErrorWithStatus("修改失败")
                }
            }
        }else {
            KVNProgress.showErrorWithStatus("用户名不能为空")
        }
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 15.0
//    }
    
//    func SaveUserName(){
//        
//        
//        
//    }
//    
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
