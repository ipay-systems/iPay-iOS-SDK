//
//  Settings.swift
//  Pods
//
//  Created by G M Tasnim Alam on 2/18/19.
//

import Foundation

private enum UserDefaultKeys: String{
    case token
}

struct Settings {
    static var client_id = ""
    static var device_id = ""
    static var state = ""
    //TODO: Create models and use it for a session
    static var authorizationKey = ""
    
    static func getTokenFromDefaults() -> TokenResponseModel?{
        let defaults = UserDefaults.standard
        if let savedToken = defaults.object(forKey: UserDefaultKeys.token.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let loadedTokenModel = try? decoder.decode(TokenResponseModel.self, from: savedToken) {
                return loadedTokenModel
            }
        }
        return nil
    }
    
    static func saveTokenInDefaults(model: TokenResponseModel){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(model) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: UserDefaultKeys.token.rawValue)
        }
    }
}

