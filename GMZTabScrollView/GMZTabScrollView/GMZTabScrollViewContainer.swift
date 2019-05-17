//
//  GMZTabScrollViewContainer.swift
//  GMZTabScrollView
//
//  Created by meizhen on 2019/2/25.
//  Copyright © 2019 meizhen. All rights reserved.
//

import UIKit

let collectionCellIdentifier = "CollectionCellIdentifier"

/// The tab cell configuration
public struct GMZTabCellConfigurator {
    public var title: String = ""
    
    public var font: UIFont = UIFont.systemFont(ofSize: 14)
    
    public var imageSize: CGSize = .zero
    
    public var image: UIImage?
    
    public var normalTitleColor: UIColor = .black
    
    public var selectedTitleColor: UIColor = .red

    public init() {
        
    }
    
    func hasImage() -> Bool {
        if imageSize.equalTo(.zero) == false, let _ = image {
            return true
        }
        return false
    }
    
    func textSize(cellHeight: CGFloat) -> CGSize {
        var rect = NSString(string: title).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: cellHeight), options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        rect.size.height = cellHeight
        return rect.size
    }
    
    func cellSize(cellHeight: CGFloat) -> CGSize {
        var textSize = self.textSize(cellHeight: cellHeight)
        if hasImage() {
            textSize.width += (imageSize.width + 1)
        }
        textSize.height = cellHeight
        return textSize
    }
}

protocol GMZTabScrollViewContainerDataSource: class {
    
    
    /// The number of tab in container view
    ///
    /// - Parameter tabContainer: self
    /// - Returns: the number of tab
    func numberOfTab(tabContainer: GMZTabScrollViewContainer) -> Int
    
    
    /// Get the configuration of the tab cell at specified index
    ///
    /// - Parameter atIndex: index
    /// - Returns: configuration
    func tabContainerViewTabCellConfiguration(atIndex: Int) -> GMZTabCellConfigurator?
}

protocol GMZTabScrollViewContainerDelegate: class {
    
    
    /// The action of the select
    ///
    /// - Parameter atIndex: index
    func didSelectTab(atIndex: Int)
}



class GMZTabScrollViewContainer: UIView {
    
    weak var delegate: GMZTabScrollViewContainerDelegate? = nil
    weak var dataSource: GMZTabScrollViewContainerDataSource? = nil
    var tabCount = 0
    var contentCollectionView: UICollectionView!
    var currentSelectedIndex = 0
    var tabCellConfigurationArray: [GMZTabCellConfigurator?] = []
    var currentSelectedCell: GMZContainerCollectionViewCell? = nil
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func reloadTabScrollViewContainer() {
        if let dataSource = dataSource {
            tabCount = dataSource.numberOfTab(tabContainer: self)
        }
        contentCollectionView.reloadData()
    }
    
    
    /// Slide to the selected tab
    ///
    /// - Parameter index: index
    func slideToTab(index: Int) {
        guard index >= 0 && index < tabCount else {
            return
        }
        currentSelectedCell?.cellIsSelected = false
        let selectedCell = contentCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as! GMZContainerCollectionViewCell
        selectedCell.cellIsSelected = true
        currentSelectedCell = selectedCell
        currentSelectedIndex = index
        contentCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    
    private func getTabCellConfiguration(atIndex: Int) -> GMZTabCellConfigurator? {
        if let dataSource = self.dataSource {
            return dataSource.tabContainerViewTabCellConfiguration(atIndex: atIndex)
        }
        return nil
    }
    
    /// add subviews
    func configSubViews() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumInteritemSpacing = 10
        
        contentCollectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: collectionViewLayout)
        contentCollectionView.backgroundColor = .clear
        contentCollectionView.register(GMZContainerCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellIdentifier)
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        contentCollectionView.alwaysBounceHorizontal = true
        contentCollectionView.showsHorizontalScrollIndicator = false
        self.addSubview(contentCollectionView)
    }

}



// MARK: - UICollectionViewDataSource
extension GMZTabScrollViewContainer: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabCount;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as! GMZContainerCollectionViewCell
        cell.cellIndex = indexPath.row
        if currentSelectedIndex == indexPath.row {
            currentSelectedCell = cell
        }
        if let configuration = getTabCellConfiguration(atIndex: indexPath.row) {
            cell.configCell(data: configuration, isSelected: indexPath.row == currentSelectedIndex)
        }
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension GMZTabScrollViewContainer: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        slideToTab(index: indexPath.row)
        if let delegate = delegate {
            delegate.didSelectTab(atIndex: currentSelectedIndex)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

}


// MARK: - UICollectionViewDelegateFlowLayout
extension GMZTabScrollViewContainer: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let configuration = getTabCellConfiguration(atIndex: indexPath.row) {
            return configuration.cellSize(cellHeight: contentCollectionView.height)
        }
        return .zero
    }
}

