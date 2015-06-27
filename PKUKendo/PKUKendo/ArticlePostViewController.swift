//
//  ArticleEditViewController.swift
//  PKUKendo
//
//  Created by Karma Guo on 6/19/15.
//  Copyright (c) 2015 Karma Guo. All rights reserved.
//

import UIKit

class ArticlePostViewController: UIViewController ,UITextViewDelegate{
    
    @IBOutlet weak var titleField: UITextField!
    
    
    @IBOutlet weak var contentView: UITextView!

    @IBAction func send(sender: UIBarButtonItem) {
        if titleField.text.isEmpty != true && contentView.text.isEmpty != true {
            var arti = AVObject(className: "Article")
            arti.setObject(titleField.text, forKey: "title")
            arti.setObject(contentView.text, forKey: "content")
            arti.setObject(AVUser.currentUser(), forKey: "user")
            KVNProgress.show()
            arti.saveInBackgroundWithBlock(){
                (success:Bool, error:NSError!) -> Void in
                if success == true{
                    KVNProgress.dismiss()
                    KVNProgress.showSuccessWithStatus("发表成功")
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    KVNProgress.dismiss()
                    KVNProgress.showErrorWithStatus("网络错误")
                }
            }
        }else {
            KVNProgress.showErrorWithStatus("内容或标题不能为空")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.text = "点击编辑内容"
        contentView.textColor = UIColor.lightGrayColor()
        

        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if contentView.textColor == UIColor.lightGrayColor() {
            contentView.text = ""
            contentView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if contentView.text.isEmpty {
            contentView.text = "点击编辑内容"
            contentView.textColor = UIColor.lightGrayColor()
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
