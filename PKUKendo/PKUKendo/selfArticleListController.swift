//
//  SelfArticleListController.swift
//  PKUKendo
//
//  Created by Karma Guo on 6/22/15.
//  Copyright (c) 2015 Karma Guo. All rights reserved.
//

import UIKit

class SelfArticleListController: UITableViewController {
    
    var articleList:[Article] = []
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

            var cell = sender as! ArticleCell
            var indexPath = self.tableView.indexPathForCell(cell)
            (segue.destinationViewController as! ArticleController).is_article = true
            (segue.destinationViewController as! ArticleController).article = articleList[indexPath!.row]
                
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var header = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: "headerRefresh:")
        
        header.setImages([UIImage(named: "123")!], forState: MJRefreshStatePulling)
        header.setImages([UIImage(named: "123")!], forState: MJRefreshStateRefreshing)
        header.setImages([UIImage(named: "123")!], forState: MJRefreshStateIdle)
        header.lastUpdatedTimeLabel.hidden = true
        header.stateLabel.hidden = true
        tableView.header = header
        
        var footer = MJRefreshBackGifFooter(refreshingTarget: self, refreshingAction: "footerRefresh:")
        footer.setImages([UIImage(named: "123")!], forState: MJRefreshStatePulling)
        footer.setImages([UIImage(named: "123")!], forState: MJRefreshStateRefreshing)
        footer.setImages([UIImage(named: "123")!], forState: MJRefreshStateIdle)
        //footer.lastUpdatedTimeLabel.hidden = true
        footer.stateLabel.hidden = true
        
        tableView.footer = footer
        
        tableView.header.beginRefreshing()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    func headerRefresh(sender:MJRefreshGifHeader){
        //self.tableView.reloadData()

        var query = AVQuery(className: "Article")
        query.limit = 10
        query.orderByDescending("num")
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.findObjectsInBackgroundWithBlock(){
            (results:[AnyObject]!, error:NSError!) -> Void in
            if error == nil{
                self.articleList.removeAll(keepCapacity: true)
                self.tableView.reloadData()
                for result in results{
                    var articleItem = Article()
                    articleItem.commentNum = (result as! AVObject).objectForKey("commentNum") as! Int
                    articleItem.content = (result as! AVObject).objectForKey("content") as! String
                    articleItem.title = (result as! AVObject).objectForKey("title") as! String
                    articleItem.num = (result as! AVObject).objectForKey("num") as! Int
                    articleItem.likeNum = (result as! AVObject).objectForKey("likeNum") as! Int
                    articleItem.id = result.objectId
                    articleItem.is_link = (result as! AVObject).objectForKey("is_link") as! Bool
                    //                        var userId = (result as! AVObject).objectForKey("user") as! String
                    //                        var userQuery = AVUser.query()
                    // var user = userQuery.getObjectWithId(userId) as! AVUser
                    var user = (result as! AVObject).objectForKey("user") as! AVUser
                    var userId = user.objectId as String
                    articleItem.userId = userId
                    var userQuery = AVUser.query()
                    user = userQuery.getObjectWithId(userId) as! AVUser
                    articleItem.userName = user.objectForKey("NickName") as! String
                    var avartarFile = user.objectForKey("Avartar") as? AVFile
                    if avartarFile != nil{
                        avartarFile?.getThumbnail(true, width: 64, height: 64){
                            (img:UIImage!, error:NSError!) -> Void in
                            if error == nil{
                                articleItem.avartar = img
                                self.tableView.reloadData()
                            }else{
                                articleItem.avartar = UIImage(named: "123")
                            }
                            
                        }
                        //                            var imgData =
                        //                            if imgData != nil{
                        //                                articleItem.avartar = UIImage(data: imgData!)
                        //                            } else {
                        //                                articleItem.avartar = UIImage(named: "123")
                        //                            }
                    } else {
                        articleItem.avartar = UIImage(named: "123")
                    }
                    
                    self.articleList.append(articleItem)
                }
                self.tableView.reloadData()
                self.tableView.header.endRefreshing()
                //self.tableView.reloadData()
            } else {
                self.tableView.header.endRefreshing()
            }
        }
        
            
        // println("456")
    }
    
    func footerRefresh(sender:MJRefreshBackGifFooter){

        var query = AVQuery(className: "Article")
        query.limit = 10
        query.whereKey("num", lessThan: articleList[articleList.endIndex-1].num)
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.orderByDescending("num")
        query.findObjectsInBackgroundWithBlock(){
            (results:[AnyObject]!, error:NSError!) -> Void in
            if error == nil{
                //self.articleList.removeAll(keepCapacity: true)
                for result in results{
                    var articleItem = Article()
                    articleItem.commentNum = (result as! AVObject).objectForKey("commentNum") as! Int
                    articleItem.content = (result as! AVObject).objectForKey("content") as! String
                    articleItem.title = (result as! AVObject).objectForKey("title") as! String
                    articleItem.num = (result as! AVObject).objectForKey("num") as! Int
                    articleItem.id = result.objectId
                    articleItem.is_link = (result as! AVObject).objectForKey("is_link") as! Bool
                    articleItem.likeNum = (result as! AVObject).objectForKey("likeNum") as! Int
                    var user = (result as! AVObject).objectForKey("user") as! AVUser
                    var userId = user.objectId as String
                    articleItem.userId = userId
                    var userQuery = AVUser.query()
                    user = userQuery.getObjectWithId(userId) as! AVUser
                    articleItem.userName = user.objectForKey("NickName") as! String
                    var avartarFile = user.objectForKey("Avartar") as? AVFile
                    if avartarFile != nil{
                        avartarFile?.getThumbnail(true, width: 64, height: 64){
                            (img:UIImage!, error:NSError!) -> Void in
                            if error == nil{
                                articleItem.avartar = img
                                self.tableView.reloadData()
                            }else{
                                articleItem.avartar = UIImage(named: "123")
                            }
                            
                        }
                        //                            var imgData = avartarFile?.getData()
                        //                            if imgData != nil{
                        //                                articleItem.avartar = UIImage(data: imgData!)
                        //                            } else {
                        //                                articleItem.avartar = UIImage(named: "123")
                        //                            }
                    } else {
                        articleItem.avartar = UIImage(named: "123")
                    }
                    
                    self.articleList.append(articleItem)
                }
                self.tableView.reloadData()
                self.tableView.footer.endRefreshing()
            } else {
                self.tableView.footer.endRefreshing()
            }
        }
        
       
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // tableView.header.beginRefreshing()
        
        
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
        //        if segmentControl.selected {
        
            return articleList.count
     
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // self.tabBarController?.tabBar.hidden = false
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("article", forIndexPath: indexPath) as! ArticleCell
        
        
        cell.avatarView.layer.cornerRadius = cell.avatarView.frame.width/2
        cell.avatarView.layer.masksToBounds = true
        

        let articleItem = articleList[indexPath.row]
        if articleItem.is_link == true {
            cell.titleLabel.text = articleItem.userName + " 分享链接"
            cell.commentNumField.text = "评论: \(articleItem.commentNum)"
            cell.avatarView.image = articleItem.avartar
            cell.contentLabel.text = "链接🔗 \(articleItem.title)"
        }else {
            cell.titleLabel.text = articleItem.title
            cell.commentNumField.text = "评论: \(articleItem.commentNum)"
            cell.avatarView.image = articleItem.avartar
            cell.contentLabel.text = articleItem.content
        }
      
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
