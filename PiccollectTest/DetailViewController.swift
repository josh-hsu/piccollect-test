//
//  DetailViewController.swift
//  PiccollectTest
//
//  Created by Josh Hsu on 2015/10/29.
//  Copyright © 2015年 Josh Hsu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var mImageView: UIImageView!
    var meal: Meal?
    @IBOutlet weak var mScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mScrollView.delegate = self;
        mScrollView.minimumZoomScale = 0.5;
        mScrollView.maximumZoomScale = 6.0;

        if let meal = meal {
            mImageView.image = meal.photo
        }
        
        mScrollView.zoomToRect(self.mImageView.frame, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.mImageView
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
