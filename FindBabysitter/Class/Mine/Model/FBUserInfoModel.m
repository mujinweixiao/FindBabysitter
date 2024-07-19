//
//  FBUserInfoModel.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/3.
//

#import "FBUserInfoModel.h"

static NSString *const FBUserInfoModel_token               = @"token";
static NSString *const FBUserInfoModel_nickname            = @"nickname";
static NSString *const FBUserInfoModel_head_img            = @"head_img";
static NSString *const FBUserInfoModel_mobile            = @"mobile";
static NSString *const FBUserInfoModel_deviceToken         = @"deviceToken";




@implementation FBUserInfoModel


+ (instancetype)shareInstance{
    
    static FBUserInfoModel *instance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init] ;
    }) ;
    return instance ;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [FBUserInfoModel shareInstance] ;
}

- (id)copyWithZone:(struct _NSZone *)zone{
    return [FBUserInfoModel shareInstance] ;
}

#pragma mark -- 给属性赋值
- (void)loadUserInfoData{
    
    
    kUserInfoModel.token = kUserDefault_read(FBUserInfoModel_token);
    kUserInfoModel.nickname = kUserDefault_read(FBUserInfoModel_nickname);
    kUserInfoModel.head_img = kUserDefault_read(FBUserInfoModel_head_img);
    kUserInfoModel.mobile = kUserDefault_read(FBUserInfoModel_mobile);
    kUserInfoModel.deviceToken = kUserDefault_read(FBUserInfoModel_deviceToken);

    
    [kUserDefaults synchronize];
    
}

#pragma mark -- 将属性置空
- (void)nullUserInfoData{
    
    kUserInfoModel.token              = @"";
    kUserInfoModel.nickname           = @"";
    kUserInfoModel.head_img           = @"";
    kUserInfoModel.mobile           = @"";
    kUserInfoModel.deviceToken           = @"";

}

#pragma mark -- setter方法保存到 [NSUserDefaults standardUserDefaults]
- (void)setToken:(NSString *)token{
    _token = token;
    kUserDefault_write(kStr(kUserInfoModel.token),FBUserInfoModel_token);
}
- (void)setNickname:(NSString *)nickname{
    _nickname = nickname;
    kUserDefault_write(kStr(kUserInfoModel.nickname),FBUserInfoModel_nickname);
}

- (void)setHead_img:(NSString *)head_img{
    _head_img = head_img;
    kUserDefault_write(kStr(kUserInfoModel.head_img),FBUserInfoModel_head_img);
}
- (void)setMobile:(NSString *)mobile
{
    _mobile = mobile;
    kUserDefault_write(kStr(kUserInfoModel.mobile),FBUserInfoModel_mobile);
}
- (void)setDeviceToken:(NSString *)deviceToken
{
    _deviceToken = deviceToken;
    kUserDefault_write(kStr(kUserInfoModel.deviceToken),FBUserInfoModel_deviceToken);
}
@end
