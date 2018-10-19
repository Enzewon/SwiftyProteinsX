//
//  Device.swift
//  SwiftyProteins
//
//  Created by Danil Vdovenko on 3/27/18.
//  Copyright © 2018 Danil Vdovenko. All rights reserved.
//

import Foundation
import LocalAuthentication

class Device {
    
    let context = LAContext()
    
    public func isEnableID() -> Bool {
        
        if self.context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            
            return true
            
        }
        
        return false
    }
    
    deinit {
        
        print("Deinit Device")
        
    }
    
}
