//
//  DynamicLinkConfiguration.swift
//  swipe
//
//  Created by Sumit Goswami on 08/03/18.
//  Copyright © 2018 Simform Solutions PVT. LTD. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDynamicLinks

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

typealias CompletionHandler = (_ success:Bool,_ shortLink:URL?,_ longLinkURL:URL?) -> Void
typealias DynamicLinkHandler = (_ success:Bool,_ dictionary:[String:String]) -> Void

class DynamicLinkConfiguration: NSObject {
    
    struct Static {
        static let instance = DynamicLinkConfiguration()
    }
    
    class var shared: DynamicLinkConfiguration {
        return Static.instance
    }
    
    
    
// MARK:- Build DynamicLink
    func buildFirebaseDynamicLink(customParams:[String:String],completionHandler:@escaping CompletionHandler) {
        
        let linkString = DynamicLinkParams.link.appending(setCustomParams(params: customParams))
        let link = URL(string: linkString)
        let components = DynamicLinkComponents(link: link!, domain: DynamicLinkParams.dynamicLinkDomain)
        
        let iOSParams = DynamicLinkIOSParameters(bundleID: DynamicLinkParams.bundleID)
        iOSParams.fallbackURL = URL(string: DynamicLinkParams.iOSFallbackUrl)
        iOSParams.minimumAppVersion = DynamicLinkParams.minimumAppVersion
        iOSParams.customScheme = DynamicLinkParams.customURLScheme
        iOSParams.appStoreID = DynamicLinkParams.appStoreID
        components.iOSParameters = iOSParams
        
        let androidParams = DynamicLinkAndroidParameters(packageName: DynamicLinkParams.packageName)
        androidParams.fallbackURL = URL(string: DynamicLinkParams.androidFallbackURL)
        if  let intVersion = Int(DynamicLinkParams.minimumVersion) {
            androidParams.minimumVersion = intVersion
        }
        components.androidParameters = androidParams
        
        let longLink:URL = components.url!
        let options = DynamicLinkComponentsOptions()
        options.pathLength = .unguessable
        components.options = options
        components.shorten { (shortURL, warnings, error) in
            if let error = error {
                completionHandler(false,nil,nil)
                print(error.localizedDescription)
                return
            }
           let shortURLString = shortURL?.absoluteString.replacingOccurrences(of: "https://", with: "")
            let shortLink:URL = URL(string: shortURLString!)!
           print("shortLink",shortLink.absoluteString)
           completionHandler(true,shortLink,longLink)
         }
    }
// MARK: setCustom parameter for link
    func setCustomParams(params:[String:String]) -> String {
        var link:String = ""
        let allKeys = Array(params.keys)
        let allvalues = Array(params.values)
        for i in 0..<params.count {
            link.append(allKeys[i] + "=" + allvalues[i] + (allKeys[i] == allKeys.last ? "" : "&"))
        }
        return link
    }
    //MARK:- Handel Dynamic Link
    func handelDynamicLink(url:URL,completionHandler:@escaping DynamicLinkHandler) -> Bool{
        
        return (DynamicLinks.dynamicLinks()?.handleUniversalLink(url, completion: { (dynamicLink, error) in
            if let dynamicLink = dynamicLink, let _ = dynamicLink.url {
                print("==",dynamicLink)
                completionHandler(true,(dynamicLink.url?.queryDictionary)!)
            } else {
                completionHandler(false,[:])
            }
        }))!
    }
}


//MARK:- To Featch Data From URL
extension URL {
    var queryDictionary: [String: String] {
        guard let components = URLComponents(string: absoluteString), let items = components.queryItems else { return [:] }
        return items.reduce([:]) { dictionary, item in
            var dictionary = dictionary
            dictionary[item.name] = item.value
            return dictionary
        }
    }
}

//Handle Firbase dynamic link
extension AppDelegate {
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        
        if let incomingURL = userActivity.webpageURL {
            return  DynamicLinkConfiguration.shared.handelDynamicLink(url: incomingURL, completionHandler: { (sucess, dictionary) in
                print(dictionary)
            })
        }
        return false
    }
}
