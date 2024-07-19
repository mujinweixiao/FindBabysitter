//
//  AppDelegate.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/6/25.
//

#import "AppDelegate.h"
#import "FBTabBarController.h"
#import "FBLoginPopController.h"
@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /** 本地个人信息取值 **/
   [kUserInfoModel loadUserInfoData];
    //根视图
    FBTabBarController *tabBarController = [[FBTabBarController alloc] init];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    //一键登录
    [self setupOneClickLogin];
    //友盟
    [self setupUMWithOptions:launchOptions];
    //百度地图
    [self setupBaiduMap];
    //监听网络状态
    [self netChangeClick];
    
    return YES;
}
#pragma mark - 百度地图
- (void)setupBaiduMap
{
    // 要使用百度地图，请先启动BaiduMapManager
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [mapManager start:BaiDuMapKey generalDelegate:nil];
    if (!ret) {
        NSLog(@"启动引擎失败");
    }
    
    /**
      百度地图SDK所有API均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
      默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
      如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
      */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK: BMK_COORDTYPE_COMMON]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }
}

#pragma mark - 一键登录
- (void)setupOneClickLogin
{
    [[TXCommonHandler sharedInstance] setAuthSDKInfo:PNSATAUTHSDKINFO
                                            complete:^(NSDictionary * _Nonnull resultDic) {
        NSLog(@"设置秘钥结果：%@", resultDic);
    }];
}
#pragma mark - 友盟
-(void)setupUMWithOptions:(NSDictionary *)launchOptions {

    #ifdef DEBUG
    [UMConfigure setLogEnabled:YES];//设置打开日志
    #else
    [UMConfigure setLogEnabled:NO];
    #endif
    //设置从push后端申请的appkey
    [UMConfigure initWithAppkey:UMAppKey channel:@"App Store"];
    // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
//    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    entity.types = UMessageAuthorizationOptionSound;
    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            
        }else{
            
        }
    }];
    
    //设置为自动采集页面
    [MobClick setAutoPageEnabled:YES];
    
    //埋点代码
//    [MobClick event:@"" attributes:@{}];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
     if(![deviceToken isKindOfClass:[NSData class]])return;
    
    const unsigned *tokenBytes =(const unsigned*)[deviceToken bytes];
    NSString*hexToken =[NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    kUserInfoModel.deviceToken = hexToken;
    //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    //传入的devicetoken是系统回调didRegisterForRemoteNotificationsWithDeviceToken的入参，切记
    [UMessage registerDeviceToken:deviceToken];
   
}
#pragma mark - 登录部分
- (void)oneLittleItemBtnClick
{    
    //2. 检测当前环境是否支持一键登录
    __block BOOL support = YES;
    [[TXCommonHandler sharedInstance] checkEnvAvailableWithAuthType:PNSAuthTypeLoginToken complete:^(NSDictionary * _Nullable resultDic) {
        support = [PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]];
        if(support){
            [self oneLoginClick];
        }else{
            NSLog(@"不支持一键登录");
            //登录弹窗
            FBLoginPopController *vc = [[FBLoginPopController alloc] init];
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [[FBHelper getCurrentController] presentViewController:vc animated:YES completion:nil];
        }
    }];
}
- (void)oneLoginClick
{
    TXCustomModel *model = [[TXCustomModel alloc] init];

    model.navColor = UIColor.whiteColor;
    model.navTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:@{NSForegroundColorAttributeName : UIColor.blackColor,NSFontAttributeName : [UIFont systemFontOfSize:20.0]}];
    //model.navIsHidden = NO;
    model.navBackImage = [UIImage imageNamed:@"icon_navbar_btn_back"];
    //model.hideNavBackItem = NO;
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [rightBtn setTitle:@"更多" forState:UIControlStateNormal];
//    model.navMoreView = rightBtn;

    model.privacyNavColor = UIColor.whiteColor;
    model.privacyNavBackImage = [UIImage imageNamed:@"icon_navbar_btn_back"];
    model.privacyNavTitleFont = [UIFont systemFontOfSize:20.0];
    model.privacyNavTitleColor = UIColor.blackColor;

    model.logoImage = [UIImage imageNamed:@"img_home_banner_one"];
    //model.logoIsHidden = NO;
    //model.sloganIsHidden = NO;
    model.sloganText = [[NSAttributedString alloc] initWithString:@"找个保姆" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:@"#16171A"],NSFontAttributeName : [UIFont systemFontOfSize:16.0]}];
    model.numberColor = [UIColor colorWithHex:@"#16171A"];
    model.numberFont = [UIFont systemFontOfSize:30.0];
    model.loginBtnText = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor,NSFontAttributeName : [UIFont systemFontOfSize:20.0]}];
    //model.autoHideLoginLoading = NO;
    model.privacyOne = @[@"《用户协议》",ServeAgreement];
    model.privacyTwo = @[@"《隐私政策》",PrivacyAgreement];
    model.privacyColors = @[[UIColor colorWithHex:@"#16171A"], [UIColor colorWithHex:@"#4971FF"]];
    model.privacyAlignment = NSTextAlignmentCenter;
    model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13.0];
    model.privacyOperatorPreText = @"《";
    model.privacyOperatorSufText = @"》";
    
    //model.checkBoxIsHidden = NO;
