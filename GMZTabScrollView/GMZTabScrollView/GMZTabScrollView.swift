//
//  GMZTabScrollView.swift
//  GMZTabScrollView
//
//  Created by meizhen on 2019/2/25.
//  Copyright © 2019 meizhen. All rights reserved.
//

import UIKit


public protocol GMZTabScrollViewDataSource : NSObjectProtocol {
    
    
    /// Use the methdo to set the number of tab of the tabScrollView
    ///
    /// - Parameter tabScrollView: self
    /// - Returns: tab number
    func numberOfTab(tabScrollView: GMZTabScrollView) -> Int

    
    /// Set the pageview of the specified index
    ///
    /// - Parameter atIndex: the index
    /// - Returns: The view of the index
    func tabScrollViewPageView(atIndex: Int, pageSize: CGSize) -> UIView
    

    
    func tabScrollViewTabCellConfiguration(atIndex: Int) -> GMZTabCellConfigurator
}

extension GMZTabScrollViewDataSource {
    /// Use the method to set the height of the
    ///
    /// - Parameter tabScrollView: self
    /// - Returns: The height of the tab
    func heightOfTab(tabScrollView: GMZTabScrollView) -> Float {
        return Float(TabHeight)
    }
    
}


let TabHeight: CGFloat = 44


public protocol GMZTabScrollViewDelegate : NSObjectProtocol{
    
    
    /// The action on the selection of the index
    ///
    /// - Parameter atIndex: index
    func tabScrollViewDidSelect(atIndex: Int)
    
}

extension GMZTabScrollViewDelegate {
    func tabScrollViewDidShowPage(atIdnex: Int) {
        
    }
}


/// The margin of the tabScrollView
public struct GMZTabScrollViewMargin {
    
    /// The top margin to the screen
    public var topMargin: CGFloat = 0
    
    /// The bottom margin to the screen
    public var bottomMargin: CGFloat = 0
    
    
    /// The left margin of scroll page view
    public var pageScrollViewLeftMargin: CGFloat = 10
    
    /// The right margin of scroll page view
    public var pageScrollViewRightMargin: CGFloat = 10
    
    public init(topMargin: CGFloat, bottomMargin: CGFloat, pageViewLeftMargin: CGFloat, pageViewRightMargin: CGFloat) {
        self.topMargin = topMargin
        self.bottomMargin = bottomMargin
        self.pageScrollViewLeftMargin = pageViewLeftMargin
        self.pageScrollViewRightMargin = pageViewRightMargin
    }
    
    public static var zero: GMZTabScrollViewMargin {
        return GMZTabScrollViewMargin(topMargin: 0, bottomMargin: 0, pageViewLeftMargin: 0, pageViewRightMargin: 0)
    }
    
    
}

public class GMZTabScrollView: UIView {

    open weak var tabScrollViewDelegate: GMZTabScrollViewDelegate? = nil
    public weak var tabScrollViewDataSource: GMZTabScrollViewDataSource? = nil
    
    public var tabScrollEnable: Bool = false
    
    private var tabContainerView: GMZTabScrollViewContainer!
    private var tabPageView: GMZTabScrollViewPageScrollView!
    private var pageNumber: Int = 0
    private var currentPageIndex: Int = 0
    
    public init(frame: CGRect, margin: GMZTabScrollViewMargin) {
        super.init(frame: frame)
        configSubViews(margin: margin)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configSubViews(margin: GMZTabScrollViewMargin) {
        let tabContaierFrame = CGRect(x: 0, y: margin.topMargin, width: self.width, height: TabHeight)
        
        tabContainerView = GMZTabScrollViewContainer.init(frame: tabContaierFrame)
        tabContainerView.backgroundColor = .lightGray
        tabContainerView.dataSource = self
        tabContainerView.delegate = self
        addSubview(tabContainerView)
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        
        let tabPageViewFrame = CGRect(x: 0, y: tabContainerView.bottom, width: width, height: height - tabContainerView.bottom - margin.bottomMargin)
        tabPageView = GMZTabScrollViewPageScrollView.init(frame: tabPageViewFrame, collectionViewLayout: flowLayout)
        
        tabPageView.pageScrollViewDelegate = self
        tabPageView.pageScrollViewDataSource = self
        addSubview(tabPageView)
    }
    
    public func reloadData() {
        guard let dataSource = tabScrollViewDataSource else {
            return
        }
        pageNumber = dataSource.numberOfTab(tabScrollView: self)
        tabContainerView.reloadTabScrollViewContainer()
        tabPageView.reloadTabScrollViewPageScrollView()
    }
}

extension GMZTabScrollView: GMZTabScrollViewContainerDelegate {
    func didSelectTab(atIndex: Int) {
        guard let delegate = tabScrollViewDelegate else {
            return
        }
        tabPageView.slideToPageView(atIndex: atIndex)
        currentPageIndex = atIndex
        delegate.tabScrollViewDidSelect(atIndex: atIndex)
        delegate.tabScrollViewDidShowPage(atIdnex: atIndex)
        
    }
    
    
}


// MARK: - GMZTabScrollViewContainerDataSource
extension GMZTabScrollView: GMZTabScrollViewContainerDataSource {
    
    func numberOfTab(tabContainer: GMZTabScrollViewContainer) -> Int {
        return pageNumber
    }
    
    func tabContainerViewTabCellConfiguration(atIndex: Int) -> GMZTabCellConfigurator? {
        guard let dataSource = tabScrollViewDataSource else {
            return nil
        }
        return dataSource.tabScrollViewTabCellConfiguration(atIndex: atIndex)
    }
    
    
}

// MARK: - GMZTabScrollPageScrollViewDataSource
extension GMZTabScrollView: GMZTabScrollPageScrollViewDataSource {
 
    func pageView(_ pageView: GMZTabScrollViewPageScrollView, numOfPageViewInSection: Int) -> Int {
        return pageNumber
    }
    
    func pageView(_ pageView: GMZTabScrollViewPageScrollView, viewForItemAt indexPath: IndexPath, pageSize: CGSize) -> UIView {
        var pageView: UIView = UIView.init(frame: CGRect(origin: .zero, size: pageSize))
        if let dataSource = tabScrollViewDataSource {
            pageView = dataSource.tabScrollViewPageView(atIndex: indexPath.row, pageSize: pageSize)
        }
        return pageView
    }
    
    
}


extension GMZTabScrollView: GMZTabScrollPageScrollViewDelegate {
    func pageViewDidScroll(_ pageView: GMZTabScrollViewPageScrollView) {
        let toIndex = Int(pageView.contentOffset.x / pageView.width + 0.5)
        if currentPageIndex != toIndex {
            currentPageIndex = toIndex
        }
    }
    
    func pageViewDidEndDecelerating(_ pageView: GMZTabScrollViewPageScrollView) {
        tabContainerView.slideToTab(index: currentPageIndex)
        guard let delegate = tabScrollViewDelegate else {
            return
        }
        delegate.tabScrollViewDidShowPage(atIdnex: currentPageIndex)
    }
    
    
}
