//
//  PageCollectionViewCell.swift
//  GMZTabScrollView
//
//  Created by meizhen on 2019/2/27.
//  Copyright © 2019 meizhen. All rights reserved.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell {
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.configSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configSubViews() {
        label = UILabel.init(frame: CGRect(x: 0, y: height/2, width: width, height: 30))
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        contentView.addSubview(label)
    }
    
    func configCellWith(title: String) {
        label.text = title
    }
    func renderCellWith(pageView: UIView) {
        contentView.addSubview(pageView)
    }
}
