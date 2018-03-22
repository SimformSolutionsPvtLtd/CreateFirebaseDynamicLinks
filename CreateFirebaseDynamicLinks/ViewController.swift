//
//  ViewController.swift
//  FireBaseDynamicLinkReuabelClass
//
//  Created by Sumit Goswami on 08/03/18.
//  Copyright © 2018 Simform Solutions PVT. LTD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let parm:[String:String] = ["uname":"abc","pass":"123","call":"yes"]
        DynamicLinkConfiguration.shared.buildFirebaseDynamicLink(customParams: parm) { (sucess, shortLink, longLink) in
            if sucess {
                print(shortLink ?? "")
                print(longLink ?? "")
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

