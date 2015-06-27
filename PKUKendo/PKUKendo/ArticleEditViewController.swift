//
//  ArticleEditViewController.swift
//  PKUKendo
//
//  Created by Karma Guo on 6/20/15.
//  Copyright (c) 2015 Karma Guo. All rights reserved.
//

import UIKit

protocol ArticleEditViewControllerDelegate:class{
    func editFinishWithContent(content:String,AndTitle title:String)
}

class ArticleEditViewController: UIViewController {
    var id:String!
    var titleText:String!
    weak var delegate : ArticleEditViewControllerDelegate?
    var content:String!
    
    
    
    
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var contentView: UITextView!

    @IBAction func send(sender: UIBarButtonItem) {
        if titleField.text.isEmpty != true && contentView.text.isEmpty != true {
            var query = AVQuery(className: "Article")
            KVNProgress.show()
            //query.getObjectInBackgroundWithId(id, block: <#AVObjectResultBlock!##(AVObject!, NSError!) -> Void#>)
            query.getObjectInBackgroundWithId(id){
                (result:AVObject!,error: NSError!) -> Void in
                if error == nil{
                    result.setObject(self.titleField.text, forKey: "title")
                    result.setObject(self.contentView.text, forKey: "content")
//                    result.save()
//                    KVNProgress.dismiss()
//                    KVNProgress.showSuccessWithStatus("编辑成功")
                    result.saveInBackgroundWithBlock(){
                        (success:Bool, error:NSError!) -> Void in
                        if success == true{
                            KVNProgress.dismiss()
                            KVNProgress.showSuccessWithStatus("编辑成功")
                            self.delegate?.editFinishWithContent(self.contentView.text, AndTitle: self.titleField.text)
                            
                            self.navigationController?.popViewControllerAnimated(true)
                            
                        } else {
                            KVNProgress.dismiss()
                            KVNProgress.showErrorWithStatus("网络错误")
                        }
                    }
                }else {
                    KVNProgress.dismiss()
                    KVNProgress.showErrorWithStatus("网络错误")
                }
            }
            
        }else{
            KVNProgress.showErrorWithStatus("标题或内容不能为空")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.text = titleText
        contentView.text = content

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
