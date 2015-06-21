//
//  WebViewController.swift
//  PKUKendo
//
//  Created by Karma Guo on 6/19/15.
//  Copyright (c) 2015 Karma Guo. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    var url:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        let requestURL = NSURL(string: url)
        println(url)
        if requestURL != nil{
            let request = NSURLRequest(URL: requestURL!)
            webView.loadRequest(request)
        }
        
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var webView: UIWebView!
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
