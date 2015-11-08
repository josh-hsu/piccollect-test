//
//  DetailSubviewController.swift
//  PiccollectTest
//
//  Created by Josh Hsu on 2015/11/8.
//  Copyright © 2015年 Josh Hsu. All rights reserved.
//

import UIKit

class DetailSubviewController: UIViewController {

    var mSubScrollView: UIScrollView?
    var mSubImageView: UIImageView?
    
    var mPageNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func initView(imag: UIImageView, scroll: UIScrollView) {
        mSubImageView = imag
        mSubScrollView = scroll
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
