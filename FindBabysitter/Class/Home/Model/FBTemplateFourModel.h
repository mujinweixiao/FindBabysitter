//
//  FBTemplateFourModel.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/5.
//  做饭阿姨

#import <Foundation/Foundation.h>
#import "FBTemplateOneModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FBTemplateFourModel : NSObject
///
@property(nonatomic,copy)NSString *title;
///
@property(nonatomic,copy)NSString *banner;
///
@property(nonatomic,copy)NSString *form_title;
///表单元素
@property(nonatomic,strong)NSArray *form_elements;
///
@property(nonatomic,assign)NSInteger is_login;
@end

NS_ASSUME_NONNULL_END
