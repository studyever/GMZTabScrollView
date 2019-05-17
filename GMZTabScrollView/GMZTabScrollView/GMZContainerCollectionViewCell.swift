//
//  GMZContainerCollectionViewCell.swift
//  GMZTabScrollView
//
//  Created by meizhen on 2019/2/25.
//  Copyright © 2019 meizhen. All rights reserved.
//

import UIKit

class GMZContainerCollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel!
    var tabSelectedColor: UIColor = .red
    var tabNormalColor: UIColor = .black
    var imageView: UIImageView!
    var configuration: GMZTabCellConfigurator? = nil
    var cellIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(data: GMZTabCellConfigurator, isSelected: Bool) {
        configuration = data
        titleLabel.frame = self.bounds
        titleLabel.font = data.font
        titleLabel.textColor = isSelected ? data.selectedTitleColor : data.normalTitleColor
        titleLabel.text = data.title
        if data.hasImage() {
            imageView.image = data.image
            imageView.frame.size = data.imageSize
            imageView.right = self.right
        }
        else {
            imageView.frame = .zero
        }
    }
    
    var cellIsSelected: Bool {
        set {
            titleLabel.textColor = newValue ? configuration?.selectedTitleColor : configuration?.normalTitleColor
        }
        get {
            return self.isSelected
        }
    }
    func configSubViews() {
        titleLabel = UILabel.init(frame: self.bounds)
        titleLabel.textColor = tabNormalColor
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        self.contentView.addSubview(titleLabel)
        
        imageView = UIImageView.init(frame: .zero)
        contentView.addSubview(imageView)
    }
    
}
