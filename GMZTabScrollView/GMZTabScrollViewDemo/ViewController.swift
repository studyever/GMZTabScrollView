//
//  ViewController.swift
//  GMZTabScrollViewDemo
//
//  Created by meizhen on 2019/2/25.
//  Copyright © 2019 meizhen. All rights reserved.
//

import UIKit
import GMZTabScrollView

class ViewController: UIViewController, GMZTabScrollViewDataSource, GMZTabScrollViewDelegate {    
    
    

    var tabScrollView: GMZTabScrollView!
    var channelModelArray: [ChannelModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.configSubViews()
        self.requestData()
    }


    func configSubViews() {
        let margin = GMZTabScrollViewMargin(topMargin: 88, bottomMargin: 44, pageViewLeftMargin: 0, pageViewRightMargin: 0)
        
        tabScrollView = GMZTabScrollView.init(frame: view.bounds, margin: margin)
        tabScrollView.backgroundColor = .white
        tabScrollView.tabScrollViewDelegate = self
        tabScrollView.tabScrollViewDataSource = self
        view.addSubview(tabScrollView)
    }
    
    
    func requestData() {
        weak var weakSelf = self
        
        let path = "http://t.api.mob.app.letv.com/channel?pcode=010210000&version=8.8&devid=4DE2A2DC-188E-4203-8843-0B9319FCB3E4&country=CN&provinceid=1&districtid=13&citylevel=1&location=北京市|门头沟区|妙峰山镇&lang=chs&region=CN&_debug=1"
        let encodePath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        
//        let url = URL(string: encodePath)
        let url = URL(string: "http://t.api.mob.app.letv.com/channel?pcode=010210000&version=8.4.1&devid=4DE2A2DC-188E-4203-8843-0B9319FCB3E4&country=CN&provinceid=1&districtid=13&citylevel=1&location=北京市|门头沟区|妙峰山镇&lang=chs&region=CN&_debug=1".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
        if let url = url {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if let responseData = data {
                    var dict: [String : AnyObject] = [:]
                    do {
                        dict = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! [String : AnyObject]
                        weakSelf?.parseJsonData(data: dict)
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func parseJsonData(data: [String : AnyObject]) {
        let channels = data["body"]?["channel"]
        if let channels = channels as? [[String : AnyObject]] {
            do {
                let channelsData = try JSONSerialization.data(withJSONObject: channels, options: .init(rawValue: 0))
                let channelArray = try JSONDecoder().decode([ChannelModel].self, from: channelsData)
                channelModelArray = channelArray
                DispatchQueue.main.async {
                    self.tabScrollView.reloadData()
                }
                
            }
            catch {
                print("Oh no")
            }
        }
        
    }
    
    
    func numberOfTab(tabScrollView: GMZTabScrollView) -> Int {
        return channelModelArray.count
    }
    
    
    func tabScrollViewPageView(atIndex: Int, pageSize: CGSize) -> UIView {
        let pageView = GMZTabScrollViewPageView.init(frame: CGRect(origin: .zero, size: pageSize))
        pageView.configCellWith(title: "pageView" + String(atIndex))
        pageView.backgroundColor = atIndex % 2 == 0 ? .green : .yellow
        return pageView
        
    }
    
    func tabScrollViewTabCellConfiguration(atIndex: Int) -> GMZTabCellConfigurator {
        var configuration = GMZTabCellConfigurator()
        configuration.title = channelModelArray[atIndex].name
        return configuration
    }
    

    
    func tabScrollViewDidSelect(atIndex: Int) {
        
    }
}

struct ChannelModel: Decodable {
    var name: String
    
}
