//
//  TYDoctorTableViewCell.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/15.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYDoctorTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var headImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var workTitleLabel: UILabel!
    @IBOutlet weak var workOrgLabel: UILabel!
    @IBOutlet weak var workDepLabel: UILabel!
    @IBOutlet weak var imgOrderPriceLabel: UILabel!
    @IBOutlet weak var telOrderPriceLabel: UILabel!
    @IBOutlet weak var videoOrderPriceLabel: UILabel!
    @IBOutlet weak var followUpPriceLabel: UILabel!
    var model:TYDoctorTableViewCellEntity!{
        didSet{
            if model.headImg != nil {
                let handler = TYOssDownloadHandler(key: model.headImg)
                handler.getdata({ (data, error) -> Void in
                    let downloadImage = UIImage(data: data)
                    self.headImage.image = downloadImage!
                })
            }
            nameLabel.text = model.userName
            workTitleLabel.text = model.workTitle
            workOrgLabel.text = model.workOrg
            workDepLabel.text = model.workDep
            imgOrderPriceLabel.text = "\(model.imgOrderPrice)"
            telOrderPriceLabel.text = "\(model.telOrderPrice)"
            videoOrderPriceLabel.text = "\(model.videoOrderPrice)"
            followUpPriceLabel.text = "\(model.followUpPrice)"

        }
    }
}
