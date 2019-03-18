//
//  Endpoints.swift
//  Pods
//
//  Created by G M Tasnim Alam on 2/17/19.
//

import Foundation

struct Endpoints {
    enum Environment: String {
        case Production = "xyz"
        case Sandbox = "abc"
        case Development = "http://10.10.10.10:8089"
    }
    
    static var sessionEndpoint: String = "/oauth2/v1/auth/session"
    static var exchangeTokenEndpoint: String = "/oauth2/v1/auth/session/token-exchange"
    static var verifyTokenEndpoint: String = "/oauth2/v1/auth/session/verify"
    
    public static func getSessionInitiateURL(development: DevelopmentEnvironment) -> String {
        switch development {
        case .Production:
            return Environment.Production.rawValue + sessionEndpoint
        case .Development:
            return Environment.Development.rawValue + sessionEndpoint
        case .Sandbox:
            return Environment.Sandbox.rawValue + sessionEndpoint
        }
    }
    
    public static func getExchangeTokenURL(development: DevelopmentEnvironment) -> String {
        switch development {
        case .Production:
            return Environment.Production.rawValue + exchangeTokenEndpoint
        case .Development:
            return Environment.Development.rawValue + exchangeTokenEndpoint
        case .Sandbox:
            return Environment.Sandbox.rawValue + exchangeTokenEndpoint
        }
    }
    
    public static func getVerifyTokenURL(development: DevelopmentEnvironment) -> String {
        switch development {
        case .Production:
            return Environment.Production.rawValue + verifyTokenEndpoint
        case .Development:
            return Environment.Development.rawValue + verifyTokenEndpoint
        case .Sandbox:
            return Environment.Sandbox.rawValue + verifyTokenEndpoint
        }
    }
}
