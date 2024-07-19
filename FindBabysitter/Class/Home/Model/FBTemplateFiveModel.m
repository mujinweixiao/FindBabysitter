//
//  FBTemplateFiveModel.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/8.
//

#import "FBTemplateFiveModel.h"
@implementation FBTemplateFiveImgModel

@end


@implementation FBTemplateFiveTypeModel

@end

@implementation FBTemplateFiveModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"variety_types":[FBTemplateFiveTypeModel class],
        @"qualification_desc":[FBTemplateFiveImgModel class],
        @"form_elements":[FBTemplateOneElementModel class],
    };
}
@end
