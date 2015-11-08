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
    @IBOutlet weak var mScrollView: UIScrollView!
    let mTotalPage = 10; //TODO: Change it to the var later
    var mImageView: UIImageView?
    var mSubViewControllers: NSMutableArray = []
    var mSubScrollView: UIScrollView?
    var mSubImageView: UIImageView?
    
    //MARK: Local Variable
    var meals: [Meal]?
    var currentPage: Int?
    var isZoomed = [Int](count: 256, repeatedValue: 0)
    var nowInThePage = 0
    var zoomLevelMin = CGFloat(1.0)
    var pageControlUsed = false
    
    
    //MARK: Prepare view
    /*
     * This should be called before viewDidLoad
     * Besically, we initial our outter scroll view here
     */
    func prepareLoading() {
        // put null to the subview controller array
        let controllers: NSMutableArray = NSMutableArray()
        for (var i = 0; i < mTotalPage; i++)
        {
            controllers.addObject(NSNull())
        }
        self.mSubViewControllers = controllers
        
        // a page is the width of the scroll view
        mScrollView.pagingEnabled = true;
        mScrollView.contentSize = CGSizeMake(CGFloat(750 * mTotalPage), 1334);
        mScrollView.showsHorizontalScrollIndicator = false;
        mScrollView.showsVerticalScrollIndicator = false;
        mScrollView.scrollsToTop = false;
        mScrollView.delegate = self;
        mScrollView.autoresizesSubviews = true;
        
        // not sure if this is necessary because it's not initialized yet
        //mScrollView.addSubview(mSubScrollView!)

        // pages are created on demand
        // load the visible page
        // load the page on either side to avoid flashes when the user starts scrolling
        //
        print("View delegate part did finish");
        
        self.initialZoomList()
        
        self.loadScrollViewWithPage(0)
        self.loadScrollViewWithPage(1)
        self.changePage(0)

    }
    
    /* 
     * 用來初始化到底哪些頁面已經放大過，這是為了修正頁面初始化會放大的問題
     */
    func initialZoomList() {
        for (var i = 0; i < mTotalPage; i++) {
            isZoomed[i] = 1;
        }
    }
    
    //MARK: Scroll view control
    func loadScrollViewWithPage(page: Int) {
        nowInThePage = page;
        print("Now in page ", page)
    
        if (page < 0) {
            return
        }
        
        if (page >= mTotalPage) {
            return;
        }
        
        // replace the placeholder if necessary
        var subviewController = mSubViewControllers.objectAtIndex(page)

        if (subviewController as! NSObject == NSNull()) {
            print("This subview controll needs to be initialized")
            subviewController = self.storyboard!.instantiateViewControllerWithIdentifier("detailPageSubview")
            mSubViewControllers.replaceObjectAtIndex(page, withObject:subviewController);
        }

        // assign subview
        if let subviewController = subviewController as? DetailSubviewController {
            subviewController.mSubScrollView = subviewController.view.viewWithTag(401) as? UIScrollView
            subviewController.mSubImageView = subviewController.view.viewWithTag(400) as? UIImageView
        }
        mSubScrollView = subviewController.mSubScrollView
        mSubImageView = subviewController.mSubImageView
    
        mSubScrollView!.scrollEnabled = true
        mSubScrollView!.pagingEnabled = false
        mSubScrollView!.showsHorizontalScrollIndicator = false
        mSubScrollView!.showsVerticalScrollIndicator = false
        mSubScrollView!.scrollsToTop = false
        mSubScrollView!.delegate = self;
        mSubScrollView!.multipleTouchEnabled = true
        mSubScrollView!.userInteractionEnabled = true //只要有以上兩行就可以直接有pinch to zoom的效果了
    
        // add the controller's view to the scroll view
        if (subviewController.view!!.superview == nil) {
            var frame: CGRect = mScrollView.frame;
            frame.origin.x = CGFloat(Int(frame.size.width) * page)
            frame.origin.y = 0;
            subviewController.view!!.frame = frame;
    
            //先預載內建讀取中的圖示
            let img = meals![page].photo
            subviewController.mSubImageView!!.image = img
            subviewController.mSubImageView!!.frame = CGRect(origin: CGPointMake(0.0, 0.0), size: img!.size)
            mSubScrollView!.contentSize = img!.size //contentSize 一開始就要設定成跟圖片一樣大
    
            let minimumScale : CGFloat = MIN(vala: mSubScrollView!.frame.size.width  / mSubScrollView!.contentSize.width,
                valb: mSubScrollView!.frame.size.height / mSubScrollView!.contentSize.height)
            mSubScrollView!.setZoomScale(minimumScale, animated: false) //按照 scrollview frame 的 size 在一開始調整到符合螢幕顯示
    
            mScrollView.addSubview(subviewController.view!!)
            self.centerScrollViewContents()
        }
    }
    
    func changePage(page: Int) {
        print("Change to page ", page)
        // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
        self.loadScrollViewWithPage(page - 1)
        self.loadScrollViewWithPage(page + 1)
        self.loadScrollViewWithPage(page)
    
        // update the scroll view to the appropriate page
        var frame: CGRect = mScrollView.frame;
        frame.origin.x = CGFloat(Int(frame.size.width) * page)
        frame.origin.y = 0;
        mScrollView.scrollRectToVisible(frame, animated:false)
    
        nowInThePage = page;
    
        // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
        //pageControlUsed = YES;
    }
    
    //MARK: Override default view functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareLoading()
        /*
        mScrollView.delegate = self;
        mImageView = UIImageView.init()
        
        mImageView?.image = meals![currentPage!].photo
        mImageView?.frame = CGRectMake(0, 0, mImageView!.image!.size.width, mImageView!.image!.size.height)
        
        mScrollView.addSubview(mImageView! as UIView)
        mScrollView.contentSize = mImageView!.image!.size; //This is important or you will crash when zoom in
        */
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnTap = true
        /*
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
        centerScrollViewContents()*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
        // which a scroll event generated from the user hitting the page control triggers updates from
        // the delegate method. We use a boolean to disable the delegate logic when the page control is use.
    
        if (scrollView == mScrollView){
            if (pageControlUsed) {
                // do nothing - the scroll was initiated from the page control, not the user dragging
                return;
            }
    
            // Switch the indicator when more than 50% of the previous/next page is visible
            let pageWidth: CGFloat = mScrollView.frame.size.width;
            let page = floor((mScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
            // 為了解決zoomScale會變成1的問題
            if((isZoomed[Int(page)] == 1) && (mSubScrollView!.zoomScale == 1.0)){
                let pointInView: CGPoint = CGPointMake(0.0, 0.0);
                let rectToZoomTo: CGRect = self.zoomRectForScale(withScale: zoomLevelMin, withCenter: pointInView)
                mSubScrollView!.zoomToRect(rectToZoomTo, animated:false)
    
                isZoomed[Int(page)] = 0;
            }
    
            // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
            self.loadScrollViewWithPage(Int(page) - 1)
            self.loadScrollViewWithPage(Int(page) + 1)
            self.loadScrollViewWithPage(Int(page)) //最後才load顯示的頁面主要是為了使zooming時，imageview是正確的。
        }else if(scrollView == mSubScrollView){
    
        }
    
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
    
        zoomRect.size.height = mSubScrollView!.frame.size.height / scale
        zoomRect.size.width  = mSubScrollView!.frame.size.width / scale
    
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
    
        return zoomRect;
    }
    
    func centerScrollViewContents() {
        let boundsSize : CGSize = self.mSubScrollView!.bounds.size
        var contentsFrame : CGRect = (self.mSubImageView?.frame)!
    
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
