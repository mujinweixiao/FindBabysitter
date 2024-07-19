//
//  FBApiHeader.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/5.
//

#ifndef FBApiHeader_h
#define FBApiHeader_h

/**  ------------------------------------------本地存储------------------------------------------   **/
//存储标识，设备第一次打开判断 无值代表第一次打开
#define FBFirstOpen @"FBFirstOpen"

/**  ------------------------------------------通知------------------------------------------   **/
//配置接口请求成功
#define NotHomeConfigRequestSuccess @"NotHomeConfigRequestSuccess"

/**  ------------------------------------------三方key------------------------------------------   **/
//阿里一键登录key
#define PNSATAUTHSDKINFO @"QDOrmSn+XohBTMD3OO1hZs0vmceQl822GWBCdJB6KsRZF3bP7lANm/kHIEFv6GbCATm5fKNb1hOK9iSOu4TxAHLboykeUBRwO5zjGHBUJesVtJQihWBuhA7LtdFUYOEO9HlHV/NofL8zij0Ox/u3P1I7WlKklK75AS2hyZB3rbOQz8LuqUmg7RduKw2igipgv7+K37Cz+Clihh/j20bR9BJvUMddwayyuZVuJcf12INiCI2SAD0zIv9wtMVQOLYBO51GcmUjHAk="
//友盟
#define UMAppKey @"668a5b88cac2a664de6247f4"
//百度地图
#define BaiDuMapKey @"a6uEV4uTxpExNztTpwUe3veUerfBY2gp"

//隐私协议
#define PrivacyAgreement @"https://api.luckybaomu.com/h5/agreement/ujaTwNw0pZI1aDezQfvjFLEq77nzCttP"
//服务协议
#define ServeAgreement @"https://api.luckybaomu.com/h5/agreement/Tk2lUzimjPYph6IL59lBwmkfrQrMPRat"
//个人信息收集清单
#define UserCollectionList @"https://api.luckybaomu.com/h5/agreement/oOI5CGnvk8aFpbxhR6z3jJaM3Hi37w9B"


/**  ------------------------------------------网络------------------------------------------   **/
//http://47.121.188.79
//https://api.luckybaomu.com
#define AppNetURL         @"https://api.luckybaomu.com"
//1.快速登录接口
#define quickLogin_Url [NSString stringWithFormat:@"%@/api/quickLogin",AppNetURL]
//2.短信发送
#define sendSms_Url [NSString stringWithFormat:@"%@/api/sendSms",AppNetURL]
//3.提交反馈接口（需登录）
#define toSubmitFeedBack_Url [NSString stringWithFormat:@"%@/api/auth/toSubmitFeedBack",AppNetURL]
//4.首页配置接口
#define homeConfig_Url [NSString stringWithFormat:@"%@/api/homeConfig",AppNetURL]
//5.页面模版配置接口
#define templateConfig_Url [NSString stringWithFormat:@"%@/api/templateConfig",AppNetURL]
//6.关于我们接口
#define aboutUs_Url [NSString stringWithFormat:@"%@/api/aboutUs",AppNetURL]
//7.消息列表接口（需登录）
#define noticeLists_Url [NSString stringWithFormat:@"%@/api/auth/noticeLists",AppNetURL]
//8.设置消息已读接口（需登录）
#define noticeSetRead_Url [NSString stringWithFormat:@"%@/api/auth/noticeSetRead",AppNetURL]
//9.设备激活接口（设备初次启动时调用）
#define toSubmitActive_Url [NSString stringWithFormat:@"%@/api/toSubmitActive",AppNetURL]
//10.一键登录接口
#define oneClickAuthentication_Url [NSString stringWithFormat:@"%@/api/oneClickAuthentication",AppNetURL]
//11.表单提交接口（需登录）
#define toSubmitForm_Url [NSString stringWithFormat:@"%@/api/auth/toSubmitForm",AppNetURL]
//12.用户注销接口（需登录
#define accountCancellation_Url [NSString stringWithFormat:@"%@/api/auth/accountCancellation",AppNetURL]

#endif /* FBApiHeader_h */
