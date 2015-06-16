//
//  aboutUsController.swift
//  PKU Kendo
//
//  Created by Karma Guo on 15/5/11.
//  Copyright (c) 2015年 PKUKendo. All rights reserved.
//

import UIKit

class aboutUsController: UIViewController {

    @IBOutlet var iconView: UIImageView!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.setNeedsStatusBarAppearanceUpdate()
        iconView.layer.cornerRadius = 20
        iconView.layer.masksToBounds = true
        iconView.layer.borderColor = UIColor.whiteColor().CGColor
        iconView.layer.borderWidth = 2.3

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func childViewControllerForStatusBarStyle() -> UIViewController? {
//        return self.navigationController
//    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       // self.setNeedsStatusBarAppearanceUpdate()
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
