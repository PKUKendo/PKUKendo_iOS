//
//  navigationViewController.swift
//  SiXinWen-iOS
//
//  Created by admin on 15/4/3.
//  Copyright (c) 2015年 SiXinWen. All rights reserved.
//

import UIKit

class navigationViewController: UINavigationController {

    
    
    var showNewsContent:() -> () = {}
    var willHideNewsContent:() -> () = {}
    var hideNewsContent:() -> () = {}

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let commentViewController = CommentTableViewController ()
        setViewControllers([commentViewController], animated: false)

        
        
        
        
        let content = newsContentView(viewController: self)
        
        //        content.showContent()
        //
        showNewsContent = {
            content.showContent()
        }
        
        willHideNewsContent = {
            
            content.hideContent()
        }
        
        hideNewsContent = {
            content.contentController = nil
        }
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        willHideNewsContent()
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        hideNewsContent()
        //
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
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
