//
//  LoginController.swift
//  PKU Kendo
//
//  Created by Karma Guo on 15/5/11.
//  Copyright (c) 2015年 PKUKendo. All rights reserved.
//

import UIKit
import AVOSCloud

class LoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var usernameField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func login() {
        if usernameField.text == "" || passwordField.text == "" {
            KVNProgress.showErrorWithStatus("用户名/密码不能为空")
            return
        }
        KVNProgress.show()
        AVUser.logInWithUsernameInBackground(usernameField.text, password: passwordField.text){
            (user :AVUser!, error :NSError!) -> Void in
            if error == nil {
                KVNProgress.dismiss()
                KVNProgress.showSuccessWithStatus("登陆成功")
               // if AVInstallation.currentInstallation()
                AVUser.currentUser().setObject(UIDevice.currentDevice().identifierForVendor.UUIDString, forKey: "installation")
                AVUser.currentUser().saveEventually()
                if AVInstallation.currentInstallation() != nil{
                    AVInstallation.currentInstallation().setObject(AVUser.currentUser().objectId, forKey: "userId")
                    AVInstallation.currentInstallation().saveEventually()
                }
                me.username = AVUser.currentUser().username
                me.nickname = AVUser.currentUser().objectForKey("NickName") as? String
                var avartarFile = AVUser.currentUser().objectForKey("Avartar") as? AVFile
                if avartarFile != nil{
                    //   println("asdfasdfasdf")
                    var imgData = avartarFile?.getData()
                    if imgData != nil{
                        me.avartar = UIImage(data: imgData!)
                        me.password = AVUser.currentUser().password
                        me.gender = AVUser.currentUser().objectForKey("gender") as? String
                        me.weixin = AVUser.currentUser().objectForKey("weixin") as? String
                        self.performSegueWithIdentifier("login", sender: nil)
                    }
                    else {
                        KVNProgress.showErrorWithStatus("载入头像失败")
                    }
//                    avartarFile?.getDataInBackgroundWithBlock(){
//                        (imgData:NSData!, error:NSError!) -> Void in
//                        if(error == nil){
//                            me.avartar = UIImage(data: imgData)
//                            me.password = AVUser.currentUser().password
//                            me.gender = AVUser.currentUser().objectForKey("gender") as? String
//                            me.email = AVUser.currentUser().objectForKey("email") as? String
//                            self.performSegueWithIdentifier("login", sender: nil)
//                            //                                self.usrPhoto.imageView!.image = UIImage(data: imgData)
//                            // println("asdfasdfasdf")
//                            //self.tableView.reloadData()
//                        }
//                        else {
//                            KVNProgress.showErrorWithStatus("载入头像失败")
////                            me.password = AVUser.currentUser().password
////                            me.gender = AVUser.currentUser().objectForKey("gender") as? String
////                            me.email = AVUser.currentUser().objectForKey("email") as? String
////                            self.navigationController?.popViewControllerAnimated(true)
//                        
//                        }
//                    }
                }
                else {
                    //me.avartar = UIImage(named: "1")
                    me.password = AVUser.currentUser().password
                    me.gender = AVUser.currentUser().objectForKey("gender") as? String
                    if me.gender == "男"{
                        me.avartar = UIImage(named: "男生默认头像")
                    }else {
                        me.avartar = UIImage(named: "女生默认头像")
                    }
                    me.weixin = AVUser.currentUser().objectForKey("weixin") as? String
                    self.performSegueWithIdentifier("login", sender: nil)
                }
            }
            else {
                KVNProgress.dismiss()
                KVNProgress.showErrorWithStatus("用户名或密码错误")
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        //        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
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
