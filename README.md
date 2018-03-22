# FireBase DynamicLink Reuabel Class


The FireBaseDynamicLinkReuabelClass provide the sharing data between both ios and android plateforms.


## Features

- [x] Sharing data between both ios and android plateforms.
- [x] Geting data between both ios and android plateforms.

## Requirements

- iOS 8.0+
- Xcode 7.3

## Installation

#### Take DynamicLinkConfiguration.swift, Import this file in your project and configure DynamicLinkParams and it's done

#### Manually
1. Configure FirebaseBase Settings for iOS (https://firebase.google.com/docs/ios/setup)
2. Download FirebaseBase SDK Or Pod's for iOS
3. Add SDK to Project
4. Configure Xcode Project
5. Configure FirebaseBaseDynamicLinks Settings for iOS (https://firebase.google.com/docs/dynamic-links/)
6. Connect App Delegate Using DynamicLinkConfiguration.swift Methods
7. Congratulations!

## Usage example

##### First configure the perams

```swift
struct DynamicLinkParams {
// dyanamic Link Domain
static let dynamicLinkDomain                = "your_dynamic_link_domin"
// your app web link
static let link:String                      =  "your_app_web_site"   //"http://www.google.com?"

//iOS Params
static let appStoreID:String                = "your_appstore_id"
static let bundleID:String                  = "your_app_bundle_id"
static let iOSFallbackUrl:String            = "your_app_appstore_link" 
static let minimumAppVersion:String         = "your_app_minimum_app_version"

//Andriod Params
static let packageName:String               = "your_app_package_name"
static let androidFallbackURL:String        = "your_app_playstore_link"
static let minimumVersion:String            = "minimum_version"

// put this BudleId in customURLScheme -> ProjectNavigator -> select Target -> info -> URL Types
static let customURLScheme:String           = "BundleId"
}
```
##### Create dynamiclink
```swift

    let parm:[String:String] = ["uname":"abc","pass":"123","call":"yes"]
    DynamicLinkConfiguration.shared.buildFirebaseDynamicLink(customParams: parm) { (sucess, shortLink, longLink) in
        if sucess {
          print(shortLink)
          print(longLink)
        }
    }
```
##### Handle dynamiclink in AppDelegate
```swift
//
extension AppDelegate {
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {

          if let incomingURL = userActivity.webpageURL {
                return  DynamicLinkConfiguration.shared.handelDynamicLink(url: incomingURL, completionHandler: { (sucess, dictionary) in
                    print(dictionary)// you will get data here
                })
          }
            return false
        }
    }
//
```


