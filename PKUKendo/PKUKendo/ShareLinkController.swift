//
//  ShareLinkController.swift
//  PKUKendo
//
//  Created by Karma Guo on 6/19/15.
//  Copyright (c) 2015 Karma Guo. All rights reserved.
//

import UIKit

class ShareLinkController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    

    weak var delegate:ArticleChangeViewControllerDelegate?
    
    @IBOutlet weak var linkField: UITextField!
    
    @IBAction func send(sender: UIBarButtonItem) {
        if titleField.text.isEmpty != true && linkField.text.isEmpty != true {
            var arti = AVObject(className: "Article")
            arti.setObject(titleField.text, forKey: "title")
            arti.setObject(linkField.text, forKey: "content")
            arti.setObject(AVUser.currentUser(), forKey: "user")
            arti.setObject(true, forKey: "is_link")
            KVNProgress.show()
            arti.saveInBackgroundWithBlock(){
                (success:Bool, error:NSError!) -> Void in
                if success == true{
                    KVNProgress.dismiss()
                    KVNProgress.showSuccessWithStatus("发表成功")
                    self.delegate?.articleChangeNeedRefresh()
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    KVNProgress.dismiss()
                    KVNProgress.showErrorWithStatus("网络错误")
                }
            }
        }else{
            KVNProgress.showErrorWithStatus("标题或链接不能为空")
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
