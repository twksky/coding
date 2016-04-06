
//
//  TYNetworkingSetting.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/25.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import Foundation
/**
*  全局域名
*/
let TYSERVER_HOST = "http://192.168.1.26:8080/appBase"
/**
*  WebSocketUrl
*/
let WebSocketUrl = "ws://192.168.1.26:8080/mesPush/mesSocket.do?Cookie="
/************************个人中心模块******************************/
/**
*  登陆
*/
let TYAPI_LOGIN = "logincheck.do"
/**
*  获取当前登录用户的信息
*/
let TYAPI_GET_LOGIN_DATA = "sysusers/getLoginData.do"
/**
*  注册
*/
let TYAPI_REGIST = "login/regDoctor.do"
/**
*  判断用户是否登录
*/
let TYAPI_GET_SESSION = "sysusers/getSession.do"

/**
*  修改密码
*/
let TYAPI_UPDATE_PASSWORD = "sysusers/updateUserPassword.do"
/**
*  获取短信验证码
*/
let TYAPI_GET_SMS_VERITY_CODE = "login/getSmsVerifyCode.do"
/**
*  找回密码
*/
let TYAPI_FIND_PASSWORD = "login/findUserPassword.do"
/**
*  修改基本资料
*/
let TYAPI_DOCTOR_UPDATE = "dcdoctor/dcDoctorUpd.do"
/**
*  完善资料
*/
let TYAPI_DOCTOR_INFORMATION_COMPLETE = "dcdoctor/dcDoctorCompleteUpd.do"
/**
*  设置咨询状态
*/
let TYAPI_DOCTOR_ORDER_STATE_UPDATE = "dcdoctor/consultStateUpd.do"

/**
*  设置咨询价格
*/
let TYAPI_DOCTOR_ORDER_PRICE_UPDATE = "dcdoctor/consultPriceUpd.do"

/**
*  设置医生结算账号
*/
let TYAPI_DOCTOR_UPDATE_ACCOUNT = "doctoraccount/updateDoctorAccount.do"
/**
*  获取医生结算账号信息
*/
let TYAPI_GET_DOCTOR_ACCOUNT = "doctoraccount/doctoraccountFindById.do"
/**
*  获取用户信息
*/
let TYAPI_GET_USER_ACCOUNT = "sysusers/sysusersFindById.do"
/**
*  获取字典信息
*/
let TYAPI_GET_DIC_LIST = "sysdic/allDic.do"//"login/allDic.do"
/**
*  注销登录
*/
let TYAPI_LOGOUT = "sysusers/logout.do"
/************************患者模块******************************/
/**
*  获取患者列表
*/
let TYAPI_GET_PATIENT_LIST = "dcpatientdoctor/dcpatientdoctorList.do"
/**
*  新增患者
*/
let TYAPI_ADD_PATIENT = "papatient/dcInsPapatient.do"
/**
*  获取患者详情
*/
let TYAPI_GET_PATIENT_INFO = "papatient/papatientFind.do"
/**
*  获取患者病历列表
*/
let TYAPI_GET_PACASEHISTORY_LIST = "pacasehistory/pacasehistoryList.do"
/**
*  新增患者病历
*/
let TYAPI_ADD_PACASEHISTORY = "pacasehistory/pacasehistoryInsert.do"
/**
*  获取患者病历详情
*/
let TYAPI_GET_PACASEHISTORY_INFO = "pacasehistory/pacasehistoryFind.do"
/************************咨询模块******************************/
/**
*  获取咨询列表
*/
let TYAPI_GET_CONSULT_LIST = "zxconsultinfo/zxconsultinfoList.do"
/**
*  新增并发起咨询
*/
let TYAPI_ADD_CONSULT = "zxconsultinfo/addAndBeginConsult.do"
/**
*  接受咨询
*/
let TYAPI_ACCEPT_CONSULT = "zxconsultinfo/acceptConsult.do"
/**
*  拒绝咨询
*/
let TYAPI_UNACCEPT_CONSULT = "zxconsultinfo/notAcceptConsult.do"
/**
*  取消咨询
*/
let TYAPI_CANCEL_CONSULT = "zxconsultinfo/cancelConsult.do"
/**
*  获取咨询详情
*/
let TYAPI_CONSULT_INFO = "zxconsultinfo/zxconsultinfoFind.do"
/**
*  获取可接受咨询医生列表
*/
let TYAPI_DOCTOR_LIST = "dcdoctor/dcdoctorList.do"
/**
*  获取医生详情
*/
let TYAPI_DOCTOR_INFO = "dcdoctor/dcdoctorFind.do"
/**
*  发送咨询信息
*/
let TYAPI_SEND_MESSAGE = "zxconsultmeshis/sendMes.do"
/**
*  获取聊天记录
*/
let TYAPI_MESSAGE_HISTORY = "zxconsultmeshis/zxconsultmeshisFind.do"
/**
*  判断当前登录用户是否有使用 医院专款的权限
*/
let TYAPI_IS_HAVE_HOSPITAL_PAY = "hospitalAccountPay/isHavePay.do"
/**
*  医院专款确认支付
*/
let TYAPI_HOSPITAL_PAY = "hospitalAccountPay/submitPay.do"
/**
*  提交会诊意见
*/
let TYAPI_SUBMIT_CONSULT_OPINION = "zxconsultinfo/submitConsultOpinion.do"
/**
*  取得当前登录用户的所有未读消息
*/
let TYAPI_UNREAD_MESSAGE_LIST = "mesuserunread/getUserUnread.do"

