//
//  ContactsListViewController.swift
//  PKUKendo
//
//  Created by Karma Guo on 6/20/15.
//  Copyright (c) 2015 Karma Guo. All rights reserved.
//

import UIKit

class ContactsListViewController: UITableViewController {
    var contactList:[String:[Contact]] = [:]
    var groupList:[String] = []
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        var index = self.tableView.indexPathForCell(cell)!
        (segue.destinationViewController as! ContactsViewController).contact = contactList[groupList[index.section]]![index.row]
    }
    
//    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
//        return ["社","天","地","玄","黄","宇","宙","洪","荒","日","月","盈","昃","辰","宿","列","张","寒","来","暑","往","秋","收","东","藏"]
//        //天地玄黄,宇宙洪荒。日月盈昃,辰宿列张。寒来暑往,秋收冬藏
//    }
//    
//    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
//        return index
//    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        KVNProgress.show()
        var query = AVQuery(className: "Contact")
        query.limit = 1000
        query.whereKey("sort", greaterThan: 0)
        query.orderByAscending("sort")
        query.findObjectsInBackgroundWithBlock(){
            (results:[AnyObject]!, error:NSError!) -> Void in
            if error == nil{
                self.contactList.removeAll(keepCapacity: true)
                var nowsort = 0
                for result  in results{
                    var contactItem = Contact()
                    contactItem.name = (result as! AVObject).objectForKey("name") as! String
                    if (result as! AVObject).objectForKey("duan") != nil{
                        contactItem.duan = (result as! AVObject).objectForKey("duan") as! String
                    }
                    if (result as! AVObject).objectForKey("weixin") != nil{
                        contactItem.weixin = (result as! AVObject).objectForKey("weixin") as! String
                    }
                    if (result as! AVObject).objectForKey("gender") != nil{
                        contactItem.gender = (result as! AVObject).objectForKey("gender") as! String
                    }
                    
                    contactItem.group = (result as! AVObject).objectForKey("group") as! String
                    
                    if (result as! AVObject).objectForKey("jiebie") != nil{
                        contactItem.jiebie = (result as! AVObject).objectForKey("jiebie") as! String
                    }
                    if (result as! AVObject).objectForKey("nianji") != nil{
                        contactItem.nianji = (result as! AVObject).objectForKey("nianji") as! String
                    }
                    if (result as! AVObject).objectForKey("phone") != nil{
                        contactItem.phone = (result as! AVObject).objectForKey("phone") as! String
                    }
                    if (result as! AVObject).objectForKey("position") != nil{
                        contactItem.position = (result as! AVObject).objectForKey("position") as! String
                    }
                    if (result as! AVObject).objectForKey("sort") != nil{
                        contactItem.sort = (result as! AVObject).objectForKey("sort") as! Int
                        if contactItem.sort != nowsort{
                            nowsort = contactItem.sort
                            self.groupList.append(contactItem.group)
                            self.contactList[contactItem.group] = []
                        }
                    }
                    if (result as! AVObject).objectForKey("userId") != nil{
                        contactItem.userId = (result as! AVObject).objectForKey("userId") as! String
                        var userq = AVUser.query()
                        userq.getObjectInBackgroundWithId(contactItem.userId){
                            (user:AVObject!, error:NSError!) -> Void in
                            if error == nil{
                                var avartarFile = user.objectForKey("Avartar") as? AVFile
                                if avartarFile != nil{
                                    avartarFile?.getThumbnail(true, width: 64, height: 64){
                                        (img:UIImage!, error:NSError!) -> Void in
                                        if error == nil{
                                            contactItem.avartar = img
                                            self.tableView.reloadData()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if (result as! AVObject).objectForKey("yuanxi") != nil{
                        contactItem.yuanxi = (result as! AVObject).objectForKey("yuanxi") as! String
                    }
                    self.contactList[contactItem.group]!.append(contactItem)
                }
                KVNProgress.dismiss()
                //KVNProgress.showSuccessWithStatus("更新成功")
                self.tableView.reloadData()
            }else {
                KVNProgress.dismiss()
                KVNProgress.showErrorWithStatus("网络错误")
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupList[section]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return groupList.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return contactList[groupList[section]]!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath) as! UITableViewCell

        (cell.viewWithTag(1200) as! UILabel).text = contactList[groupList[indexPath.section]]![indexPath.row].name
        (cell.viewWithTag(1201) as! UILabel).text = contactList[groupList[indexPath.section]]![indexPath.row].position
        // Configure the cell...

        return cell
    }
    

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
