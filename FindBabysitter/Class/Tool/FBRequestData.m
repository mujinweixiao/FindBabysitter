//
//  FBRequestData.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/1.
//

#import "FBRequestData.h"
#import "AFNetworking.h"
static AFHTTPSessionManager *manager;

@implementation FBRequestData


+ (void)requestWithUrl:(NSString *)urlString para:(NSDictionary *)dict Complete:(void (^)(NSData *data))success fail:(void (^)(NSError *error))failture{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = 30.0;
        manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    });
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    NSString *Authorization = [NSString stringWithFormat:@"Bearer %@",kUserInfoModel.token];

    NSDictionary *headerFieldValueDictionary = @{
//        @"os-system":device,// 设备系统类型
//        @"version":[AppHelper getAppVersion],// app版本
//        @"os-model":[AppHelper iphoneType],// 设备类型
//        @"clientIP":ipAddressStr,// ip地址
        @"Authorization":Authorization,// 用户token
        @"uuid":[FBHelper iOSUUID],// 用户token
        @"os-version":[FBHelper getAppVersion],// 用户token
        @"os-system":[NSString stringWithFormat:@"iOS %@",[FBHelper iOSVersion]],// 用户token
        @"os-model":[FBHelper iphoneType],// 用户token
//        @"packageID":[AppHelper getAppBundleId],// 包名
//        @"from-type":@"3",// iOS访问
//        @"iOSVersion":[AppHelper iOSVersion],// 操作系统版本号
        @"idfa":NonNULLString([FBHelper getIdfa])// 广告标识
    };
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }

    //验证证书
    manager.requestSerializer = requestSerializer;
        
    [manager POST:urlString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *registerDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if(registerDic == nil || [registerDic count] == 0) {
            // 字典为空
            NSError * _Nonnull error;
            failture(error);
            return;
        }
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failture(error);
    }];

}

@end
