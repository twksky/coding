//
//  OssDownloadHandler.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/28.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYOssDownloadHandler: TYOssHandler {

    private var key:String!
    init(key:String) {
        super.init()
        self.key = key
    }
    func getdata(dataCallback:((NSData!,NSError!) -> Void)!){
        super.executeTask()
        self.ossData = ossService.getOSSDataWithBucket(ossBucket, key: self.key)
        self.ossData.getWithDataCallback(dataCallback, withProgressCallback: nil)
    }
    func getText(textCallback:((String?) -> Void)!) {
        self.getdata { (data, error) -> Void in
            if data != nil {
                let str:String? = NSString(data: data, encoding: NSUTF8StringEncoding) as? String
                textCallback(str)
            }else {
                textCallback(nil)
            }
        }
    }
}
