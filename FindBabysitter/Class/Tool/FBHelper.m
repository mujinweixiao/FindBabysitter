//
//  FBHelper.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/3.
//

#import "FBHelper.h"
#import <Photos/Photos.h>
#include <sys/utsname.h>
#import <AdSupport/ASIdentifierManager.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@implementation FBHelper

#pragma mark 获取当前的控制器
+ (UIViewController *)getCurrentController {

    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentShowingVC = [self findCurrentShowingViewControllerFrom:vc];
    return currentShowingVC;
}

+ (UIViewController *)findCurrentShowingViewControllerFrom:(UIViewController *)vc
{
    //方法1：递归方法 Recursive method
    UIViewController *currentShowingVC;
    if ([vc presentedViewController]) { //注要优先判断vc是否有弹出其他视图，如有则当前显示的视图肯定是在那上面
        // 当前视图是被presented出来的
        UIViewController *nextRootVC = [vc presentedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        UIViewController *nextRootVC = [(UITabBarController *)vc selectedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        UIViewController *nextRootVC = [(UINavigationController *)vc visibleViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else {
        // 根视图为非导航类
        if (vc.childViewControllers.count) {
            for (UIViewController *subvc in vc.childViewControllers) {
                if (subvc.isViewLoaded && subvc.view.window) {
                    currentShowingVC = subvc;
                    break;
                }
            }
            // 设置默认值
            if (currentShowingVC == nil) {
                currentShowingVC = vc;
                NSString *event = [NSString stringWithFormat:@"获取CurrentVC异常：%@", vc];
            }
        } else {
            currentShowingVC = vc;
        }
    }
    
    return currentShowingVC;
}


// 检查相册权限
+ (void)checkPhoto:(void (^)(BOOL allow))handler {
    PHAuthorizationStatus status;
    if (@available(iOS 14, *)) {
        status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
    } else {
        status = [PHPhotoLibrary authorizationStatus];
    }
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"相册权限被禁用，请到设置中授予翡翠精选允许访问相册权限" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }]];
        [[self getCurrentController] presentViewController:alertController animated:YES completion:nil];
        
    } else if (status == PHAuthorizationStatusNotDetermined) {
        if (@available(iOS 14, *)) {
            [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusRestricted
                        || status == PHAuthorizationStatusDenied
                        || status == PHAuthorizationStatusLimited) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(handler) handler(nil);
                        });
                    } else if (status == PHAuthorizationStatusAuthorized) {
                        if (handler) {
                            handler(YES);
                        }
                    }
                });
            }];
        } else {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusAuthorized && handler) {
                        handler(YES);
                    }
                });
            }];
        }
    } else {
        if (@available(iOS 14, *)) {
            if ((status == PHAuthorizationStatusLimited || status == PHAuthorizationStatusAuthorized) && handler) {
                handler(YES);
            }
        } else {
            if (status == PHAuthorizationStatusAuthorized && handler) {
                handler(YES);
            }
        }
    }
}

// 检查相机权限
+ (void)checkCamera:(void (^)(BOOL allow))handler {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"相机权限被禁用，请到设置中授予翡翠精选允许访问相机权限" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }]];
        [[self getCurrentController] presentViewController:alertController animated:YES completion:nil];
    } else if (status == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(YES);
                    }
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if (status == AVAuthorizationStatusAuthorized && handler) {
        handler(YES);
    }
}

// 检查麦克风权限
+ (void)checkAudio:(void (^)(BOOL allow))handler{
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"麦克风权限被禁用，请到设置中授予翡翠精选允许访问麦克风权限" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }]];
        [[self getCurrentController] presentViewController:alertController animated:YES completion:nil];
        
    } else if (status == AVAuthorizationStatusNotDetermined) {
        //用户首次授权时
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (handler) {
                        handler(YES);
                    }
                });
            }
        }];
        // 需要检查麦克风权限
    }else if (status == AVAuthorizationStatusAuthorized && handler){
        handler(YES);
    }
    
}


