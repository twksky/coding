//
//  ChoiceHeaderView.swift
//  cxd4iphone
//
//  Created by hexy on 11/28/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit
import Kingfisher

private struct kConstraints {
    
    static let reuseIdentifier: String = "CarouselCellReuseIdentifier"
    static let pageControlHeight: CGFloat = 20
}

class CarouselView: UIView {

    func setImages(imageURLs: [NSURL], timeInterval: NSTimeInterval? = 5.0, clickImageBlock: ((index: Int) -> ())? = nil) {
        
        self.imageURLs = imageURLs
        
        if timeInterval != nil {
            
            self.timeInterval = timeInterval!
        }
        
        self.clickImageBlock = clickImageBlock
        
        pageControl.numberOfPages = imageURLs.count
        collectionView.reloadData()
        
        startTimer()
    }
    
    override func layoutSubviews() {
        
        collectionView.frame = self.bounds
        pageControl.frame = CGRectMake(0, self.bounds.height - kConstraints.pageControlHeight, self.bounds.width, kConstraints.pageControlHeight)
        
        moveToCenter()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        
        backgroundColor = UIColor.whiteColor()
        
        addSubview(collectionView)
        addSubview(pageControl)
        
    }
    
    ///  跳到中间张
    private func moveToCenter() {
        
        guard let visiableIndexPath = collectionView.indexPathsForVisibleItems().last else { return }
        let defaultIndexPath = NSIndexPath(forItem: defaultSelectImage(), inSection: visiableIndexPath.section)
        collectionView.scrollToItemAtIndexPath(defaultIndexPath, atScrollPosition: .Left, animated: false)
    }
    /// 停止时钟
    func stopTimer() {
        
        timer?.invalidate()
        timer = nil
    }
    
    /// 开启时钟
    func startTimer() {
        
        if imageURLs?.count <= 1 || timer != nil { return }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(timeInterval, target: self, selector: "nextPic", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    
    @objc private func nextPic() {
        
        guard let visiableIndexPath = collectionView.indexPathsForVisibleItems().last else { return }
        
        
        if 0 == visiableIndexPath.item % (self.imageURLs?.count)! {
            
//            moveToCenter()
        }
        
        let nextIndexPath = NSIndexPath(forItem: visiableIndexPath.item + 1, inSection: visiableIndexPath.section)
        
        collectionView.scrollToItemAtIndexPath(nextIndexPath, atScrollPosition: .Left, animated: true)
    }
    
    func totalImagesInSection() -> Int {
        
        guard let total = imageURLs?.count else { return 0 }
        
        return (total > 1) ? total * 10000 : 1
    }
    
    func defaultSelectImage() -> Int {
        
        return (totalImagesInSection() > 1) ? totalImagesInSection() / 2 : 1
    }
    
    private lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: CarouselFlowLayout())
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(CarouselCell.self, forCellWithReuseIdentifier: kConstraints.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        
        let page = UIPageControl()
        page.userInteractionEnabled = false
        page.currentPageIndicatorTintColor = UIColor.whiteColor()
        page.pageIndicatorTintColor = xx_colorWithHex(hexValue: 0xffffff, alpha: 0.4)
        page.hidesForSinglePage = true
        return page
    }()
    
    private var clickImageBlock: ((index: Int) -> ())?

    private var imageURLs: [NSURL]?

    private var timer: NSTimer?

    private var timeInterval: NSTimeInterval = 5.0
    
}

// MARK: - 自定义 collectionView 布局
private class CarouselFlowLayout: UICollectionViewFlowLayout {
    
    private override func prepareLayout() {
        
        itemSize = collectionView!.bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .Horizontal
        
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.bounces = false
        
        super.prepareLayout()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension CarouselView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return totalImagesInSection()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kConstraints.reuseIdentifier, forIndexPath: indexPath) as! CarouselCell
        cell.imageURL = imageURLs![indexPath.item % imageURLs!.count]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let offset = collectionView.indexPathsForVisibleItems().last?.item else { return }
        pageControl.currentPage = offset % imageURLs!.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        clickImageBlock?(index: indexPath.item % imageURLs!.count)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        stopTimer()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        startTimer()
    }
    
}

// MARK: - 自定义Cell
private class CarouselCell: UICollectionViewCell {
    
    var imageURL: NSURL? {
        
        didSet {
            
            guard let imageURL = imageURL else { return }
            
            imageView.kf_showIndicatorWhenLoading = true
            imageView.kf_setImageWithURL(imageURL, placeholderImage: nil, optionsInfo: [.Transition(ImageTransition.Fade(1))])
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        
        imageView.frame = self.bounds
        
//        imageView.contentMode = .ScaleAspectFill
        contentView.addSubview(imageView)
//        imageView.snp_makeConstraints { (make) -> Void in
//            
//            make.edges.equalTo(self)
//        }
    }
    
    private var imageView = UIImageView(bgColor: xx_colorWithHex(hexValue: 0xf6f6f6))
    
}
