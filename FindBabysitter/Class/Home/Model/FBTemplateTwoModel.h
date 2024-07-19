//
//  FBTemplateTwoModel.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/5.
//  附近

#import <Foundation/Foundation.h>
#import "FBTemplateOneModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FBTemplateTwoModel : NSObject
///
@property(nonatomic,copy)NSString *title;
///轮播图
@property(nonatomic,copy)NSString *banner;
///支持地区
@property(nonatomic,copy)NSString *supporting_regions;
///描述
@property(nonatomic,copy)NSString *desc;
///表单元素
@property(nonatomic,strong)NSArray *form_elements;
///
@property(nonatomic,assign)NSInteger is_login;
///
@property(nonatomic,copy)NSString *url;
@end

NS_ASSUME_NONNULL_END
