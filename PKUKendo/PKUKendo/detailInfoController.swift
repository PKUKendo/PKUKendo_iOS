//
//  detailInfoController.swift
//  PKU Kendo
//
//  Created by Karma Guo on 15/5/15.
//  Copyright (c) 2015年 PKUKendo. All rights reserved.
//

import UIKit
import AVOSCloud

let cameraIndex = 1, libraryIndex = 2


class detailInfoController: UITableViewController, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet var Avatar: UIImageView!
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    var choseSourceView: UIAlertView!

    var picker = UIImagePickerController()
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        Avatar.image = me.avartar
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        choseSourceView = UIAlertView(title:"修改头像" , message:"选择头像来源", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "拍照", "从相册选择")
        
        picker.delegate = self
        picker.allowsEditing = true
        Avatar.image = me.avartar
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

    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == cameraIndex {
            picker.sourceType = .Camera
            self.presentViewController(picker, animated: true, completion: nil)
        }
        else if buttonIndex == libraryIndex{
            picker.sourceType = .PhotoLibrary
            self.presentViewController(picker, animated: true, completion: nil)
        }
        
    }
    
    func saveImage(img: UIImage){
        
        var imgData = UIImagePNGRepresentation(img)
        var imgFile: AVFile = AVFile.fileWithData(imgData) as! AVFile
        AVUser.currentUser().setObject(imgFile, forKey: "Avartar")
        KVNProgress.showWithStatus(" ")
        AVUser.currentUser().saveInBackgroundWithBlock(){
            (success:Bool,error: NSError!) -> Void in
            if success {
                me.avartar = img
                KVNProgress.dismiss()
                KVNProgress.showSuccessWithStatus("上传成功")
                self.Avatar.image = me.avartar
                //self.navigationController?.popViewControllerAnimated(true)
            }
            else {
                KVNProgress.dismiss()
                KVNProgress.showErrorWithStatus("上传失败")
            }
        }
        
        
    }
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        var img = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if img != nil {
        img!.drawInRect(CGRectMake(0 , 0, 100, 100))
        Avatar.image = img
        saveImage(img!)
            
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    @IBAction func changeAvatar(sender: AnyObject) {
              choseSourceView.show()
    }
    
    
    
    @IBAction func Logout(sender: AnyObject) {
        AVUser.currentUser().setObject("", forKey: "installation")
        AVUser.currentUser().saveEventually()
        if AVInstallation.currentInstallation() != nil{
            AVInstallation.currentInstallation().setObject("", forKey: "userId")
            AVInstallation.currentInstallation().saveEventually()
        }
        AVUser.logOut()
        performSegueWithIdentifier("logout", sender: nil)
        
        
    }
    
    
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
