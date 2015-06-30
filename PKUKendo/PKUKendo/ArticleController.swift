//
//  ArticleController.swift
//  PKUKendo
//
//  Created by Karma Guo on 6/17/15.
//  Copyright (c) 2015 Karma Guo. All rights reserved.
//

import UIKit

class ArticleController: UITableViewController,ArticleEditViewControllerDelegate {
    
    var article:Article?
    
    weak var delegate:ArticleChangeViewControllerDelegate?
    
    func editFinishWithContent(content: String, AndTitle title: String) {
        article!.content = content
        article!.title = title
        //println("123")
        self.tableView.reloadData()
    }
    
    //@IBOutlet weak var likeButton: UIButton!
    
    var notice:Notice?
    var is_article:Bool!
    var commentList:[Comment] = []
    var has_like:Bool = false
//    override func viewDidLayoutSubviews() {
//        tableView.separatorInset = UIEdgeInsetsZero
//        tableView.layoutMargins = UIEdgeInsetsZero
//    }
    
    @IBAction func report(sender: UIButton) {
        var str = "mailto://president.pkukendo@gmail.com?subject=PKUKendo举报邮件&body=\(article!.userName)用户的文章\(article!.title)或其评论中含有违规内容"
        str = str.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let url = NSURL(string: str)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    
    @IBAction func deleteAction(sender: UIButton) {
        var alertcontrl = UIAlertController(title: "确认删除", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertcontrl.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: {
            (alert: UIAlertAction!) -> Void in
            var id = self.article!.id
            KVNProgress.show()
            var query = AVQuery(className: "Article")
            query.getObjectInBackgroundWithId(id){
                (result:AVObject!,error: NSError!) -> Void in
                if error == nil{
                    result.deleteEventually()
                    KVNProgress.dismiss()
                    KVNProgress.showSuccessWithStatus("删除成功")
                    self.delegate?.articleChangeNeedRefresh()
                    self.navigationController?.popViewControllerAnimated(true)
                }else {
                    KVNProgress.dismiss()
                    KVNProgress.showErrorWithStatus("网络错误")
                }
            }
        }))
        alertcontrl.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        }))
        self.presentViewController(alertcontrl, animated: true, completion: nil)
    }
    
    
    @IBAction func clickLink(sender: UIButton) {
        self.performSegueWithIdentifier("openWeb", sender: sender)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "openWeb" {
            if is_article == true {
                (segue.destinationViewController as! WebViewController).url = article!.content
            }else {
                (segue.destinationViewController as! WebViewController).url = notice!.content
            }
        }else if segue.identifier == "edit"{
            (segue.destinationViewController as! ArticleEditViewController).id = article!.id
             (segue.destinationViewController as! ArticleEditViewController).delegate = self
            (segue.destinationViewController as! ArticleEditViewController).titleText = article!.title
            (segue.destinationViewController as! ArticleEditViewController).content = article!.content
            
        }else {
            if is_article == true{
                (segue.destinationViewController as! CommentEditController).articleId = article!.id
                (segue.destinationViewController as! CommentEditController).is_article = is_article
                (segue.destinationViewController as! CommentEditController).userId = article!.userId
                (segue.destinationViewController as! CommentEditController).articleTitle = article!.title
            } else {
                (segue.destinationViewController as! CommentEditController).articleId = notice!.id
                (segue.destinationViewController as! CommentEditController).is_article = is_article
                (segue.destinationViewController as! CommentEditController).articleTitle = notice!.title
            }
        }
    }
    
    @IBAction func like(sender: UIButton) {
        sender.userInteractionEnabled = false
        sender.enabled = false
        if is_article == true{
            //article!.likeNum! += 1
            var query = AVQuery(className: "Article")
            query.getObjectInBackgroundWithId(article!.id){
                (result:AVObject!,error: NSError!) -> Void in
                if error == nil{
                    result.incrementKey("likeNum")
                    var err = NSErrorPointer()
                    result.save(err)
                    var likeObj = AVObject(className: "Like")
                    likeObj.setObject(AVUser.currentUser().objectId, forKey: "user")
                    likeObj.setObject(self.article!.id, forKey: "article")
                    likeObj.saveEventually()
                    
                    if self.article!.userId != AVUser.currentUser().objectId {
                    
                        var pushQ = AVInstallation.query()
                        pushQ.whereKey("userId", equalTo: self.article!.userId)
                        var push = AVPush()
                        
                        
                        push.setQuery(pushQ)
                        push.setMessage("您的文章\(self.article!.title)收到一条点赞")
                        push.sendPushInBackground()
                    }
                    
                    if err == nil {
                        self.article!.likeNum! += 1
                        var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0))! as UITableViewCell
                        (cell.viewWithTag(1004) as! UILabel).text = "\(self.article!.likeNum)人 已赞"
                    } else {
                        KVNProgress.showErrorWithStatus("网络错误")
                        sender.enabled = true
                        sender.userInteractionEnabled = true
                    }
                }else {
                    KVNProgress.showErrorWithStatus("网络错误")
                    sender.enabled = true
                    sender.userInteractionEnabled = true
                }
            }
        } else {
            var query = AVQuery(className: "Notice")
            query.getObjectInBackgroundWithId(notice!.id){
                (result:AVObject!,error: NSError!) -> Void in
                if error == nil{
                    result.incrementKey("likeNum")
                    var err = NSErrorPointer()
                    result.save(err)
                    var likeObj = AVObject(className: "Like")
                    likeObj.setObject(AVUser.currentUser().objectId, forKey: "user")
                    likeObj.setObject(self.notice!.id, forKey: "article")
                    likeObj.saveEventually()
                    if err == nil {
                        self.notice!.likeNum! += 1
                        var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0))! as UITableViewCell
                        (cell.viewWithTag(1004) as! UILabel).text = "\(self.notice!.likeNum)人 已赞"
                    } else {
                        KVNProgress.showErrorWithStatus("网络错误")
                        sender.enabled = true
                        sender.userInteractionEnabled = true
                    }
                }else {
                    KVNProgress.showErrorWithStatus("网络错误")
                    sender.enabled = true
                    sender.userInteractionEnabled = true
                }
            }
            //notice!.likeNum += 1
        }
    }
    
    
  

