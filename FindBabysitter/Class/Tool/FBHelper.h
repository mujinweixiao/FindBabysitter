//
//  FBHelper.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBHelper : NSObject

//获取当前的控制器
+ (UIViewController *)getCurrentController;

// 检测相册
+ (void)checkPhoto:(void (^)(BOOL allow))handler;

// 检查相机权限
+ (void)checkCamera:(void (^)(BOOL allow))handler;

// 检查麦克风权限
+ (void)checkAudio:(void (^)(BOOL allow))handler;

// 获取app版本
+ (NSString *)getAppVersion;

// 获取bundleId
+ (NSString *)getAppBundleId;

// 设备类型
+ (NSString *)iphoneType;

// 操作系统版本号
+ (NSString *)iOSVersion;
// 供应商标识符
+ (NSString *)iOSUUID;


//转换成时分秒
+ (NSString *)timeFormatted:(int)totalSeconds;



//压缩图片到指定大小
+ (UIImage *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize;


/*
 数量换算，大于9999单位w,大于99999999单位亿
 amountStr 数量
 hasPoint 是否有小数点
*/
+ (NSString *)transformAmountStr:(NSString *)amountStr hasPoint:(BOOL)point;


// 压缩图片到指定大小
+ (UIImage *)reSizeImageData:(UIImage *)sourceImage maxSizeWithKB:(CGFloat) maxSize;

/**
* 是否是手机号
*/
+ (BOOL)validateMobile:(NSString *)mobileNum;



//查找文本内容里包含的手机号，并将中间四位替换为****
+ (NSString *)getHiddenPhoneNumberContentTextUseString:(NSString *)originContentText;



/*  判断字符串是否为空
 */
+ (BOOL) isBlankString:(NSString *)string;



#pragma mark --- 时间类
/**
 * 当前时间戳
 */
+ (NSString *)getTimeStamp;




/** 字符串转图片 **/
+ (UIImage *)stringToImage:(NSString *)str;

// 获取ADFA
//+ (NSString *)getIdfa;
@end

NS_ASSUME_NONNULL_END
