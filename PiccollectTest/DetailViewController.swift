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
    var mImageView: UIImageView?
    var meal: Meal?
    @IBOutlet weak var mScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mScrollView.delegate = self;
        mImageView = UIImageView.init()
        
        if let meal = meal {
            mImageView?.image = meal.photo
            mImageView?.frame = CGRectMake(0, 0, mImageView!.image!.size.width, mImageView!.image!.size.height)
        }
        
        mScrollView.addSubview(mImageView! as UIView)
        mScrollView.contentSize = mImageView!.image!.size; //This is important or you will crash when zoom in
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnTap = true
        
        // 4
        let scrollViewFrame : CGRect = self.mScrollView.frame
        let scaleWidth : CGFloat = scrollViewFrame.size.width / self.mScrollView.contentSize.width
        let scaleHeight : CGFloat = scrollViewFrame.size.height / self.mScrollView.contentSize.height
        let minScale : CGFloat = MIN(vala: scaleWidth, valb: scaleHeight)
        self.mScrollView.minimumZoomScale = minScale;
        
        // 5
        self.mScrollView.maximumZoomScale = 3.0;
        self.mScrollView.zoomScale = minScale;
        
        // 6
        centerScrollViewContents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.mImageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        // The scroll view has zoomed, so you need to re-center the contents
        centerScrollViewContents()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Utility
    func zoomRectForScale(withScale scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        var zoomRect: CGRect;
        
        zoomRect = CGRect();
    
        zoomRect.size.height = mScrollView.frame.size.height / scale
        zoomRect.size.width  = mScrollView.frame.size.width / scale
    
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
    
        return zoomRect;
    }
    
    func centerScrollViewContents() {
        let boundsSize : CGSize = self.mScrollView.bounds.size
        var contentsFrame : CGRect = (self.mImageView?.frame)!
    
        if (contentsFrame.size.width < boundsSize.width) {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0;
        } else {
            contentsFrame.origin.x = 0.0;
        }
    
        if (contentsFrame.size.height < boundsSize.height) {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0;
        } else {
            contentsFrame.origin.y = 0.0;
        }
    
        self.mImageView?.frame = contentsFrame;
    }
    
    func MIN(vala a : CGFloat, valb b : CGFloat) -> CGFloat {
        if (a > b) {
            return b
        } else {
            return a
        }
    }

}
