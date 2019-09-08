//
//  NetworkActivityIndicationManager.swift
//  Caffeine tracker
//
//  Created by Tobias Ruano on 18/08/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit

class NetworkActivityIndicationManager: NSObject {
    private static var loadingCount = 0
    
    class func networkOperationStarted() {
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loadingCount += 1
    }
    
    class func networkOperationFinished() {
        if loadingCount > 0 {
            loadingCount -= 1
        }
        
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
