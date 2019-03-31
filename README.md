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
