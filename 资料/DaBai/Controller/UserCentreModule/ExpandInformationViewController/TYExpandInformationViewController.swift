//
//  TYExpandInformationViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/29.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYExpandInformationViewController: TYBaseViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate{

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var dmottoTextView: UITextView!
    @IBOutlet weak var personalSpecialtyTextView: UITextView!
    @IBOutlet weak var dresumeTextVIew: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var scrollViewBottomLayout: NSLayoutConstraint!
    var isUserCenter:Bool = true
    
    private var currentTextView:UITextView?
    private var keyboardRect:CGRect?
    private var imagePicker:UIImagePickerController!
    private var doctor = TYDoctorUpdateExpandEntity()
    private var headImageData:NSData!

    @IBAction func update(sender: UIButton) {
        doctor.dmotto = dmottoTextView.text
        doctor.personalSpecialty = personalSpecialtyTextView.text
        doctor.dresume = dresumeTextVIew.text
        if headImageData == nil {
            self.uploadDate()
        }else {
            self.uploadImage()
        }
    }
    func selectImage() {
        
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
        alertController.addAction(selectPhotoLibraryAction)
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear) {
            alertController.addAction(selectCameraAction)
        }
        var popVer = alertController.popoverPresentationController
        if popVer != nil {
            popVer?.sourceRect = headImageView.bounds
            popVer?.sourceView = headImageView
            popVer?.permittedArrowDirections = UIPopoverArrowDirection.Any
        }
        presentViewController(alertController, animated: true, completion: nil)
    }

    private func setInformation() {
        let doctorInformation = TYDoctorInformationStorage.doctorInformation()
        doctor.fromDoctorInformationEntity(doctorInformation)
        
        dmottoTextView.text = doctorInformation.dmotto
        personalSpecialtyTextView.text = doctorInformation.personalSpecialty
        
        if doctorInformation.dresume != "" {
            let handler = TYOssDownloadHandler(key: doctorInformation.dresume)
            handler.getdata { (data, error) -> Void in
                if data != nil {
                    let downloadText = NSString(data: data, encoding: NSUTF8StringEncoding)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.dresumeTextVIew.text = downloadText! as String
                    })
                }
            }
        }
        if doctorInformation.headImg != "" {
            let handler = TYOssDownloadHandler(key: doctorInformation.headImg)
            handler.getdata { (data, error) -> Void in
                if data != nil {
                    let downloadImage = UIImage(data: data)
                    self.headImageView.image = downloadImage!
                }
            }
        }
    }

    private func uploadImage(){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let randomName = dateFormatter.stringFromDate(NSDate()) + "\(arc4random() % 1000).jpg"
        let imagePath = TYSysConfigStorage.sysConfig().ossImagePath + randomName
        let handler = TYOssUploadHandler(data: self.headImageData, type: "jpg", key: imagePath)
        
        handler.uploadData { (isSuccess, error) -> Void in
            if isSuccess {
                self.doctor.headImg = imagePath
                self.uploadDate()
            }else {
                SVProgressHUD.showErrorWithStatus("图片上传失败")
                println(error)
            }
        }
    }
    private func uploadDate(){
        let handler = TYDoctorUpdateExpandHandler()
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
                        let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainTabBarController") as! UITabBarController
                        nextViewController.selectedIndex = 2
                        self.presentViewController(nextViewController, animated: true, completion: nil)
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
    /**
    配置视图
    */
    private func configurationView(){
        self.submitButton.layer.cornerRadius = 8
        self.submitButton.layer.masksToBounds = true
        self.headImageView.layer.cornerRadius = self.headImageView.bounds.width/2
        self.headImageView.layer.masksToBounds = true
        headImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selectImage"))
    }
    
    /**
    配置键盘的通知
    */
    func configurationKeyboardNotification(){
        // MARK: - 注册键盘通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    // MARK: - 键盘出现和消失时调动的函数
    func keyboardWillShow(aNotification:NSNotification) {
        let userInfo:NSDictionary = aNotification.userInfo!
        self.keyboardRect = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue()
        let duration:Double = userInfo.objectForKey(UIKeyboardAnimationDurationUserInfoKey)!.doubleValue
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.scrollViewBottomLayout.constant = self.keyboardRect!.height
        })
        
        if (self.currentTextView != nil) {
            var distance:CGFloat = self.currentTextView!.frame.origin.y + self.currentTextView!.frame.height + keyboardRect!.height - self.scrollView.frame.height
            if distance > 0 {
                self.scrollView.contentOffset = CGPointMake(0, distance)
            }
        }
    }
    func keyboardWillHide(aNotification:NSNotification) {
        
        let userInfo:NSDictionary = aNotification.userInfo!
        self.keyboardRect = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue()
        let duration:Double = userInfo.objectForKey(UIKeyboardAnimationDurationUserInfoKey)!.doubleValue
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.scrollViewBottomLayout.constant = 0
        })
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurationKeyboardNotification()
        self.configurationView()
        self.setInformation()
        TYDoctorInformationStorage.refreshInformation { () -> Void in
            self.setInformation()
        }
    }
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.headImageData = UIImageJPEGRepresentation(image, 0.5)
        let saveImage = UIImage(data: headImageData)
        self.headImageView.image = saveImage
    }
    //MARK: - UITextViewDelegate
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.currentTextView = textView
        return true
    }
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        self.currentTextView = nil
        return true
    }
    func textViewDidEndEditing(textView: UITextView) {
        self.currentTextView = nil
    }
    func textViewDidBeginEditing(textView: UITextView) {
        self.currentTextView = textView
    }
    
}
