//
//  GBRequestData.h
//  
//
//  FBRequestData.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/1.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBRequestData : NSObject
+ (void)requestWithUrl:(NSString *)urlString para:(NSDictionary *)dict Complete:(void (^)(NSData *data))success fail:(void (^)(NSError *error))failture;
@end

NS_ASSUME_NONNULL_END
