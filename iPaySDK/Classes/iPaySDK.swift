//
//  iPaySDK.swift
//  Pods
//
//  Created by G M Tasnim Alam on 11/4/18.
//

import Foundation
import UIKit

public enum DevelopmentEnvironment: String {
    case Sandbox
    case Development
    case Production
}

public protocol iPaySDKDelegate {
    func oauthDidSuccess()
    func oauthDidFail()
}

public class iPaySDK {
    
    public var delegate: iPaySDKDelegate?
    public var isAuthenticated: Bool = false
    public var environment: DevelopmentEnvironment = .Production
    
    public static let shared: iPaySDK = {
       return iPaySDK()
    }()
        
    public func configure(withClientId: String){
        Settings.client_id = withClientId
        Settings.device_id = UIDevice.current.identifierForVendor?.uuidString ?? "no_device"
        //Validate Session
        if let tokenModel = Settings.getTokenFromDefaults(), let token = tokenModel.accessToken {
            let model = TokenVerifyModel.init(token: token, deviceId: Settings.device_id, serviceId: 0)
            Services.verifyToken(model: model) { (status) in
                self.isAuthenticated = status
                if self.isAuthenticated {
                    self.delegate?.oauthDidSuccess()
                    print("Authenticated")
                }else{
                    self.delegate?.oauthDidFail()
                    print("Not Authenticated")
                }
            }
        }
    }
    
    public func userInitiateSession(){
        if(self.isAuthenticated){
            print("Already Authenticated")
            return
        }
        Settings.state = String.randomString(length: 6)
        Services.intiateSesssion { (string) in
            guard let validUrl = URL.init(string: string) else {
                return
            }
            DispatchQueue.main.async {
                if(UIApplication.shared.canOpenURL(validUrl)){
                    UIApplication.shared.openURL(validUrl)
                }else{
                    self.showDownloadAlert()
                }
            }
        }
    }
    
    public func handleUrl(url: URL) -> Bool {
        if url.scheme == externalURLScheme() {
            if url.absoluteString.contains("success") {
                //success case
                print("iPaySDK:== success, exchanging token")
                let queryItems = URLComponents(string: url.absoluteString)?.queryItems
                let state = queryItems?.filter({$0.name == "state"}).first
                let authCode = queryItems?.filter({$0.name == "authCode"}).first
                
                self.exchangeToken(withState: state?.value ?? "", authCode: authCode?.value ?? "")
            }else if url.absoluteString.contains("cancel"){
                //cancel case
                print("iPaySDK:== failed")
                delegate?.oauthDidFail()
            }else{
                //unknown case
                print("iPaySDK:== unknown error")
            }
            return true
        }
        return false
    }
    
    fileprivate func exchangeToken(withState: String, authCode: String){
        if withState != Settings.state {
            print("iPaySDK:== invalid state")
            return
        }
        
        let request = TokenRequestModel.init(appKey: Settings.client_id, authCode: authCode)
        
        Services.tokenExchange(model: request) { (response) in
            guard let res = response else{
                self.delegate?.oauthDidFail()
                return
            }
            if let _ = res.accessToken {
                Settings.saveTokenInDefaults(model: res)
                self.delegate?.oauthDidSuccess()
            }else{
                self.delegate?.oauthDidFail()
            }
        }
    }
    
    fileprivate func externalURLScheme() -> String? {
        guard let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [AnyObject],
            let urlTypeDictionary = urlTypes.first as? [String: AnyObject],
            let urlSchemes = urlTypeDictionary["CFBundleURLSchemes"] as? [AnyObject],
            let externalURLScheme = urlSchemes.first as? String else { return nil }
        
        return externalURLScheme
    }
}

public extension UIAlertController {
    func show() {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.makeKeyAndVisible()
        vc.present(self, animated: true, completion: nil)
    }
}

public extension String {
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
}

public extension URL {
    func isValidCheckoutURL(url : URL) -> Bool {
        guard let checkoutUrl = url.host else {
            return false
        }
        
        if checkoutUrl == "app.checkout.com" {
            return true
        }else {
            return false
        }
    }
}

public extension iPaySDK {
    func showDownloadAlert(){
        let alert = UIAlertController.init(title: "Download", message: "iPay app is not available. Please download from Appstore", preferredStyle: .alert)
        let downloadAction = UIAlertAction.init(title: "Download", style: .default, handler: {action in
            UIApplication.shared.openURL(URL.init(string: "https://www.ipay.com.bd")!)
        })
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .default, handler: {action in
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(downloadAction)
        alert.addAction(cancelAction)
        
        alert.show()
    }
}
