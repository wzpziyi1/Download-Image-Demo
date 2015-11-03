//
//  ZYApp.swift
//  下载图片操作
//
//  Created by 王志盼 on 15/11/3.
//  Copyright © 2015年 王志盼. All rights reserved.
//

import UIKit

class ZYApp: NSObject {

    static var apps = Array<ZYApp>()
    var name : String?
    var icon : String?
    var download : String?
    
    init(dict: Dictionary<String, String>){

        self.name = dict["name"]
        self.icon = dict["icon"]
        self.download = dict["download"]
    }
    
    class func getApps() -> Array<ZYApp> {
        let path = NSBundle.mainBundle().pathForResource("apps.plist", ofType: nil)
        let tmpArray: NSArray? = NSArray(contentsOfFile: path!)
        
        tmpArray?.enumerateObjectsUsingBlock({ (obj: AnyObject, index: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            let dict = obj as! Dictionary<String, String>
            let app = ZYApp(dict: dict);
            self.apps.append(app);
        })
        return apps;
    }
}