// 获取app版本
+ (NSString *)getAppVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}



// 获取bundleId
+ (NSString *)getAppBundleId {

    return [[NSBundle mainBundle] bundleIdentifier];
}

// 设备类型
+ (NSString *)iphoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *phoneType = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];

    if([phoneType  isEqualToString:@"iPhone1,1"])  return @"iPhone 2G";

    if([phoneType  isEqualToString:@"iPhone1,2"])  return @"iPhone 3G";
    if([phoneType  isEqualToString:@"iPhone2,1"])  return @"iPhone 3GS";

    if([phoneType  isEqualToString:@"iPhone3,1"])  return @"iPhone 4";
    if([phoneType  isEqualToString:@"iPhone3,2"])  return @"iPhone 4";
    if([phoneType  isEqualToString:@"iPhone3,3"])  return @"iPhone 4";
    if([phoneType  isEqualToString:@"iPhone4,1"])  return @"iPhone 4S";

    if([phoneType  isEqualToString:@"iPhone5,1"])  return @"iPhone 5";
    if([phoneType  isEqualToString:@"iPhone5,2"])  return @"iPhone 5";
    if([phoneType  isEqualToString:@"iPhone5,3"])  return @"iPhone 5c";
    if([phoneType  isEqualToString:@"iPhone5,4"])  return @"iPhone 5c";
    if([phoneType  isEqualToString:@"iPhone6,1"])  return @"iPhone 5s";
    if([phoneType  isEqualToString:@"iPhone6,2"])  return @"iPhone 5s";

    if([phoneType  isEqualToString:@"iPhone7,1"])  return @"iPhone 6 Plus";
    if([phoneType  isEqualToString:@"iPhone7,2"])  return @"iPhone 6";
    if([phoneType  isEqualToString:@"iPhone8,1"])  return @"iPhone 6s";
    if([phoneType  isEqualToString:@"iPhone8,2"])  return @"iPhone 6s Plus";

    if([phoneType  isEqualToString:@"iPhone8,4"])  return @"iPhone SE";

    if([phoneType  isEqualToString:@"iPhone9,1"])  return @"iPhone 7";
    if([phoneType  isEqualToString:@"iPhone9,2"])  return @"iPhone 7 Plus";

    if([phoneType  isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if([phoneType  isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if([phoneType  isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if([phoneType  isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";

    if([phoneType  isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if([phoneType  isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if([phoneType  isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if([phoneType  isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if([phoneType  isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";
    if([phoneType  isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    
    if ([phoneType isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([phoneType isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([phoneType isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";

    if ([phoneType isEqualToString:@"iPhone12,8"]) return @"iPhone SE 2";//2代

    if ([phoneType isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";
    if ([phoneType isEqualToString:@"iPhone13,2"]) return @"iPhone 12";
    if ([phoneType isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";
    if ([phoneType isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";

    if ([phoneType isEqualToString:@"iPhone14,2"]) return @"iPhone 13 Pro";
    if ([phoneType isEqualToString:@"iPhone14,3"]) return @"iPhone 13 Pro Max";
    if ([phoneType isEqualToString:@"iPhone14,4"]) return @"iPhone 13 mini";
    if ([phoneType isEqualToString:@"iPhone14,5"]) return @"iPhone 13";

    if ([phoneType isEqualToString:@"iPhone14,6"]) return @"iPhone SE 3";

    if ([phoneType isEqualToString:@"iPhone14,7"]) return @"iPhone 14";
    if ([phoneType isEqualToString:@"iPhone14,8"]) return @"iPhone 14 Plus";
    if ([phoneType isEqualToString:@"iPhone15,2"]) return @"iPhone 14 Pro";
    if ([phoneType isEqualToString:@"iPhone15,3"]) return @"iPhone 14 Pro Max";
    
    if ([phoneType isEqualToString:@"iPhone15,4"]) return @"iPhone 15";
    if ([phoneType isEqualToString:@"iPhone15,5"]) return @"iPhone 15 Plus";
    if ([phoneType isEqualToString:@"iPhone16,1"]) return @"iPhone 15 Pro";
    if ([phoneType isEqualToString:@"iPhone16,2"]) return @"iPhone 15 Pro Max";
    
    if ([phoneType isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([phoneType isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([phoneType isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([phoneType isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([phoneType isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    if ([phoneType isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    if ([phoneType isEqualToString:@"iPad2,1"]) return @"iPad 2";
    if ([phoneType isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([phoneType isEqualToString:@"iPad2,3"]) return @"iPad 2";
    if ([phoneType isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([phoneType isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    if ([phoneType isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    if ([phoneType isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    if ([phoneType isEqualToString:@"iPad3,1"]) return @"iPad 3";
    if ([phoneType isEqualToString:@"iPad3,2"]) return @"iPad 3";
    if ([phoneType isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([phoneType isEqualToString:@"iPad3,4"]) return @"iPad 4";
    if ([phoneType isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if ([phoneType isEqualToString:@"iPad3,6"]) return @"iPad 4";
    if ([phoneType isEqualToString:@"iPad4,1"]) return @"iPad Air";
    if ([phoneType isEqualToString:@"iPad4,2"]) return @"iPad Air";
    if ([phoneType isEqualToString:@"iPad4,3"]) return @"iPad Air";
    if ([phoneType isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    if ([phoneType isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    if ([phoneType isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    if ([phoneType isEqualToString:@"i386"]) return @"iPhone Simulator";
    if ([phoneType isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    
    
    return phoneType;
}




//转换成时分秒

+ (NSString *)timeFormatted:(int)totalSeconds{

    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;

    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}


/// 调整图片尺寸和大小
/// @param sourceImage 原始图片
/// @param maxImageSize 新图片最大尺寸
/// @param maxSize 新图片最大存储大小（kb）
+ (UIImage *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize{
   if (maxSize <= 0.0) maxSize = 1024.0;
   if (maxImageSize <= 0.0) maxImageSize = 1024.0;
   //先调整分辨率
   CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
   CGFloat tempHeight = newSize.height / maxImageSize;
   CGFloat tempWidth = newSize.width / maxImageSize;
   if (tempWidth > 1.0 && tempWidth > tempHeight) {
       newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
   } else if (tempHeight > 1.0 && tempWidth < tempHeight){
       newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
   }
   UIGraphicsBeginImageContext(newSize);
   [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
   UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   //调整大小
   NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
   CGFloat sizeOriginKB = imageData.length / 1024.0;
   CGFloat resizeRate = 0.9;
   while (sizeOriginKB > maxSize && resizeRate > 0.1) {
       imageData = UIImageJPEGRepresentation(newImage,resizeRate);
       sizeOriginKB = imageData.length / 1024.0;
       resizeRate -= 0.1;
   }
   return [UIImage imageWithData: imageData];
}

// 操作系统版本号
+ (NSString *)iOSVersion {
    return [[UIDevice currentDevice] systemVersion];
}
// 供应商标识符
+ (NSString *)iOSUUID {
    NSString *vendorID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"Vendor ID: %@", vendorID);
    return vendorID;
}


/*
 数量换算，大于9999单位w,大于99999999单位亿
 amountStr 数量
 hasPoint 是否有小数点
*/
+ (NSString *)transformAmountStr:(NSString *)amountStr hasPoint:(BOOL)point {
    if (isNULLString(amountStr)) {
        return @"";
    }
    NSInteger tmpAmount = [amountStr integerValue];
    if ([amountStr floatValue] <= 0.000001) {
        return @"0";
    }
    if (0 <= tmpAmount && tmpAmount < 10000) {
        if (point) {
            return amountStr;
        } else {
            return [NSString stringWithFormat:@"%ld", (long)tmpAmount];
        }
    }else if (tmpAmount >= 10000 && tmpAmount < 100000000) {
        if (point) {
            //过滤小数点后0，只显示整数
            if ((tmpAmount % 10000) / 1000 == 0) {
                return [NSString stringWithFormat:@"%ldw",(long)(tmpAmount / 10000)];
            }
            return [NSString stringWithFormat:@"%ld.%zdw",(long)(tmpAmount / 10000),(long)((tmpAmount % 10000) / 1000)];
        } else {
            return [NSString stringWithFormat:@"%ldw",(long)(tmpAmount / 10000)];
        }
    } else {
        //过滤小数点后0，只显示整数
        if ((tmpAmount % 100000000) / 10000000 == 0) {
            return [NSString stringWithFormat:@"%ld亿",(long)(tmpAmount / 100000000)];
        }
        return [NSString stringWithFormat:@"%ld.%zd亿",(long)(tmpAmount / 100000000), (long)((tmpAmount % 100000000) / 10000000)];
    }
}



/// 调整图片尺寸和大小
/// @param sourceImage 原始图片
/// @param maxSize 新图片最大存储大小（kb）
+ (UIImage *)reSizeImageData:(UIImage *)sourceImage maxSizeWithKB:(CGFloat) maxSize{
   if (maxSize <= 0.0) maxSize = 1024.0;
   //先调整分辨率
   CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);

    // 204, 174
   newSize = CGSizeMake(204, 174);
   UIGraphicsBeginImageContext(newSize);
   [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
   UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   //调整大小
   NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
   CGFloat sizeOriginKB = imageData.length / 1024.0;
   CGFloat resizeRate = 0.9;
   while (sizeOriginKB > maxSize && resizeRate > 0.1) {
       imageData = UIImageJPEGRepresentation(newImage,resizeRate);
       sizeOriginKB = imageData.length / 1024.0;
       resizeRate -= 0.1;
   }
   return [UIImage imageWithData: imageData];
}



/**
* 是否是手机号
*/
+ (BOOL)validateMobile:(NSString *)mobileNum
{
    NSString* pPhoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(19[0,0-9])|(18[0,0-9])|(17[0,0-9])|(16[0,0-9]))\\d{8}$";
    NSPredicate* pPhoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pPhoneRegex];
    return [pPhoneTest evaluateWithObject:mobileNum];
}


//查找文本内容里包含的手机号，并将中间四位替换为****
+ (NSString *)getHiddenPhoneNumberContentTextUseString:(NSString *)originContentText{

    if(isNULLString(originContentText)){
        return originContentText;
    }
    
    NSError *error;
    //设置正则规则：第一位是数字1，接下来后边是10位数字
    NSRegularExpression *attachmentExpression = [NSRegularExpression regularExpressionWithPattern:@"1[\\d]{10}"
    options:NSRegularExpressionCaseInsensitive error:&error];
    //获取符合条件的结果数组
    NSArray *resultArr = [attachmentExpression matchesInString:originContentText options:0 range:NSMakeRange(0, originContentText.length)];
    if (resultArr.count > 0) {
        //遍历结果数组，替换对应位置的字符串
        for (NSTextCheckingResult *tmpResult in resultArr) {
            NSString *tmpStr = [originContentText substringWithRange:tmpResult.range];
            //判断是否为手机号
            if([FBHelper validateMobile:tmpStr]){
                originContentText = [originContentText stringByReplacingCharactersInRange:tmpResult.range withString:[self getHiddenPhoneNumberUseString:tmpStr]];
            }
        }
    }
    return originContentText;
}
//替换手机号中间四位为****
+ (NSString *)getHiddenPhoneNumberUseString:(NSString *)originPhoneNumber
{
    //校验长度，防止传入数据不对引起崩溃
    if (originPhoneNumber.length >= 7) {
        return [originPhoneNumber stringByReplacingOccurrencesOfString:[originPhoneNumber substringWithRange:NSMakeRange(3,4)] withString:@"****"];
    } else {
        return originPhoneNumber;
    }
}


#pragma mark --- 判断空字符串
+ (BOOL) isBlankString:(NSString *)str {
    
    NSString *string = [NSString stringWithFormat:@"%@",str];
    
    if (string == nil || string == NULL ) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!string.length) {
        return YES;
    }
    /** 排除字符串中只有空格和回车符  (搬砖小弟) **/
    // 创建一个字符集对象, 包含所有的空格和换行字符
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    // 从字符串中过滤掉首尾的空格和换行, 得到一个新的字符串
    NSString *trimmedStr = [string stringByTrimmingCharactersInSet:set];
    // 判断新字符串的长度是否为0
    if (!trimmedStr.length) {
        // 字符串为空
        return YES;
    }
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    
    return NO;
}



/**
 * @return  当前时间戳
 */
+(NSString *)getTimeStamp{
//    NSDate* dat = [NSDate date];
//    NSTimeInterval a = [dat timeIntervalSince1970];
//    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
//    return timeString;
        
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0]; // 获取当前时间0秒后的时间
    NSTimeInterval timeStr = [date timeIntervalSince1970]*1000;// *1000 是精确到毫秒(13位),不乘就是精确到秒(10位)
    NSString *timeString = [NSString stringWithFormat:@"%.0f", timeStr];
    return timeString;

}



+(UIImage *)stringToImage:(NSString *)str {
    if(str.length == 0 || !str){
        return nil;
    }
    //strImgDataNew 为base64 NSString
    //进行首尾空字符串的处理
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    //进行空字符串的处理
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    //进行换行字符串的处理
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //去掉头部的前缀//data:image/jpeg;base64, （可根据实际数据情况而定，如果数据有固定的前缀，就执行下面的方法，如果没有就注销掉或删除掉）
    str = [str substringFromIndex:22];   //23 是根据前缀的具体字符长度而定的。
    //进行字符串转data数据 -------NSDataBase64DecodingIgnoreUnknownCharacters
    NSData *decodedImgData = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    //把data数据转换成图片内容
    UIImage*decodedImage = [UIImage imageWithData:decodedImgData];

    return decodedImage;
    
}
// 获取ADFA
+ (NSString *)getIdfa {
    
    NSString *idfa = [[NSUserDefaults standardUserDefaults] objectForKey:FBIDFA];
    if([idfa isEqualToString:@"refuse"]){//拒绝
        return @"";
    }
    if(idfa.length > 0){
        return idfa;
    }
    
    __block NSString *idfaStr = @"";
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            NSLog(@"获取IDFA结果= %lu",(unsigned long)status);
            switch (status) {
                case ATTrackingManagerAuthorizationStatusAuthorized:
//                    NSLog(@"ad用户允许");
                    idfaStr = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
                    NSLog(@"获取IDFA结果= 用户允许");
                    if(idfaStr.length > 0){
                        [[NSUserDefaults standardUserDefaults] setValue:idfaStr forKey:FBIDFA];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:UserTagIDFAPopView object:nil userInfo:nil]];
                    break;
                case ATTrackingManagerAuthorizationStatusDenied:
//                    NSLog(@"ad用户拒绝");
                    NSLog(@"获取IDFA结果= 用户拒绝");
                    [[NSUserDefaults standardUserDefaults] setValue:@"refuse" forKey:FBIDFA];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:UserTagIDFAPopView object:nil userInfo:nil]];
                    break;
                case ATTrackingManagerAuthorizationStatusNotDetermined:
//                    NSLog(@"ad用户没有选择");
                    break;
                default:
                    break;
            }
        }];
    } else {
        // 判断在设置-隐私里用户是否打开了广告跟踪
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
//            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
//            NSLog(@"idfa-----%@",idfa);
        } else {
//            NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
        }
    }

    return idfaStr;
}



@end
