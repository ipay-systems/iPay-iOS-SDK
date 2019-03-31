//
//  Endpoints.swift
//  Pods
//
//  Created by G M Tasnim Alam on 2/17/19.
//

import Foundation

struct Endpoints {
    enum AuthEnvironment: String {
        case Production = "xyz"
        case Sandbox = "abc"
        case Development = "http://10.10.10.10:8089"
    }
    
    enum PaymentEnvironment: String {
        case Production = "xyz"
        case Sandbox = "abc"
        case Development = "http://10.10.10.11:8088"
    }
    
    static var sessionEndpoint: String = "/oauth2/v1/auth/session"
    static var exchangeTokenEndpoint: String = "/oauth2/v1/auth/session/token-exchange"
    static var verifyTokenEndpoint: String = "/oauth2/v1/auth/session/verify"
    static var refreshTokenEndpoint: String = "/oauth2/v1/auth/token"
    
    static var balanceEndpoint: String = "/api/psdk/balance"
    static var paymentEndpoint: String = "/api/psdk/payment"
    
    public static func getSessionInitiateURL(development: DevelopmentEnvironment) -> String {
        switch development {
        case .Production:
            return AuthEnvironment.Production.rawValue + sessionEndpoint
        case .Development:
            return AuthEnvironment.Development.rawValue + sessionEndpoint
        case .Sandbox:
            return AuthEnvironment.Sandbox.rawValue + sessionEndpoint
        }
    }
    
    public static func getExchangeTokenURL(development: DevelopmentEnvironment) -> String {
        switch development {
        case .Production:
            return AuthEnvironment.Production.rawValue + exchangeTokenEndpoint
        case .Development:
            return AuthEnvironment.Development.rawValue + exchangeTokenEndpoint
        case .Sandbox:
            return AuthEnvironment.Sandbox.rawValue + exchangeTokenEndpoint
        }
    }
    
    public static func getVerifyTokenURL(development: DevelopmentEnvironment) -> String {
        switch development {
        case .Production:
            return AuthEnvironment.Production.rawValue + verifyTokenEndpoint
        case .Development:
            return AuthEnvironment.Development.rawValue + verifyTokenEndpoint
        case .Sandbox:
            return AuthEnvironment.Sandbox.rawValue + verifyTokenEndpoint
        }
    }
    
    public static func getRefreshTokenURL(development: DevelopmentEnvironment) -> String {
        switch development {
        case .Production:
            return AuthEnvironment.Production.rawValue + refreshTokenEndpoint
        case .Development:
            return AuthEnvironment.Development.rawValue + refreshTokenEndpoint
        case .Sandbox:
            return AuthEnvironment.Sandbox.rawValue + refreshTokenEndpoint
        }
    }
    
    public static func getBalanceURL(development: DevelopmentEnvironment) -> String {
        switch development {
        case .Production:
            return PaymentEnvironment.Production.rawValue + balanceEndpoint
        case .Development:
            return PaymentEnvironment.Development.rawValue + balanceEndpoint
        case .Sandbox:
            return PaymentEnvironment.Sandbox.rawValue + balanceEndpoint
        }
    }
    
    public static func makePaymentURL(development: DevelopmentEnvironment) -> String {
        switch development {
        case .Production:
            return PaymentEnvironment.Production.rawValue + paymentEndpoint
        case .Development:
            return PaymentEnvironment.Development.rawValue + paymentEndpoint
        case .Sandbox:
            return PaymentEnvironment.Sandbox.rawValue + paymentEndpoint
        }
    }
}
