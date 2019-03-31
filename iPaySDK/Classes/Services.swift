//
//  File.swift
//  Pods
//
//  Created by G M Tasnim Alam on 2/18/19.
//

import Foundation
import SVProgressHUD

struct SessionData: Codable {
    let appKey: String
    let deviceId: String
    let state: String
}

struct TokenResponseModel: Codable{
    var accessToken: String?
    var accessTokenExpiresIn: Double?
    var message: String?
    var refreshToken: String?
    var refreshTokenWindowStart: Double?
    var tokenType: String?
}

struct TokenRequestModel: Codable{
    var appKey: String?
    var authCode: String?
}

struct TokenVerifyModel: Codable{
    var token: String?
    var deviceId: String?
    var serviceId: Int
}


struct Services {
    public static func intiateSesssion(completion: @escaping (String) -> Void){
        guard let url = URL.init(string: Endpoints.getSessionInitiateURL(development: iPaySDK.shared.environment)) else {
            return
        }
        
        SVProgressHUD.show()
        
        var request: URLRequest = URLRequest.init(url: url)
        request.httpMethod = "POST"
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let sessionData = SessionData.init(appKey: Settings.client_id, deviceId: Settings.device_id, state: Settings.state)
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let jsonData = try! jsonEncoder.encode(sessionData)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                completion(responseJSON["baseUrl"] as! String)
            }
        }.resume()
    }
    
    public static func tokenExchange(model: TokenRequestModel, completion: @escaping (TokenResponseModel?) -> Void){
        guard let url = URL.init(string:  Endpoints.getExchangeTokenURL(development: iPaySDK.shared.environment)) else {
            return
        }
        
        SVProgressHUD.show()
        
        var request: URLRequest = URLRequest.init(url: url)
        request.httpMethod = "POST"
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let jsonData = try! jsonEncoder.encode(model)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                    }
                    if let tokenResponseModel = try? JSONDecoder().decode(TokenResponseModel.self, from: data) {
                        completion(tokenResponseModel)
                    }
                }else{
                    completion(nil)
                }
            }
        }.resume()
    }
    
    public static func verifyToken(model: TokenVerifyModel, completion: @escaping (Bool)->Void){
        guard let url = URL.init(string:  Endpoints.getVerifyTokenURL(development: iPaySDK.shared.environment)) else {
            return
        }
        
        SVProgressHUD.show()
        
        var request: URLRequest = URLRequest.init(url: url)
        request.httpMethod = "POST"
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        let jsonData = try! jsonEncoder.encode(model)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            
            guard let _ = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    completion(true)
                }else{
                    completion(false)
                }
            }
        }.resume()

    }
    
    public static func refreshToken(model: TokenRequestModel, completion: @escaping (TokenResponseModel?) -> Void){
        guard let url = URL.init(string:  Endpoints.getVerifyTokenURL(development: iPaySDK.shared.environment)) else {
            return
        }
        
        SVProgressHUD.show()
        
        var request: URLRequest = URLRequest.init(url: url)
        request.httpMethod = "GET"
        
        let token = Settings.getTokenFromDefaults()
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        headers["access-token"] = token?.accessToken
        headers["refresh-token"] = token?.refreshToken
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                    }
                    if let tokenResponseModel = try? JSONDecoder().decode(TokenResponseModel.self, from: data) {
                        completion(tokenResponseModel)
                    }
                }else{
                    completion(nil)
                }
            }
        }.resume()
    }
}
