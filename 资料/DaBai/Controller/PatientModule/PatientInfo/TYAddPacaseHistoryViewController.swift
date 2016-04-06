//
//  TYAddPacaseHistoryViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/8.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class TYAddPacaseHistoryViewController: TYBaseViewController,UITextViewDelegate,IQAudioRecorderControllerDelegate {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var symptomTextView: UITextView!
    @IBOutlet weak var processTextView: UITextView!
    @IBOutlet weak var diacrisisTextView: UITextView!
    
    /// 患者ID
    var patientId:Int!
    
    private var currentTextView:UITextView?
    private var keyboardRect:CGRect?
    private var recordPath:String?
    
    @IBAction func savePacaseHistory(sender: UIButton) {
        self.savePacaseHistory { () -> Void in
            SVProgressHUD.showSuccessWithStatus("保存成功")
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    @IBAction func submitConsult(sender: UIButton) {
        self.savePacaseHistory { () -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let nextViewController:TYDoctorListViewController = storyboard.instantiateViewControllerWithIdentifier("TYDoctorListViewController") as! TYDoctorListViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    @IBAction func playSymptom(sender: UIButton) {
        if recordPath != nil {
            var player:MPMoviePlayerController = MPMoviePlayerController(contentURL: NSURL(fileURLWithPath: recordPath!))
//            self.presentMoviePlayerViewControllerAnimated(player)
        }

    }
    @IBAction func recordSymptom(sender: UIButton) {
        let controller = IQAudioRecorderController()
        controller.delegate = self
        self.presentViewController(controller, animated: true, completion: nil)
    }

    /**
    保存病例
    */
    private func savePacaseHistory (success:()->Void) {
        let handler = TYBaseHandler(API: TYAPI_ADD_PACASEHISTORY)
        var parameter = [String:AnyObject]()
        parameter.updateValue(self.patientId, forKey: "patientId")
        if !self.symptomTextView.text.isEmpty {
            parameter.updateValue(self.symptomTextView.text, forKey: "symptomText")
        }
        if !self.processTextView.text.isEmpty {
            parameter.updateValue(self.processTextView.text, forKey: "processText")
        }
        if !self.diacrisisTextView.text.isEmpty {
            parameter.updateValue(self.diacrisisTextView.text, forKey: "diacrisisText")
        }
        //        parameter.updateValue("", forKey: "symptomSound")
        //        parameter.updateValue("", forKey: "processSound")
        //        parameter.updateValue("", forKey: "diacrisisSound")
        parameter.updateValue("1", forKey: "consultState")
        //        parameter.updateValue("", forKey: "workOrg")
        //        parameter.updateValue("", forKey: "workDep")
        //        parameter.updateValue("", forKey: "casePsList")
        
        
        handler.executeTaskWithSVProgressHUD(parameter, callBackData: { (callBackData) -> Void in
            success()
            }, failed: nil)
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
        if (self.currentTextView != nil) {
            let height = self.keyboardRect!.origin.y - (self.backgroundView.frame.origin.y + self.currentTextView!.frame.size.height + (self.currentTextView!.convertRect(self.currentTextView!.bounds, toView: self.backgroundView)).origin.y)
            if height<0 {
                UIView.animateWithDuration(duration, animations: { () -> Void in
                    self.backgroundView.transform = CGAffineTransformMakeTranslation(0, height)
                })
            }
        }
    }
    func keyboardWillHide(aNotification:NSNotification) {
        self.backgroundView.transform = CGAffineTransformMakeTranslation(0, 0)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurationKeyboardNotification()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.currentTextView?.resignFirstResponder()
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

    //MARK:- IQAudioRecorderControllerDelegate
    func audioRecorderController(controller: IQAudioRecorderController!, didFinishWithAudioAtPath filePath: String!) {

        println(filePath)
        self.recordPath = filePath
    }
    func audioRecorderControllerDidCancel(controller: IQAudioRecorderController!) {
        
    }
    
}