//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        super.tableView(<#tableView: UITableView#>, didSelectRowAtIndexPath: <#NSIndexPath#>)
//        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var footer = MJRefreshBackGifFooter(refreshingTarget: self, refreshingAction: "footerRefresh:")
        footer.setImages([UIImage(named: "tiao1")!,UIImage(named: "tiao2")!],duration: 0.4, forState: MJRefreshStatePulling)
        footer.setImages([UIImage(named: "tiao1")!,UIImage(named: "tiao2")!],duration: 0.4, forState: MJRefreshStateRefreshing)
        footer.setImages([UIImage(named: "tiao1")!,UIImage(named: "tiao2")!],duration: 0.4, forState: MJRefreshStateIdle)
        //footer.lastUpdatedTimeLabel.hidden = true
        footer.stateLabel.hidden = true
        
        tableView.footer = footer

//        tableView.separatorInset = UIEdgeInsetsZero
//        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    
        
        //self.tabBarController?.tabBar.hidden = true
//        self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y, width: self.tableView.frame.size.width , height: self.tableView.frame.size.height + 100)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        //println("123")
        var userId = AVUser.currentUser().objectId
        if is_article == true{
            var articleId = article!.id
            var query = AVQuery(className: "Like")
            query.whereKey("user", equalTo: userId)
            query.whereKey("article", equalTo: articleId)
            query.findObjectsInBackgroundWithBlock(){
                (results:[AnyObject]!,error:NSError!) -> Void in
                if error == nil && results.count > 0{
                    var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0))! as UITableViewCell
                    (cell.viewWithTag(1003) as! UIButton).enabled = false
                    (cell.viewWithTag(1003) as! UIButton).userInteractionEnabled = false
                }
                
            }
        } else {
            var articleId = notice!.id
            var query = AVQuery(className: "Like")
            query.whereKey("user", equalTo: userId)
            query.whereKey("article", equalTo: articleId)
            query.findObjectsInBackgroundWithBlock(){
                (results:[AnyObject]!,error:NSError!) -> Void in
                if error == nil && results.count > 0{
                    var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0))! as UITableViewCell
                    (cell.viewWithTag(1003) as! UIButton).enabled = false
                    (cell.viewWithTag(1003) as! UIButton).userInteractionEnabled = false
                }
                
            }
        }
        //self.tableView.footer.beginRefreshing()
        
        var query = AVQuery(className: "Comment")
        query.orderByAscending("num")
        if commentList.count == 0{
            
        }else {
            query.whereKey("num", greaterThan: commentList[commentList.endIndex-1].num)
        }
        if is_article == true{
            query.whereKey("articleId", equalTo: article!.id)
        }else {
            query.whereKey("articleId", equalTo: notice!.id)
        }
        query.findObjectsInBackgroundWithBlock(){
            (results:[AnyObject]!,error: NSError!) -> Void in
            if error == nil{
                for result in results{
                    var commentItem = Comment()
                    commentItem.content = result.objectForKey("content") as! String
                    commentItem.num = result.objectForKey("num") as! Int
                    var user = result.objectForKey("user") as! AVUser
                    var userId = user.objectId
                    var userquery = AVUser.query()
                    user = userquery.getObjectWithId(userId) as! AVUser
                    var userGender = user.objectForKey("gender") as! String
                    commentItem.username = user.objectForKey("NickName") as! String
                    var avartarFile = user.objectForKey("Avartar") as? AVFile
                    if avartarFile != nil{
                        var imgData = avartarFile?.getData()
                        if imgData != nil{
                            commentItem.avartar = UIImage(data: imgData!)
                        } else {
                            if userGender == "男"{
                                commentItem.avartar = UIImage(named: "男生默认头像")
                            }else {
                                commentItem.avartar = UIImage(named: "女生默认头像")
                            }
                           
                        }
                    } else {
                        if userGender == "男"{
                            commentItem.avartar = UIImage(named: "男生默认头像")
                        }else {
                            commentItem.avartar = UIImage(named: "女生默认头像")
                        }
                    }
                    self.commentList.append(commentItem)
                }
                self.tableView.reloadData()
               // println("123")
               // self.tableView.footer.endRefreshing()
            }else {
                KVNProgress.showErrorWithStatus("网络错误")
               // self.tableView.footer.endRefreshing()
            }
        }

    }
    func footerRefresh(sender:MJRefreshBackGifFooter){
        var query = AVQuery(className: "Comment")
        query.orderByAscending("num")
        if commentList.count == 0{
            
        }else {
            query.whereKey("num", greaterThan: commentList[commentList.endIndex-1].num)
        }
        if is_article == true{
            query.whereKey("articleId", equalTo: article!.id)
        }else {
            query.whereKey("articleId", equalTo: notice!.id)
        }
        query.findObjectsInBackgroundWithBlock(){
            (results:[AnyObject]!,error: NSError!) -> Void in
            if error == nil{
                for result in results{
                    var commentItem = Comment()
                    commentItem.content = result.objectForKey("content") as! String
                    commentItem.num = result.objectForKey("num") as! Int
                    var user = result.objectForKey("user") as! AVUser
                    var userId = user.objectId
                    var userquery = AVUser.query()
                    user = userquery.getObjectWithId(userId) as! AVUser
                    var userGender = user.objectForKey("gender") as! String
                    commentItem.username = user.objectForKey("NickName") as! String
                    var avartarFile = user.objectForKey("Avartar") as? AVFile
                    if avartarFile != nil{
                        var imgData = avartarFile?.getData()
                        if imgData != nil{
                            commentItem.avartar = UIImage(data: imgData!)
                        } else {
                            if userGender == "男"{
                                commentItem.avartar = UIImage(named: "男生默认头像")
                            }else {
                                commentItem.avartar = UIImage(named: "女生默认头像")
                            }
                        }
                    } else {
                        if userGender == "男"{
                            commentItem.avartar = UIImage(named: "男生默认头像")
                        }else {
                            commentItem.avartar = UIImage(named: "女生默认头像")
                        }
                    }
                    self.commentList.append(commentItem)
                }
                self.tableView.reloadData()
                self.tableView.footer.endRefreshing()
            }else {
                KVNProgress.showErrorWithStatus("网络错误")
                self.tableView.footer.endRefreshing()
            }
        }

        
    }
    
