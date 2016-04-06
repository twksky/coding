//
//  TYOssHandler.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/28.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYOssHandler: NSObject {
    let ossService = ALBBOSSServiceProvider.getService()
    let sysConfig = TYSysConfigStorage.sysConfig()
    var ossBucket:OSSBucket {
        return self.ossService.getBucket(sysConfig.ossBucket)
    }
    var ossData:OSSData!
    func executeTask(){

        ossService.setGenerateToken { (method, md5, type, date, xoss, resource) -> String! in
            var signature = String()
            let content = "\(method)\n\(md5)\n\(type)\n\(date)\n\(xoss)\(resource)"
            signature = OSSTool.calBase64Sha1WithData(content, withKey:self.sysConfig.ossAccessKeySecret)
            signature = "OSS \(self.sysConfig.ossAccessKeyID):\(signature) "
            return signature
        }
        

    }
}
