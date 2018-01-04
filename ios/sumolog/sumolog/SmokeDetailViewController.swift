//
//  SmokeDetailViewController.swift
//  sumolog
//
//  Created by 岩見建汰 on 2018/01/03.
//  Copyright © 2018年 Kenta. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Eureka
import Alamofire
import SwiftyJSON
import TinyConstraints
import KeychainAccess

class SmokeDetailViewController: UIViewController, IndicatorInfoProvider {

    var data = SmokeDetailViewData()
    let indicator = Indicator()
    var id = ""
    
    var msgLabel = UILabel()
    var ave_minLabel = UILabel()
    var minLabel = UILabel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CallGetDetailViewAPI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let keychain = Keychain()
        id = (try! keychain.getString("id"))!
    }
    
    func CallGetDetailViewAPI() {
        let urlString = API.base.rawValue + API.smoke.rawValue + API.detail.rawValue + API.user.rawValue + id
        indicator.showIndicator(view: self.view)
        
        Alamofire.request(urlString, method: .get).responseJSON { (response) in
            self.indicator.stopIndicator()
            
            guard let object = response.result.value else{return}
            let json = JSON(object)
            print("Smoke Detailview results: ", json.count)
            print(json)
            
            self.data.SetAll(json: json)
            
            self.DrawViews()
        }
    }
    
    func DrawViews() {
        msgLabel.removeFromSuperview()
        ave_minLabel.removeFromSuperview()
        minLabel.removeFromSuperview()
        
        CreateMsgLabel()
        CreateAverageMinLabel()
        CreateMinLabel()
    }
    
    func CreateMsgLabel() {
        let label = UILabel()
        label.text = "1本あたり"
        label.font = UIFont(name: Font.HiraginoW3.rawValue, size: 15)
        label.textColor = UIColor.hex(Color.gray.rawValue, alpha: 1.0)
        
        msgLabel = label
        
        self.view.addSubview(label)
        
        label.centerX(to: self.view)
        label.centerY(to: self.view, offset: -230)
    }
    
    func CreateAverageMinLabel() {
        let label = UILabel()
        label.text = String(data.GetAve())
        label.font = UIFont(name: Font.HiraginoW3.rawValue, size: 60)
        label.textColor = UIColor.hex(Color.gray.rawValue, alpha: 1.0)
        
        ave_minLabel = label
        
        self.view.addSubview(label)
        
        label.centerX(to: self.view)
        label.topToBottom(of: msgLabel, offset: 10)
    }
    
    func CreateMinLabel() {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont(name: Font.HiraginoW6.rawValue, size: 30)
        label.textColor = UIColor.hex(Color.gray.rawValue, alpha: 1.0)
        label.text = "min"
        
        minLabel = label
        
        self.view.addSubview(label)
        
        label.topToBottom(of: ave_minLabel, offset: -10)
        label.leadingToTrailing(of: ave_minLabel, offset: -20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Detail")
    }
}
