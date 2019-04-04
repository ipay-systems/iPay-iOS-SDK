# iPaySDK
[![Version](https://img.shields.io/cocoapods/v/iPaySDK.svg?style=flat)](https://cocoapods.org/pods/iPaySDK)
[![License](https://img.shields.io/cocoapods/l/iPaySDK.svg?style=flat)](https://cocoapods.org/pods/iPaySDK)
[![Platform](https://img.shields.io/cocoapods/p/iPaySDK.svg?style=flat)](https://cocoapods.org/pods/iPaySDK)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
* iOS 9.3 and Above

## Installation

iPaySDK is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'iPaySDK'
```

## Prerequisite
iPaySDK requires merchant to obtain the `client_id` from iPay. If your `client_id` is `xyz` then you need to add the following URL Type in your info.plist

```
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>None</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>ipayxyz</string>
			</array>
		</dict>
	</array>
```

## How to use
Setup Configuration and Initialization
```
iPaySDK.shared.environment = .Development //Use this for Development environment
iPaySDK.shared.configure(withClientId: "xyz")
iPaySDK.shared.delegate = self
```

Initiate Session

```
iPaySDK.shared.userInitiateSession()
```

Add URL Handler

Place this code in AppDelegate
```
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    return iPaySDK.shared.handleUrl(url: url)
}
```


Get Balance

```
iPaySDK.shared.getBalance { (balance) in
   DispatchQueue.main.async {
       print(balance)
   }
}
```

Make Payment
```
iPaySDK.shared.makePayment(amount: 10)
```

Fetch User's Basic Info
```
iPaySDK.shared.getUserInfo { (model) in
    DispatchQueue.main.async {
        print("\(model.name ?? "") \n \(model.primaryEmailAddress ?? "")")
    }
}
```

Check Whether SDK is already connected
```
if iPaySDK.shared.isAuthenticated {
    //Write your code here     
}
```


SDK Delegate: Use these delegate to handle callbacks and show appropriate results to improve user experience.
```
func oauthDidSuccess()
func oauthDidFail() 
func paymentDidSuccess()
func paymentDidFail()
```

## Author

Tasnim Alam Shovon, shovon54@gmail.com

## License

iPaySDK is available under the Apache-2.0. See the LICENSE file for more info.
