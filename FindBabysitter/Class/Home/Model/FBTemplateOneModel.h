//
//  FBTemplateOneModel.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/5.
//  清洗空调/甲醛治理

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface FBTemplateOneElementModel : NSObject
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *placeholder;
@property(nonatomic,copy)NSString *is_required;
@property(nonatomic,copy)NSString *form_type;
@property(nonatomic,copy)NSString *a_default;
@property(nonatomic,copy)NSArray *options;

@end

@interface FBTemplateOneModel : NSObject
@property(nonatomic,copy)NSString *title;
///轮播图
@property(nonatomic,copy)NSString *banner;
///收费标准
@property(nonatomic,copy)NSString *fee_standards;
///收费标签
@property(nonatomic,copy)NSString *paid_services;
///费用说明
@property(nonatomic,copy)NSString *cost_desc;
///服务详情
@property(nonatomic,copy)NSString *service_details;
///表单标题
@property(nonatomic,copy)NSString *form_title;
///
@property(nonatomic,strong)NSArray *form_elements;
///
@property(nonatomic,assign)NSInteger is_login;
@end

NS_ASSUME_NONNULL_END
