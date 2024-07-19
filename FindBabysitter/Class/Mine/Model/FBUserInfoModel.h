//
//  FBUserInfoModel.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBUserInfoModel : NSObject

+ (instancetype)shareInstance;
+ (id)allocWithZone:(struct _NSZone *)zone;
- (id)copyWithZone:(struct _NSZone *)zone;

 /** 加载数据  (搬砖小弟) **/
- (void)loadUserInfoData;
 /** 清空数据  (搬砖小弟) **/
- (void)nullUserInfoData;

/** member_id  (搬砖小弟) **/
@property (nonatomic, copy) NSString *member_id;
/** token  (搬砖小弟) **/
@property (nonatomic, copy) NSString *token;
/** 昵称  (搬砖小弟) **/
@property (nonatomic, copy) NSString *nickname;
/** 头像  (搬砖小弟) **/
@property (nonatomic, copy) NSString *head_img;
/** 手机号  (搬砖小弟) **/
@property (nonatomic, copy) NSString *mobile;
/** 设备Token  (搬砖小弟) **/
@property (nonatomic, copy) NSString *deviceToken;
@end

NS_ASSUME_NONNULL_END
