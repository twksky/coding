//
//  TYPatientListTableViewCell.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/4.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYPatientListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    var model:TYPatientListTableViewCellEntity! {
        didSet {
            if model != nil {
                self.nameLabel.text = model.patientName
                switch model.patientSexId {
                case "1":
                    sexLabel.text = "男"
                case "2":
                    sexLabel.text = "女"
                default:
                    self.sexLabel.text = model.patientSexId
                }
                self.telLabel.text = model.patientTel
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                if model.patientBirthDate != nil {
                    let data = formatter.dateFromString(model.patientBirthDate)
                    self.ageLabel.text = "\(TYAppUtils.ageWithDateOfBirth(data!))"
                }

            }
        }
    }
}
