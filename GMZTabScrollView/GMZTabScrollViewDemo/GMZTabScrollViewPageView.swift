//
//  GMZTabScrollViewPageView.swift
//  GMZTabScrollView
//
//  Created by meizhen on 2019/2/25.
//  Copyright © 2019 meizhen. All rights reserved.
//

import UIKit



class GMZTabScrollViewPageView: UIView {
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCellWith(title: String) {
        label.text = title
    }
    func configSubViews() {
        let height = frame.size.height
        let width = frame.size.width
        
        
        label = UILabel.init(frame: CGRect(x: 0, y: height/2, width: width, height: 30))
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        self.addSubview(label)
    }

}



