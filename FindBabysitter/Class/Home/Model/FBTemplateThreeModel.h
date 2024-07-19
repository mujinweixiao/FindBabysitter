//
//  FBTemplateThreeModel.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/5.
//  云上保姆

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBTemplateThreeModel : NSObject
///
@property(nonatomic,copy)NSString *title;
///轮播图
@property(nonatomic,copy)NSString *banner;
///服务内容
@property(nonatomic,copy)NSString *service_content;
///服务时长
@property(nonatomic,copy)NSString *service_duration;
///常见问题
@property(nonatomic,copy)NSString *common_problem;
///备注
@property(nonatomic,copy)NSString *remarks;
///
@property(nonatomic,assign)NSInteger is_login;
///
@property(nonatomic,copy)NSString *url;
@end

NS_ASSUME_NONNULL_END
