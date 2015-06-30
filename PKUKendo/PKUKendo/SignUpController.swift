//
//  SignUpController.swift
//  PKUKendo
//
//  Created by Karma Guo on 5/13/15.
//  Copyright (c) 2015 PKUKendo. All rights reserved.
//

import UIKit
import AVOSCloud
class SignUpController: UIViewController {

    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var nickNameField: UITextField!
    
    
    @IBOutlet weak var codeField: UITextField!
    
    
    @IBOutlet weak var setPasswordField: UITextField!
    
    
    @IBOutlet weak var ensurePasswordField: UITextField!
    
    
    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBOutlet var gender: UISegmentedControl!
    
    var user:AVUser = AVUser()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

//    override func viewDidAppear(animated: Bool) {
//        let SignUp = UIAlertController(title: "用户协议", message: "本应用作为北京大学剑道社内部以及剑道爱好者之间的交流平台, 不欢迎任何商业广告和无关话题. 发言者对自己发表的任何言论,信息负责", preferredStyle: UIAlertControllerStyle.Alert)
//        let shareLinkAction = UIAlertAction(title: "不同意以上协议", style: .Default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            self.navigationController?.popViewControllerAnimated(true)
//        })
//        let postArticleAction = UIAlertAction(title: "同意以上协议", style: .Default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            //self.performSegueWithIdentifier("postArticle", sender: sender)
//            //self.tableView.header.beginRefreshing()
//        })
//        
//        
//        
//        SignUp.addAction(shareLinkAction)
//        //optionMenu.addAction(shareLinkAction)
//        SignUp.addAction(postArticleAction)
//        self.presentViewController(SignUp, animated: true, completion: nil)
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        (segue.destinationViewController as! VerifyMobileViewController).user = user
//    }
    
    @IBAction func SignUp(sender: UIButton) {
        
        if userNameField.text == "" || nickNameField.text == "" || setPasswordField.text == "" || ensurePasswordField.text == "" {
            KVNProgress.showErrorWithStatus("无效的用户名/昵称/密码")
            return
        }
        
        if setPasswordField.text != ensurePasswordField.text {
            KVNProgress.showErrorWithStatus("密码不一致")
            return
        }
        
        //var user = AVUser()
        user.username = userNameField.text
        user.password = setPasswordField.text
        user.setObject(nickNameField.text, forKey: "NickName")
        if gender.selectedSegmentIndex == 0{
            user.setObject("男", forKey: "gender")
        }else if gender.selectedSegmentIndex == 1 {
            user.setObject("女", forKey: "gender")
        }else {
            user.setObject("保密", forKey: "gender")
        }
        
        if codeField.text != "" {
            KVNProgress.show()
            var query = AVQuery(className: "Code")
            query.whereKey("code", equalTo: codeField.text)
            query.findObjectsInBackgroundWithBlock(){
                (result:[AnyObject]!, error:NSError!) -> Void in
                if error == nil && result.count > 0{
                    //KVNProgress.dismiss()
                    //self.performSegueWithIdentifier("next", sender: self)
                    self.user.signUpInBackgroundWithBlock(){
                        (success:Bool, error:NSError!) -> Void in
                        if success == true{
                            AVUser.logInWithUsernameInBackground(self.user.username, password: self.user.password){
                                (user :AVUser!, error :NSError!) -> Void in
                                if user != nil {
                                    AVUser.currentUser().setObject(UIDevice.currentDevice().identifierForVendor.UUIDString, forKey: "installation")
                                    AVUser.currentUser().saveEventually()
                                    if AVInstallation.currentInstallation() != nil{
                                        AVInstallation.currentInstallation().setObject(AVUser.currentUser().objectId, forKey: "userId")
                                        AVInstallation.currentInstallation().saveEventually()
                                    }
                                    me.username = AVUser.currentUser().username
                                    me.nickname = AVUser.currentUser().objectForKey("NickName") as? String
                                    me.avartar = UIImage(named: "1")
                                    me.password = AVUser.currentUser().password
                                    me.gender = AVUser.currentUser().objectForKey("gender") as? String
                                    if me.gender == "男"{
                                        me.avartar = UIImage(named: "男生默认头像")
                                    }else {
                                        me.avartar = UIImage(named: "女生默认头像")
                                    }
                                    me.weixin = AVUser.currentUser().objectForKey("weixin") as? String
                                    self.performSegueWithIdentifier("signup", sender: nil)
                                    
                                    KVNProgress.dismiss()
                                    KVNProgress.showSuccessWithStatus("注册成功")
                                }else {
                                    KVNProgress.dismiss()
                                    KVNProgress.showErrorWithStatus("网络错误")
                                }
                            }
                            
                        }else {
                            //sender.enabled = true
                            KVNProgress.dismiss()
                            KVNProgress.showErrorWithStatus("用户名重复或网络错误")
                        }
                    }
                }else {
                    KVNProgress.dismiss()
                    KVNProgress.showErrorWithStatus("邀请码错误")
                }
            }
        } else {
            KVNProgress.showErrorWithStatus("请输入邀请码")
            return
        }
        
        //user.setObject(gender, forKey: <#String!#>)
       // self.performSegueWithIdentifier("next", sender: self)
       // user.setObject(gender, forKey: <#String!#>)
//        KVNProgress.showWithStatus(" ")
//        user.signUpInBackgroundWithBlock(){
//            (success:Bool, error:NSError!) -> Void in
//            if success {
//               // AVUser.logOut()
//                AVUser.logInWithUsernameInBackground(self.userNameField.text, password: self.setPasswordField.text){
//                    (user :AVUser!, error :NSError!) -> Void in
//                    if user != nil {
//                        KVNProgress.dismiss()
//                        KVNProgress.showSuccessWithStatus("注册成功")
//                        me.username = AVUser.currentUser().username
//                        me.nickname = AVUser.currentUser().objectForKey("NickName") as? String
//                        var avartarFile = AVUser.currentUser().objectForKey("Avartar") as? AVFile
//                        if avartarFile != nil{
//                            //   println("asdfasdfasdf")
//                            avartarFile?.getDataInBackgroundWithBlock(){
//                                (imgData:NSData!, error:NSError!) -> Void in
//                                if(error == nil){
//                                    me.avartar = UIImage(data: imgData)
//                                    //                                self.usrPhoto.imageView!.image = UIImage(data: imgData)
//                                    // println("asdfasdfasdf")
//                                    //self.tableView.reloadData()
//                                }
//                            }
//                        } else {
//                            me.avartar = UIImage(named: "1")
//                        }
//                        me.password = AVUser.currentUser().password
//                        me.gender = AVUser.currentUser().objectForKey("gender") as? String
//                        me.email = AVUser.currentUser().objectForKey("email") as? String
//                        self.performSegueWithIdentifier("signup", sender: nil)
//                    }
//                    else{
//                        KVNProgress.dismiss()
//                        KVNProgress.showErrorWithStatus("注册失败")
//                    }
//                }
//                //self.navigationController?.popViewControllerAnimated(true)
//            }
//            else {
//                KVNProgress.dismiss()
//                KVNProgress.showErrorWithStatus("注册失败")
//            }
//        }
        
        
        
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
