//
//  SDKServices.swift
//  iPaySDK
//
//  Created by G M Tasnim Alam on 3/28/19.
//

import Foundation
import SVProgressHUD

struct BalanceResponseModel: Codable{
    let message: String
    let balance: Double
}

struct PaymentModel: Codable {
    var amount: Double?
}

public struct UserInfoModel: Codable {
    public var message: String?
    public var name: String?
    public var primaryEmailAddress: String?
    public var profilePictureUrl: String?
}

struct SDKServices {
    public static func getBalance(completion: @escaping (BalanceResponseModel?) -> Void){
        guard let url = URL.init(string:  Endpoints.getBalanceURL(development: iPaySDK.shared.environment)) else {
            return
        }
        
        SVProgressHUD.show()
        
        var request: URLRequest = URLRequest.init(url: url)
        request.httpMethod = "GET"
        
        let token = Settings.getTokenFromDefaults()
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        headers["token"] = token?.accessToken
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
                    if let balanceResponseModel = try? JSONDecoder().decode(BalanceResponseModel.self, from: data) {
                        completion(balanceResponseModel)
                    }
                }else{
                    completion(nil)
                }
            }
        }.resume()
    }
    
    public static func makePayment(model: PaymentModel, completion: @escaping (Bool) -> Void){
        guard let url = URL.init(string:  Endpoints.makePaymentURL(development: iPaySDK.shared.environment)) else {
            return
        }
        
        SVProgressHUD.show()
        
        var request: URLRequest = URLRequest.init(url: url)
        request.httpMethod = "POST"
        
        let token = Settings.getTokenFromDefaults()
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        headers["token"] = token?.accessToken
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

    
    public static func getUserInfo(completion: @escaping (UserInfoModel?) -> Void){
        guard let url = URL.init(string: Endpoints.getUserInfoURL(development: iPaySDK.shared.environment)) else {
            return
        }
        
        SVProgressHUD.show()
        
        var request: URLRequest = URLRequest.init(url: url)
        request.httpMethod = "GET"
        
        let token = Settings.getTokenFromDefaults()
        
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        headers["access-token"] = token?.accessToken
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
                    if let userInfoModel = try? JSONDecoder().decode(UserInfoModel.self, from: data) {
                        completion(userInfoModel)
                    }
                }else{
                    completion(nil)
                }
            }
        }.resume()
    }
}
