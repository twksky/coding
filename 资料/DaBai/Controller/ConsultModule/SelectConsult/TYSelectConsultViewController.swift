//
//  TYSelectConsultViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/18.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//选择咨询

import UIKit

class TYSelectConsultViewController: TYBaseViewController {
    var consultState:String!
    func receiveWebSocketMessage(aNotification:NSNotification) {
        println(aNotification)
    }
    private func creatNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveWebSocketMessage:", name: "ReceiveWebSocketMessage", object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatNotification()
    }
}
