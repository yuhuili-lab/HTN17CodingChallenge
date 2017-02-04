//
//  DataManager.swift
//  HTN17
//
//  Created by Yuhui Li on 2017-02-03.
//  Copyright © 2017 Yuhui Li. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum DataManagerError: Error {
    case ResponseNoJSON
}

class DataManager: NSObject {
    private var remoteURL : String
    
    init(remoteURL: String) {
        self.remoteURL = remoteURL
    }
    
    func startDownload(completionHandler: @escaping (_ success: Bool, _ result: JSON?, _ error: Error?) -> Void) {
        Alamofire.request(remoteURL).responseJSON { response in
            switch response.result {
            case .success(_):
                if let rawJSON = response.result.value {
                    let json = JSON(rawJSON)
                    completionHandler(true, json, nil)
                } else {
                    completionHandler(false, nil, DataManagerError.ResponseNoJSON)
                }
            case .failure(let error):
                completionHandler(false, nil, error)
            }
        }
    }
}
