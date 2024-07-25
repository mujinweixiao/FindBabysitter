//
//  FBTemplateFiveModel.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/8.
//  榴莲闪送

#import <Foundation/Foundation.h>
#import "FBTemplateOneModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBTemplateFiveImgModel : NSObject
///
@property(nonatomic,copy)NSString *img_url;
@end

@interface FBTemplateFiveTypeModel : NSObject
///标题
@property(nonatomic,copy)NSString *title;
///
@property(nonatomic,copy)NSString *desc;
///1:默认选中 2：未选择
@property(nonatomic,assign)int is_default;
///选中状态
//@property(nonatomic,assign)BOOL isSelect;
@end

@interface FBTemplateFiveModel : NSObject
///标题
@property(nonatomic,copy)NSString *title;
///支持地区
@property(nonatomic,copy)NSString *supporting_regions;
///描述
@property(nonatomic,copy)NSString *desc;
///服务说明
@property(nonatomic,copy)NSString *service_content;
///
@property(nonatomic,strong)NSArray *variety_types;
///
@property(nonatomic,strong)NSArray *qualification_desc;
///表单元素
@property(nonatomic,strong)NSArray *form_elements;
///
@property(nonatomic,assign)NSInteger is_login;
///
@property(nonatomic,copy)NSString *url;
@end

NS_ASSUME_NONNULL_END
