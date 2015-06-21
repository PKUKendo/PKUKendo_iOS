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
    
    
    @IBOutlet weak var setPasswordField: UITextField!
    
    
    @IBOutlet weak var ensurePasswordField: UITextField!
    
    
    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBOutlet var gender: UISegmentedControl!
    
    var user:AVUser = AVUser()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as! VerifyMobileViewController).user = user
    }
    
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
        }
        else {
            user.setObject("女", forKey: "gender")
        }
        //user.setObject(gender, forKey: <#String!#>)
        self.performSegueWithIdentifier("next", sender: self)
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
