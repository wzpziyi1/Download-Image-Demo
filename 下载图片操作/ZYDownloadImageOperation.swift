//
//  ZYDownloadImageOperation.swift
//  下载图片操作
//
//  Created by 王志盼 on 15/11/3.
//  Copyright © 2015年 王志盼. All rights reserved.
//

import UIKit

@objc protocol ZYDownloadImageOperationDelegate : NSObjectProtocol{
   optional func downloadImageOperation(operation: ZYDownloadImageOperation, didFinishDownloadImage image: UIImage)
}

class ZYDownloadImageOperation: NSOperation {

    var url: String!
    var indexPath: NSIndexPath!
    weak var delegate: ZYDownloadImageOperationDelegate?
    
    
    override func main()
    {
        autoreleasepool({
            () -> Void in
            let downloadUrl = NSURL(string: self.url);
            if (self.cancelled) {
                return
            }
            let data = NSData(contentsOfURL: downloadUrl!);
            if (self.cancelled) {
                return
            }
            let image = UIImage(data: data!, scale: 1);
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.delegate?.downloadImageOperation!(self, didFinishDownloadImage: image!)
            })
            
        })
    }
    
}