//    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.separatorInset = UIEdgeInsetsZero
//        cell.layoutMargins = UIEdgeInsetsZero
//    }

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

//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        var query = AVQuery(className: "Comment")
//        query.orderByAscending("num")
//        if is_article == true{
//            query.whereKey("articleId", equalTo: article!.id)
//        }else {
//            query.whereKey("articleId", equalTo: notice!.id)
//        }
//        query.findObjectsInBackgroundWithBlock(){
//            (results:[AnyObject]!,error: NSError!) -> Void in
//            if error == nil{
//                for result in results{
//                    var commentItem = Comment()
//                    commentItem.content = result.objectForKey("content") as! String
//                    commentItem.num = result.objectForKey("num") as! Int
//                    var user = result.objectForKey("user") as! AVUser
//                    var userId = user.objectId
//                    var userquery = AVUser.query()
//                    user = userquery.getObjectWithId(userId) as! AVUser
//                    commentItem.username = user.objectForKey("NickName") as! String
//                    var avartarFile = user.objectForKey("Avartar") as? AVFile
//                    if avartarFile != nil{
//                        var imgData = avartarFile?.getData()
//                        if imgData != nil{
//                            commentItem.avartar = UIImage(data: imgData!)
//                        } else {
//                            commentItem.avartar = UIImage(named: "123")
//                        }
//                    } else {
//                        commentItem.avartar = UIImage(named: "123")
//                    }
//                    self.commentList.append(commentItem)
//                }
//                self.tableView.reloadData()
//            }else {
//                KVNProgress.showErrorWithStatus("网络错误")
//            }
//        }
//    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 4 + commentList.count
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//       // var cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath) as! ArticleContentCell
//        var str = "asdfasd fasd fasdf jlkasjdf l;asjdfl ;jasdl kfjasl;d fjlaskjdf l;kasjdf l;kasjdl fkjsaldk fjlsakdjf als; djflas;dj fl;sakjd fl;jasdkl; fjalskdj fl;kasjd fkl;asjd fl;asjdl; kjsakl;dj lkasjdlkaj sdlkfj lasdj l;sajd flsadj flkjsadl fkjsalkdj fkl;ajsdlf;asl;kdjf ;klasasdflksajdfl ajsdlkfjasdlk;fjasl;dfjlasd"
//        c
//        return cell.contentLabel.frame.height+10
//    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("titleContentCell") as! ArticleTitleCell
            //cell.avartar.image = UIImage(named: "1")
            if is_article == true{
                cell.avartar.image = article!.avartar
                cell.titleLabel.text = article!.title
                cell.avartar.layer.cornerRadius = cell.avartar.frame.width/2
                cell.avartar.layer.masksToBounds = true
            }else {
                cell.avartar.image = notice!.picture
                cell.titleLabel.text = notice!.title
                cell.avartar.layer.cornerRadius = cell.avartar.frame.width/2
                cell.avartar.layer.masksToBounds = true
            }
            
            return cell
            
        }else if(indexPath.row == 1){
            
            if is_article == true{
                if article!.is_link == false {
                    let cell = tableView.dequeueReusableCellWithIdentifier("articleContentCell", forIndexPath: indexPath) as! ArticleContentCell
                    cell.contentLabel.font = UIFont.systemFontOfSize(17)
                    // cell.contentLabel = UILabel(frame: CGRect(x: 0, y: 20, width: 20, height: 20))
                    var str = article!.content
                    cell.contentLabel.numberOfLines = 0
                    cell.contentLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
                    cell.contentLabel.text = str
                    cell.contentLabel.sizeToFit()
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("shareLinkCell", forIndexPath: indexPath) as! UITableViewCell
                    let button = cell.viewWithTag(1005) as! UIButton
                    button.setTitle("链接🔗 \(article!.title)", forState: UIControlState.Normal)
                    button.setTitle("链接🔗 \(article!.title)", forState: UIControlState.Highlighted)
                    button.setTitle("链接🔗 \(article!.title)", forState: UIControlState.Selected)
                    return cell
                }
                
            }else {
                if notice!.is_link == false {
                    let cell = tableView.dequeueReusableCellWithIdentifier("articleContentCell", forIndexPath: indexPath) as! ArticleContentCell
                    cell.contentLabel.font = UIFont.systemFontOfSize(17)
                    // cell.contentLabel = UILabel(frame: CGRect(x: 0, y: 20, width: 20, height: 20))
                    var str = notice!.content + "\n\n"
                    cell.contentLabel.numberOfLines = 0
                    cell.contentLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
                    cell.contentLabel.text = str
                    cell.contentLabel.sizeToFit()
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier("shareLinkCell", forIndexPath: indexPath) as! UITableViewCell
                    let button = cell.viewWithTag(1005) as! UIButton
                    button.setTitle("链接🔗 \(notice!.title)", forState: UIControlState.Normal)
                    button.setTitle("链接🔗 \(notice!.title)", forState: UIControlState.Highlighted)
                    button.setTitle("链接🔗 \(notice!.title)", forState: UIControlState.Selected)
                    return cell
                }
            }
        } else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier("usernameCell") as! UITableViewCell
            let label = cell.viewWithTag(1002) as! UILabel
            if is_article == true{
                label.text = article!.userName
            }else {
                label.text = notice!.userName
            }
            return cell
        } else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCellWithIdentifier("likeCell") as! UITableViewCell
            let label = cell.viewWithTag(1004) as! UILabel
           // let button = cell.viewWithTag(1003) as! UIButton
           // button.enabled = true
            let editButton = cell.viewWithTag(1010) as! UIButton
            let deleteButton = cell.viewWithTag(1011) as! UIButton
            let reportButton = cell.viewWithTag(1021) as! UIButton
            if is_article == true{
                if configue.objectForKey("report") as! Bool == false{
                    reportButton.enabled = false
                    reportButton.userInteractionEnabled = false
                    reportButton.setTitle("", forState: UIControlState.Disabled)
                }
                //reportButton.enabled = true
                //reportButton.userInteractionEnabled = true
                
                label.text = "\(article!.likeNum)人 已赞"
                if article!.userId == AVUser.currentUser().objectId{
                    if article!.is_link == true {
                        editButton.enabled = false
                        editButton.userInteractionEnabled = false
                        editButton.setTitle("", forState: UIControlState.Disabled)
                    }
                }else {
                    editButton.enabled = false
                    editButton.userInteractionEnabled = false
                    editButton.setTitle("", forState: UIControlState.Disabled)
                    deleteButton.enabled = false
                    deleteButton.userInteractionEnabled = false
                    deleteButton.setTitle("", forState: UIControlState.Disabled)
                }
            }else {
                label.text = "\(notice!.likeNum)人 已赞"
                reportButton.enabled = false
                reportButton.userInteractionEnabled = false
                reportButton.setTitle("", forState: UIControlState.Disabled)
                
                editButton.enabled = false
                editButton.userInteractionEnabled = false
                editButton.setTitle("", forState: UIControlState.Disabled)
                deleteButton.enabled = false
                deleteButton.userInteractionEnabled = false
                deleteButton.setTitle("", forState: UIControlState.Disabled)
            }
            
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentCell
            //cell.avartar.image = UIImage(named: "1")
            var commentItem = commentList[indexPath.row-4]
            cell.userName.text = commentItem.username
            
            cell.contentLabel.font = UIFont.systemFontOfSize(17)
            // cell.contentLabel = UILabel(frame: CGRect(x: 0, y: 20, width: 20, height: 20))
            var str = commentItem.content
            cell.contentLabel.numberOfLines = 0
            cell.contentLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            cell.contentLabel.text = str
            cell.contentLabel.sizeToFit()
            cell.avartar.image = commentItem.avartar
            cell.avartar.layer.cornerRadius = cell.avartar.frame.width/2
            cell.avartar.layer.masksToBounds = true
            return cell
        }
        
        

        // Configure the cell...

       // return cell
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