//    [agreementBtn setImage:[UIImage imageNamed:@"img_circle_noselect"] forState:UIControlStateNormal];
//    [agreementBtn setImage:[UIImage imageNamed:@"img_agreement_select"] forState:UIControlStateSelected];
    model.checkBoxImages = @[[UIImage imageNamed:@"img_circle_noselect"],[UIImage imageNamed:@"img_agreement_select"]];
    model.checkBoxWH = 17.0;
    model.changeBtnTitle = [[NSAttributedString alloc] initWithString:@"其他方式登录" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:@"#16171A"],NSFontAttributeName : [UIFont systemFontOfSize:16.0]}];
    //model.changeBtnIsHidden = NO;
    //model.prefersStatusBarHidden = NO;
    model.preferredStatusBarStyle = UIStatusBarStyleLightContent;
    //model.presentDirection = PNSPresentationDirectionBottom;

    //授权页默认控件布局调整
    //model.navBackButtonFrameBlock =
    //model.navTitleFrameBlock =
    model.navMoreViewFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        CGFloat width = superViewSize.height;
        CGFloat height = width;
        return CGRectMake(superViewSize.width - 15 - width, 0, width, height);
    };
//    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
//        if ([self isHorizontal:screenSize]) {
//            frame.origin.y = 20;
//            return frame;
//        }
//        return frame;
//    };
//    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
//        if ([self isHorizontal:screenSize]) {
//            return CGRectZero; //横屏时模拟隐藏该控件
//        } else {
//            return CGRectMake(0, 140, superViewSize.width, frame.size.height);
//        }
//    };
//    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
//        if ([self isHorizontal:screenSize]) {
//            frame.origin.y = 140;
//        }
//        return frame;
//    };
//    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
//        if ([self isHorizontal:screenSize]) {
//            frame.origin.y = 185;
//        }
//        return frame;
//    };
//    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
//        if ([self isHorizontal:screenSize]) {
//            return CGRectZero; //横屏时模拟隐藏该控件
//        } else {
//            return CGRectMake(10, frame.origin.y, superViewSize.width - 20, 30);
//        }
//    };
    //model.privacyFrameBlock =

    //添加自定义控件并对自定义控件进行布局
//    __block UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [customBtn setTitle:@"这是一个自定义控件" forState:UIControlStateNormal];
//    [customBtn setBackgroundColor:UIColor.redColor];
//    customBtn.frame = CGRectMake(0, 0, 230, 40);
//    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
//        [superCustomView addSubview:customBtn];
//    };
//    model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
//        CGRect frame = customBtn.frame;
//        frame.origin.x = (contentViewFrame.size.width - frame.size.width) * 0.5;
//        frame.origin.y = CGRectGetMinY(privacyFrame) - frame.size.height - 20;
//        frame.size.width = contentViewFrame.size.width - frame.origin.x * 2;
//        customBtn.frame = frame;
//    };
        
    // 横竖屏切换
