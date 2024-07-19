//
//  FBTemplateOneModel.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/5.
//

#import "FBTemplateOneModel.h"

@implementation FBTemplateOneElementModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"a_default":@"default"
    };
}
@end

@implementation FBTemplateOneModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"form_elements":[FBTemplateOneElementModel class]
    };
}
@end
