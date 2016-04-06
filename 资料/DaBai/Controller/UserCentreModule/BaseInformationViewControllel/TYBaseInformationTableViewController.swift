//
//  TYBaseInformationTableViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/29.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYBaseInformationTableViewController: UITableViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    /// 是否是在用户中心
    var isUserCenter:Bool = true
    private var imagePicker:UIImagePickerController!
    private var doctor = TYDoctorUpdateEntity()
    private var certImageData:NSData!
    /// 真实姓名
    @IBOutlet weak var userNameLabel: UILabel!
    /// 出生日期
    @IBOutlet weak var birthDatelabel: UILabel!
    /// 性别
    @IBOutlet weak var sexLabel: UILabel!
    /// 医院地址
    @IBOutlet weak var addressLabel: UILabel!
    /// 医院名称
    @IBOutlet weak var workOrgLabel: UILabel!
    /// 所在科室
    @IBOutlet weak var workDep: UILabel!
    /// 职称
    @IBOutlet weak var workTitle: UILabel!
    /// 医疗资格证编号
    @IBOutlet weak var certTipLabel: UILabel!
    /// 医疗资格证图片
    @IBOutlet weak var certImageView: UIImageView!
    /// 提交按钮
    @IBOutlet weak var submitButton: UIButton!

    @IBAction func submit(sender: UIButton) {
        doctor.userName = userNameLabel.text
        doctor.birthDate = birthDatelabel.text
        doctor.sexId = sexLabel.text
        doctor.workOrg = workOrgLabel.text
        doctor.workTitle = workTitle.text
        doctor.certTip = certTipLabel.text
        
        if doctor.userName == "" {
            SVProgressHUD.showErrorWithStatus("用户名不能为空")
            return
        }
        if doctor.birthDate == "" {
            SVProgressHUD.showErrorWithStatus("出生年月不能为空")
            return
        }
        if doctor.sexId == "" {
            SVProgressHUD.showErrorWithStatus("性别不能为空")
            return
        }
        if doctor.workOrg == "" {
            SVProgressHUD.showErrorWithStatus("医院不能为空")
            return
        }
        if doctor.certTip == "" {
            SVProgressHUD.showErrorWithStatus("医疗资格证不能为空")
            return
        }
        SVProgressHUD.showWithStatus("修改资料")

        if doctor.certImg == "" {
            if certImageData == nil {
                SVProgressHUD.showErrorWithStatus("请上传行医资格证图片")
            }else {
                self.uploadImage()
            }
        }else {
            if certImageData == nil {
                self.uploadDate()
            }else {
                self.uploadImage()
            }
        }
    }

    /**
    配置视图
    */
    private func configurationView(){
        self.submitButton.layer.cornerRadius = 8
        self.submitButton.layer.masksToBounds = true
    }
    private func tableViewsHeaderLabelWithMessage(message:String)->UILabel! {
        var label = UILabel(frame: CGRectMake(0, 50, 320, 40))
        label.font = UIFont.boldSystemFontOfSize(15)
        label.textColor = UIColor.darkGrayColor()
        label.textAlignment = NSTextAlignment.Center
        label.text = message
        return label
    }
    private func setInformation(){
        let doctorInformation = TYDoctorInformationStorage.doctorInformation()
        doctor.fromDoctorInformationEntity(doctorInformation)
        
        userNameLabel.text = doctorInformation.userName
        birthDatelabel.text = doctorInformation.birthDate
        
        switch doctorInformation.sexId {
        case "1":
            sexLabel.text = "男"
        case "2":
            sexLabel.text = "女"
        default:
            sexLabel.text = doctorInformation.sexId
        }
        addressLabel.text = doctorInformation.province + doctorInformation.city + doctorInformation.town
        workOrgLabel.text = doctorInformation.workOrg
        workDep.text = doctorInformation.workDep
        if doctorInformation.workDep == "" {
            workDep.text = doctorInformation.workBigDep
        }
        workTitle.text = doctorInformation.workTitle
        certTipLabel.text = doctorInformation.certTip
        if isUserCenter {
            var checkStateText:String = ""
            switch doctorInformation.checkState {
            case "1":
                checkStateText = "未提交审核"
            case "2":
                checkStateText = "提交审核/审核中"
            case "3":
                checkStateText = "审核通过"
            case "4":
                checkStateText = "审核拒绝"
            default:
                break
            }
            self.tableView.tableHeaderView = self.tableViewsHeaderLabelWithMessage(checkStateText)
            
        }
        if doctorInformation.certImg != "" {
            let handler = TYOssDownloadHandler(key: doctorInformation.certImg)
            handler.getdata { (data, error) -> Void in
                if data != nil {
                    let downloadImage = UIImage(data: data)
                    self.certImageView.image = downloadImage!
                }
            }
        }
    }
    private func uploadImage(){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let randomName = dateFormatter.stringFromDate(NSDate()) + "\(arc4random() % 1000).jpg"
        let imagePath = TYSysConfigStorage.sysConfig().ossImagePath + randomName
        let handler = TYOssUploadHandler(data: self.certImageData, type: "jpg", key: imagePath)
        
        handler.uploadData { (isSuccess, error) -> Void in
            if isSuccess {
                self.doctor.certImg = imagePath
                self.uploadDate()
            }else {
                SVProgressHUD.showErrorWithStatus("图片上传失败")
                println(error)
            }
        }
    }
    private func uploadDate(){
        let handler = TYDoctorUpdateHandler()
        handler.executeDoctorUpdateTask(doctor, success: { (operation, responseObject) -> Void in
            if let resultFlag = responseObject["optFlag"] as? Bool {
                if !resultFlag {
                    let message = responseObject["message"] as? String
                    SVProgressHUD.showErrorWithStatus(message)
                }else {
                    SVProgressHUD.showSuccessWithStatus("修改成功")
                    let data:AnyObject! = responseObject["data"]
                    if self.isUserCenter {
                        self.navigationController?.popViewControllerAnimated(true)
                    }else {
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                        let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("TYExpandInformationViewController") as! TYExpandInformationViewController
                        nextViewController.isUserCenter = false
                        self.navigationController?.pushViewController(nextViewController, animated: true)
                    }
                }
            }else{
                
                SVProgressHUD.showErrorWithStatus("数据解析失败")
            }
            }) { (operation, error) -> Void in
                println(error)
                SVProgressHUD.showErrorWithStatus("服务器连接失败")
        }
        
    }
    
    private func selectUserName(indexPath: NSIndexPath){
        let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler(nil)
        let certainAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (action) -> Void in
            let textField:UITextField? = alertController.textFields?.first as? UITextField
            self.userNameLabel.text = textField?.text
            self.doctor.userName = self.userNameLabel.text
            
        }
        alertController.addAction(certainAction)
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    private func selectBirthDate(indexPath: NSIndexPath){
        let pickerDate = UIDatePicker()
        pickerDate.locale = NSLocale(localeIdentifier: "Chinese")
        pickerDate.datePickerMode = UIDatePickerMode.Date
        let title = "\n\n\n\n\n\n\n\n\n\n\n"
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let certainAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (action) -> Void in
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.birthDatelabel.text = formatter.stringFromDate(pickerDate.date)
            self.doctor.birthDate = self.birthDatelabel.text
        }
        alertController.addAction(certainAction)
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.view.addSubview(pickerDate)
        var popVer = alertController.popoverPresentationController
        if popVer != nil {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            popVer?.sourceRect = cell!.bounds
            popVer?.sourceView = cell?.contentView
            popVer?.permittedArrowDirections = UIPopoverArrowDirection.Any
        }
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    private func selectSex(indexPath: NSIndexPath){
        let alertController = UIAlertController(title: "选择性别", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let manAction = UIAlertAction(title: "男", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.sexLabel.text = "男"
            self.doctor.sexId = "1"
            
        })
        let womanAction = UIAlertAction(title: "女", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.sexLabel.text = "女"
            self.doctor.sexId = "2"
            
        })
        alertController.addAction(manAction)
        alertController.addAction(womanAction)
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        
        var popVer = alertController.popoverPresentationController
        if popVer != nil {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            popVer?.sourceRect = cell!.bounds
            popVer?.sourceView = cell?.contentView
            popVer?.permittedArrowDirections = UIPopoverArrowDirection.Any
        }
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    private func selectAddress(indexPath: NSIndexPath){
        let title = "\n\n\n\n\n\n\n\n\n\n\n"
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let picker = TYCityPickerView(frame: CGRectZero)
        let certainAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (action) -> Void in
            if picker.area == "" {
                self.addressLabel.text = picker.province + "-" + picker.city
            }else {
                self.addressLabel.text = picker.province + "-" + picker.city + "-" + picker.area
            }
            self.doctor.province = picker.province
            self.doctor.city = picker.city
            self.doctor.town = picker.area
        }
        alertController.addAction(certainAction)
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.view.addSubview(picker)
        
        var popVer = alertController.popoverPresentationController
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    private func selectWorkOrg(indexPath: NSIndexPath){
        let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler(nil)
        let certainAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (action) -> Void in
            let textField:UITextField? = alertController.textFields?.first as? UITextField
            self.workOrgLabel.text = textField?.text
            self.doctor.workOrg = self.workOrgLabel.text
            
        }
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.addAction(certainAction)
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    private func selectWorkDep(indexPath: NSIndexPath){

    }
    private func selectWorkTitle(indexPath: NSIndexPath){

    }
    private func selectCertTip(indexPath: NSIndexPath){
        let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler(nil)
        let certainAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (action) -> Void in
            let textField:UITextField? = alertController.textFields?.first as? UITextField
            self.certTipLabel.text = textField?.text
            self.doctor.certTip = self.certTipLabel.text
            
        }
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        
        alertController.addAction(certainAction)
        self.presentViewController(alertController, animated: true, completion: nil)

    }

    private func selectCertImage(indexPath: NSIndexPath) {
        let alertController = UIAlertController(title: nil, message: "上传图片", preferredStyle: UIAlertControllerStyle.ActionSheet)
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let selectPhotoLibraryAction = UIAlertAction(title: "从相册上传", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        }
        let selectCameraAction = UIAlertAction(title: "拍照上传", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        }
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        alertController.addAction(selectPhotoLibraryAction)
        if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear) {
            alertController.addAction(selectCameraAction)
        }
        
        var popVer = alertController.popoverPresentationController
        if popVer != nil {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            popVer?.sourceRect = cell!.bounds
            popVer?.sourceView = cell?.contentView
            popVer?.permittedArrowDirections = UIPopoverArrowDirection.Any
        }
        presentViewController(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        self.configurationView()
        self.setInformation()
        TYDoctorInformationStorage.refreshInformation { () -> Void in
            self.setInformation()
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section,indexPath.row) {
        case (0,0)://修改姓名
            self.selectUserName(indexPath)
        case (0,1)://修改出生日期
            self.selectBirthDate(indexPath)
        case (0,2)://修改性别
            self.selectSex(indexPath)
        case (1,0)://修改医院地址
            self.selectAddress(indexPath)
        case (1,1)://修改医院名称
            self.selectWorkOrg(indexPath)
        case (1,2)://修改所在科室
            self.selectWorkDep(indexPath)
        case (1,3)://修改职称
            self.selectWorkTitle(indexPath)
        case (1,4)://修改医疗资格证编号
            self.selectCertTip(indexPath)
        case (1,5)://修改医疗资格证图片
            self.selectCertImage(indexPath)
        default:
            break
        }
    }
//    UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        let image:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.certImageData = UIImageJPEGRepresentation(image, 0.5)
        let saveImage = UIImage(data: certImageData)
        certImageView.image = saveImage
    }
}
