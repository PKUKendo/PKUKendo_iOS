//
//  VerifyMobileViewController.swift
//  PKUKendo
//
//  Created by Karma Guo on 6/20/15.
//  Copyright (c) 2015 Karma Guo. All rights reserved.
//

import UIKit

class VerifyMobileViewController: UIViewController {
    
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var codeField: UITextField!
    
    
    @IBOutlet weak var finishButton: UIButton!
    
    
    @IBAction func gotoNext(sender: UIButton) {
        if codeField.text.isEmpty != true && codeField.text.toInt() != nil && count(codeField.text) == 6{
            KVNProgress.show()
            AVUser.verifyMobilePhone(codeField.text){
                (success:Bool, error:NSError!) -> Void in
                if success == true{
                    AVUser.logInWithUsernameInBackground(self.user.username, password: self.user.password){
                        (user :AVUser!, error :NSError!) -> Void in
                        if user != nil {
                            me.username = AVUser.currentUser().username
                            me.nickname = AVUser.currentUser().objectForKey("NickName") as? String
                             me.avartar = UIImage(named: "1")
                            me.password = AVUser.currentUser().password
                            me.gender = AVUser.currentUser().objectForKey("gender") as? String
                            me.email = AVUser.currentUser().objectForKey("email") as? String
                            self.performSegueWithIdentifier("signup", sender: nil)
                            
                            KVNProgress.dismiss()
                            KVNProgress.showSuccessWithStatus("注册成功")
                        }else {
                            KVNProgress.dismiss()
                            KVNProgress.showErrorWithStatus("网络错误")
                        }
                    }
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

                }else {
                    KVNProgress.dismiss()
                    KVNProgress.showErrorWithStatus("验证失败")
                }
            }
        }
        
        
    }
    
    
    var user:AVUser!
    
    @IBAction func sendCode(sender: JKCountDownButton) {
        
        if phoneField.text.isEmpty != true && phoneField.text.toInt() != nil && count(phoneField.text) == 11{
        
            sender.enabled = false
            user.mobilePhoneNumber = phoneField.text
            println("\(user.username)")
            KVNProgress.show()
            user.signUpInBackgroundWithBlock(){
                (success:Bool, error:NSError!) -> Void in
                if success == true{
                    KVNProgress.dismiss()
                    self.finishButton.enabled = true
                    self.finishButton.userInteractionEnabled = true
                    sender.startWithSecond(60)
                    sender.didChange(){
                        (countDownButton:JKCountDownButton!, second:Int32) -> String! in
                        return "剩余\(second)秒"
                    }
                    sender.didFinished(){
                        (button:JKCountDownButton!, second:Int32) -> String! in
                        return "重新获取"
                    }
                }else {
                    sender.enabled = true
                    KVNProgress.dismiss()
                    KVNProgress.showErrorWithStatus("用户名重复或网络错误")
                }
            }
            //AVUser.verifyMobilePhone(<#code: String!#>, withBlock: <#AVBooleanResultBlock!##(Bool, NSError!) -> Void#>)
            
            
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.finishButton.enabled = false
        self.finishButton.userInteractionEnabled = false
        
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
