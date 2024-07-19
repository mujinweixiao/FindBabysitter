//
//  FBHomeConfManager.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/8.
//

#import <Foundation/Foundation.h>
#import "FBHomeConfModel.h"//首页配置
#import "FBTemplateModel.h"//模版

NS_ASSUME_NONNULL_BEGIN

@interface FBHomeConfManager : NSObject
+ (instancetype)shareInstance;

@property(nonatomic,strong)FBHomeConfModel *homeConfModel;
@property(nonatomic,strong)FBTemplateModel *templateModel;
@end

NS_ASSUME_NONNULL_END
