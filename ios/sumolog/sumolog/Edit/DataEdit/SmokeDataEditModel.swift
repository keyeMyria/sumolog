//
//  SmokeDataEditViewModel.swift
//  sumolog
//
//  Created by 岩見建汰 on 2018/08/13.
//  Copyright © 2018年 Kenta. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON
import KeychainAccess

protocol SmokeDataEditViewModelDelegate: class {
    func successUpdateOrDeleteSmoke()
    func faildAPI(title: String, msg: String)
}

class SmokeDataEditViewModel {
    weak var delegate: SmokeDataEditViewModelDelegate?
    private let api = API()
    private let keychain = Keychain()
    
    private(set) var startedAt = ""
    private(set) var endedAt = ""
    private(set) var smokeID = 0
    
    func setSmokeInfo(start: String, end: String, ID: Int) {
        self.startedAt = start
        self.endedAt = end
        self.smokeID = ID
    }
    
    func isEndedAtEmpty() -> Bool {
        return endedAt.isEmpty
    }
    
    private func resetSmokeInfoInKeyChain() {
        let keychainSmokeID = Int((try! self.keychain.get("smoke_id"))!)
        
        if let keychainSmokeID = keychainSmokeID {
            if keychainSmokeID == smokeID {
                try! self.keychain.set("", key: "smoke_id")
                try! self.keychain.set(String(false), key: "is_smoking")
            }
        }
    }
    
    func updateSmoke(start: Date, end: Date, isReset: Bool) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let start = dateFormatter.string(from: start)
        let end = dateFormatter.string(from: end)
        
        api.updateSmoke(start: start, end: end, smokeID: String(smokeID)).done { (json) in
            let smoke_id = String((try! self.keychain.getString("smoke_id"))!)
            
            // 終了時間を編集したsmoke dataと手動で喫煙開始をしたsmoke dataが同じであればフラグをfalseにする
            if smoke_id! == String(self.smokeID) {
                try! self.keychain.set(String(false), key: "is_smoking")
                try! self.keychain.set("", key: "smoke_id")
            }
            
            if isReset {
                self.resetSmokeInfoInKeyChain()
            }
            
            self.delegate?.successUpdateOrDeleteSmoke()
        }
        .catch { (err) in
            let tmp_err = err as NSError
            let title = "Error(" + String(tmp_err.code) + ")"
            self.delegate?.faildAPI(title: title, msg: tmp_err.domain)
        }
    }
    
    func deleteSmoke() {
        api.deleteSmoke(smokeID: smokeID).done { (json) in
            self.resetSmokeInfoInKeyChain()
            self.delegate?.successUpdateOrDeleteSmoke()
        }
        .catch { (err) in
            let tmp_err = err as NSError
            let title = "Error(" + String(tmp_err.code) + ")"
            self.delegate?.faildAPI(title: title, msg: tmp_err.domain)
        }
    }
}
