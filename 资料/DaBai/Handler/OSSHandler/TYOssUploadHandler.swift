//
//  TYOssUploadHandler.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/28.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYOssUploadHandler: TYOssHandler {
    private var key:String!
    private var updata:NSData!
    private var type:String!
    init(data:NSData! ,type:String!,key:String) {
        super.init()
        self.type = type
        self.updata = data
        self.key = key
    }
    func uploadData(uploadCallback: ((Bool, NSError!) -> Void)!){
        super.executeTask()
        self.ossData = ossService.getOSSDataWithBucket(ossBucket, key: self.key)
        self.ossData.setData(self.updata, withType: self.type)
        self.ossData.uploadWithUploadCallback(uploadCallback, withProgressCallback: nil)
    }
}

