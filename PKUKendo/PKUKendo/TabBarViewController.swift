//
//  TabBarViewController.swift
//  PKUKendo
//
//  Created by Karma Guo on 6/20/15.
//  Copyright (c) 2015 Karma Guo. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let items = self.tabBar.items as! [UITabBarItem]
        items[3].selectedImage = UIImage(named: "man")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        items[3].image = UIImage(named: "manbw")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        items[0].selectedImage = UIImage(named: "jian")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        items[0].image = UIImage(named: "jianbw")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        items[1].selectedImage = UIImage(named: "kote")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        items[1].image = UIImage(named: "kotebw")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        items[2].selectedImage = UIImage(named: "dou")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        items[2].image = UIImage(named: "doubw")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        self.tabBarController?.tabBar.selectedItem?.image = UIImage(named: "123")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        //        self.tabBarController?.tabBarItem.
//        self.tabBarController?.tabBar.selectedItem?.selectedImage = UIImage(named: "123")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
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
