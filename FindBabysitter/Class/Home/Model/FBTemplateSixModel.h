//
//  FBTemplateSixModel.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/24.
//

#import <Foundation/Foundation.h>
#import "FBTemplateOneModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBTemplateSixModel : NSObject
///标题
@property(nonatomic,copy)NSString *title;
///标题
@property(nonatomic,copy)NSString *form_title;
///标题
@property(nonatomic,copy)NSString *form_desc;
///表单元素
@property(nonatomic,strong)NSArray *form_elements;
///
@property(nonatomic,assign)NSInteger is_login;
///
@property(nonatomic,copy)NSString *url;
@end

NS_ASSUME_NONNULL_END
