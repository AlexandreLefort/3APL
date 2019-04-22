//
//  Connectivity.swift
//  3APL_GBL
//
//  Created by godartm on 15/11/2018.
//  Copyright © 2018 GBL. All rights reserved.
//

import Foundation
import SystemConfiguration

struct Connectivity {
    
     var online:Bool!;
    
    mutating func checkConnectivity()
    {
        /**
         * https://developer.apple.com/documentation/systemconfiguration/1514904-scnetworkreachabilitycreatewithn
         */
        let reachablebility = SCNetworkReachabilityCreateWithName(nil, "supinfo.steve-colinet.fr")
        
        /**
        * ConnectionFlags contiendra l'état du réseau
        */
        var connectionFlags = SCNetworkReachabilityFlags()
        
        /** Rapelle & = in/out parameter **/
        SCNetworkReachabilityGetFlags(reachablebility!, &connectionFlags)
        
        /** l'on verifie maintenant que le flag contient reachable**/
        self.online = connectionFlags.contains(.reachable)
    }
        
}
