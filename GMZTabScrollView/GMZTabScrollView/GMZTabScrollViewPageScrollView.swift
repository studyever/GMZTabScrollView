//
//  GMZTabScrollViewPageScrollView.swift
//  GMZTabScrollView
//
//  Created by meizhen on 2019/2/27.
//  Copyright © 2019 meizhen. All rights reserved.
//

import UIKit

let pageCollectionViewCellIdentifier = "PageCollectionViewCllIdentifier"

protocol GMZTabScrollPageScrollViewDataSource : NSObjectProtocol {
    func pageView(_ pageView: GMZTabScrollViewPageScrollView, numOfPageViewInSection: Int) -> Int
    
    func pageView(_ pageView: GMZTabScrollViewPageScrollView, viewForItemAt indexPath: IndexPath, pageSize: CGSize) -> UIView
    
}


protocol GMZTabScrollPageScrollViewDelegate: NSObjectProtocol {
    func pageViewDidScroll(_ pageView: GMZTabScrollViewPageScrollView)
    
    func pageViewDidEndDecelerating(_ pageView: GMZTabScrollViewPageScrollView)
}


class GMZTabScrollViewPageScrollView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    weak var pageScrollViewDataSource: GMZTabScrollPageScrollViewDataSource? = nil
    weak var pageScrollViewDelegate: GMZTabScrollPageScrollViewDelegate? = nil
    private var pageViewSize: CGSize = .zero
    private var pageViewCount: Int = 0
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.dataSource = self
        self.delegate = self
        self.isPagingEnabled = true
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.alwaysBounceHorizontal = true
        self.register(PageCollectionViewCell.self, forCellWithReuseIdentifier: pageCollectionViewCellIdentifier)
        pageViewSize = self.size
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func reloadTabScrollViewPageScrollView() {
        guard let dataSource = pageScrollViewDataSource else {
            return
        }
        pageViewCount = dataSource.pageView(self, numOfPageViewInSection: 0)
        self.reloadData()
    }
    
    
    func slideToPageView(atIndex: Int) {
        let offSetX = pageViewSize.width * CGFloat(atIndex)
        self.setContentOffset(CGPoint(x: offSetX, y: self.contentOffset.y), animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageViewCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pageCollectionViewCellIdentifier, for: indexPath) as! PageCollectionViewCell
        
        var pageView: UIView? = nil
        
        if let dataSource = pageScrollViewDataSource {
            pageView = dataSource.pageView(self, viewForItemAt: indexPath, pageSize: pageViewSize)
        }
        cell.renderCellWith(pageView: pageView!)
        cell.backgroundColor = .green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return pageViewSize
    }
    
}

extension GMZTabScrollViewPageScrollView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let delegate = pageScrollViewDelegate, scrollView == self else {
            return
        }
        
        delegate.pageViewDidScroll(self)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let delegate = pageScrollViewDelegate else {
            return
        }
        delegate.pageViewDidEndDecelerating(self)
    }
    
    
}
