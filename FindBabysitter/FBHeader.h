//
//  Header.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/6/25.
//

#ifndef FBHeader_h
#define FBHeader_h


#define KScreenW [UIScreen mainScreen].bounds.size.width
#define KScreenH [UIScreen mainScreen].bounds.size.height


#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.f]
//文字字号
#define MediumFont(fontSize) [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize]
#define BoldFont(fontSize) [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize]
#define RegularFont(fontSize) [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize]

// 判断是iPhone且有安全区
#define HasSafeArea \
({BOOL isPhoneX = NO;\
if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {\
    (isPhoneX);\
}\
else if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define SafeAreaTopHeight (HasSafeArea ? 88 : 64)
#define SafeAreaBottomHeight (HasSafeArea  ? 34 : 0)
#define SafeBangTopHeight (HasSafeArea ? 30 : 0)
#define SafeBangTwoTopHeight (HasSafeArea ? 24 : 0)

//tabbar高度
#define SafeAreaTabBarHeight (HasSafeArea ? (49 + 34) : 49)

//状态条的高
#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//获取导航栏+状态栏的高度
#define getRectNavAndStatusHight  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height

/** 本地存 */
#define kUserDefault_write(OBJECT,KEY) \
[[NSUserDefaults standardUserDefaults] setObject:OBJECT forKey:KEY];\
[[NSUserDefaults standardUserDefaults] synchronize];
/** 本地取 */
#define kUserDefault_read(KEY) [[NSUserDefaults standardUserDefaults] objectForKey:KEY]
/** 业务信息单例 */
#define kUserInfoModel [FBUserInfoModel shareInstance]
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
// string是否为空、空对象
#define isNULLString(string) ((![string isKindOfClass:[NSString class]]) || [string isEqualToString:@""] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 || [string isEqualToString:@"(null)"] || [string isEqualToString:@"<null>"])
/** 转换为字符串 */
#define kStr(string) (isNULLString(string) ? @"" : string)

#define NonNULLString(string) (isNULLString(string) ? @"" : string)


#endif /* FBHeader_h */
