//
//  EventListViewController.swift
//  PKUKendo
//
//  Created by Karma Guo on 6/20/15.
//  Copyright (c) 2015 Karma Guo. All rights reserved.
//

import UIKit

class EventListViewController: UITableViewController {
    
    var eventList:[Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        KVNProgress.show()
        var query = AVQuery(className: "Event")
        query.limit = 1000
        
        query.orderByAscending("num")
        query.findObjectsInBackgroundWithBlock(){
            (results:[AnyObject]!, error:NSError!) -> Void in
            if error == nil{
                self.eventList.removeAll(keepCapacity: true)
                for result  in results {
                    var eventItem = Event()
                    eventItem.content = result.objectForKey("content") as! String
                    eventItem.time = result.objectForKey("time") as! String
                    self.eventList.append(eventItem)
                }
                KVNProgress.dismiss()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return eventList.count
    }
    


    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell") as! UITableViewCell

        (cell.viewWithTag(1300)! as UIView).layer.cornerRadius = (cell.viewWithTag(1300)! as UIView).frame.width/2
        (cell.viewWithTag(1300)! as UIView).layer.masksToBounds = true
        (cell.viewWithTag(1300)! as UIView).layer.borderColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).CGColor
        (cell.viewWithTag(1300)! as UIView).layer.borderWidth = 3
        //(cell.viewWithTag(1301) as! UILabel).text = eventList[indexPath.row].content
        (cell.viewWithTag(1302) as! UILabel).text = eventList[indexPath.row].time
        
        (cell.viewWithTag(1301) as! UILabel).font = UIFont.systemFontOfSize(15)
        // cell.contentLabel = UILabel(frame: CGRect(x: 0, y: 20, width: 20, height: 20))
        var str = "\n" + eventList[indexPath.row].content + "\n"
        (cell.viewWithTag(1301) as! UILabel).numberOfLines = 0
        (cell.viewWithTag(1301) as! UILabel).lineBreakMode = NSLineBreakMode.ByWordWrapping
        (cell.viewWithTag(1301) as! UILabel).text = str
        (cell.viewWithTag(1301) as! UILabel).sizeToFit()
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
