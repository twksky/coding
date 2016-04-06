//
//  TYPatientInfoTableViewCell.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/5.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYPatientInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var consultStateLabel: UILabel!
    @IBOutlet weak var workOrgLable: UILabel!
    @IBOutlet weak var workDepLabel: UILabel!
    var model:TYPatientInfoTableViewCellEntity! {
        didSet {
            if model != nil {
                if model.ctime != nil {
                    let df = NSDateFormatter()
                    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date = df.dateFromString(model.ctime)
                    let df2 = NSDateFormatter()
                    df2.dateFormat = "yyyy.MM.dd"
                    self.timeLabel.text = df2.stringFromDate(date!)
                }
                if model.workOrg != nil {
                    self.workOrgLable.text = model.workOrg
                }
                if model.workDep != nil {
                    self.workDepLabel.text = model.workDep
                }
                if model.consultState != nil {
                    self.consultStateLabel.text = consultStateText(model.consultState)
                }
            }
        }
    }
    private func consultStateText(consultState:String)->String {
        switch consultState {
        case "1":
            return "未咨询"
        case "2":
            return "发起/待确认"
        case "3":
            return "接受/待支付"
        case "5":
            return "进行中/支付完成"
        case "6":
            return "拒绝"
        case "7":
            return "结束"
        case "8":
            return "取消"
        default :
            return "未定义"
        }
    }
}
