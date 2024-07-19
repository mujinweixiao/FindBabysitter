//
//  FBTemplateModel.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/5.
//

#import <Foundation/Foundation.h>
#import "FBTemplateOneModel.h"
#import "FBTemplateTwoModel.h"
#import "FBTemplateThreeModel.h"
#import "FBTemplateFourModel.h"
#import "FBTemplateFiveModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FBTemplateModel : NSObject
@property(nonatomic,strong)FBTemplateOneModel *template_page_1;
@property(nonatomic,strong)FBTemplateTwoModel *template_page_2;
@property(nonatomic,strong)FBTemplateThreeModel *template_page_3;
@property(nonatomic,strong)FBTemplateFourModel *template_page_4;
@property(nonatomic,strong)FBTemplateFiveModel *template_page_5;

@end

NS_ASSUME_NONNULL_END
