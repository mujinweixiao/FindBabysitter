//
//  FBTemplateTwoModel.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/5.
//

#import "FBTemplateTwoModel.h"

@implementation FBTemplateTwoModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"form_elements":[FBTemplateOneElementModel class]
    };
}
@end
