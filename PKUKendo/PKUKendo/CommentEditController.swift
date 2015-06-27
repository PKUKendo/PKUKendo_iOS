//
//  CommentEditController.swift
//  PKUKendo
//
//  Created by Karma Guo on 6/19/15.
//  Copyright (c) 2015 Karma Guo. All rights reserved.
//

import UIKit

class CommentEditController: UIViewController ,UITextViewDelegate{
    
    var articleId:String!
    var is_article:Bool!
    var userId:String?
    var articleTitle:String!
    
   // @IBOutlet weak var textView: UITextView!
    
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func send(sender: UIBarButtonItem) {
        if textView.text.isEmpty != true {
            var comment = AVObject(className: "Comment")
            comment.setObject(AVUser.currentUser(), forKey: "user")
            comment.setObject(textView.text, forKey: "content")
            comment.setObject(articleId, forKey: "articleId")
            KVNProgress.show()
            comment.saveInBackgroundWithBlock(){
                (success:Bool, error:NSError!) -> Void in
                if success == true{
                    if self.is_article == true {
                        var query = AVQuery(className: "Article")
                        var article = query.getObjectWithId(self.articleId)
                        article.incrementKey("commentNum")
                        article.save()
                    }else {
                        var query = AVQuery(className: "Notice")
                        var article = query.getObjectWithId(self.articleId)
                        article.incrementKey("commentNum")
                        article.save()
                    }
                    KVNProgress.dismiss()
                 //   KVNProgress.showSuccessWithStatus("发表成功")
                    if self.is_article == true && self.userId! != AVUser.currentUser().objectId{
                        var pushQ = AVInstallation.query()
                        pushQ.whereKey("userId", equalTo: self.userId!)
                        var push = AVPush()
                        push.setQuery(pushQ)
                        push.setMessage("您的文章\(self.articleTitle)收到一条回复")
                        push.sendPushInBackground()
                    }
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    KVNProgress.dismiss()
                    KVNProgress.showErrorWithStatus("网络错误")
                }
            }
        }else{
            KVNProgress.showErrorWithStatus("评论内容不能为空")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.textColor = UIColor.lightGrayColor()
        textView.text = "点击此处编辑"

        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "点击此处编辑"
            textView.textColor = UIColor.lightGrayColor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