//    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown;
    // 仅支持竖屏
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    // 仅支持横屏
//    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskLandscape;
    
    [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:3.0 controller:[FBHelper getCurrentController] model:model complete:^(NSDictionary * _Nonnull resultDic) {
        NSLog(@"一键登录结果：%@", resultDic);
        NSInteger resultCode = [resultDic i:@"resultCode"];
        if(resultCode == 700000){//点击授权页返回按钮
            
        }else if(resultCode == 700001){//点击切换其他登录方式
            //登录弹窗
            FBLoginPopController *vc = [[FBLoginPopController alloc] init];
            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            FBNavigationController *nav = [[FBNavigationController alloc] initWithRootViewController:vc];
            nav.view.backgroundColor = [UIColor clearColor];
            nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            nav.navigationBar.shadowImage = [UIImage new];
            nav.navigationBar.translucent = YES;
            [[FBHelper getCurrentController] presentViewController:nav animated:YES completion:nil];
        }else if(resultCode == 700002){//点击登录按钮事件，根据返回字典里面的 "isChecked"字段来区分check box是否被选中，只有被选中的时候内部才会去获取Token
            
        }else if(resultCode == 700003){//点击check box事件
            
        }else if(resultCode == 700004){//点击协议富文本文字
            
        }else if(resultCode == 600001){//授权页唤起成功
            
        }else if(resultCode == 600002){//授权页唤起失败
            
        }else if(resultCode == 600000){//成功获取Token
            NSLog(@"查看token");
            NSString *token = [resultDic string:@"token"];
            [self requestOneClickAuthenticationWithToken:token];
        }else if(resultCode == 600011){//获取Token失败
            
        }else if(resultCode == 600015){//获取Token超时
            
        }else if(resultCode == 600013){//运营商维护升级，该功能不可用
            
        }else if(resultCode == 600014){//运营商维护升级，该功能已达最大调用次数
            
        }
    }];
}
//一键登录
- (void)requestOneClickAuthenticationWithToken:(NSString *)token
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:token forKey:@"auth_token"];
    [dict setValue:kUserInfoModel.deviceToken forKey:@"device_tokens"];

    [FBRequestData requestWithUrl:oneClickAuthentication_Url para:dict Complete:^(NSData * _Nonnull data) {
        [[FBHelper getCurrentController] hideHud];
        NSDictionary *registerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *code = [registerDic string:@"code"];
        if([code isEqualToString:@"0"]){
            NSLog(@"");
            NSDictionary *data = [registerDic dictionary:@"data"];
            NSDictionary *token = [data dictionary:@"token"];
            NSString *token_type = [token string:@"token_type"];
            NSString *expires_in = [token string:@"expires_in"];
            NSString *access_token = [token string:@"access_token"];
            NSString *refresh_token = [token string:@"refresh_token"];
            NSString *mobile = [data string:@"mobile"];

            //本地token赋值
            [kUserInfoModel nullUserInfoData];
            kUserInfoModel.token = access_token;
            kUserInfoModel.mobile = mobile;
            [[FBHelper getCurrentController] showHint:@"登录成功"];
            //dismiss
            [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
        }else{
            NSString *msg = [registerDic string:@"msg"];
            [[FBHelper getCurrentController] showHint:msg];
        }
        NSLog(@"");
        
    } fail:^(NSError * _Nonnull error) {
        [[FBHelper getCurrentController] hideHud];
        [[FBHelper getCurrentController] showHint:@"请求失败"];
    }];
}
#pragma mark - 网络状态改变
- (void)netChangeClick
{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"网络状态未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络连接");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"通过蜂窝数据网络连接");
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:NotNetLinkSuccess object:nil userInfo:nil]];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"通过 WiFi 网络连接");
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:NotNetLinkSuccess object:nil userInfo:nil]];
                break;
            default:
                break;
        }
    }];
}
@end
