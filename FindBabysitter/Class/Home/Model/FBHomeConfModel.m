//
//  FBHomeConfModel.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/8.
//

#import "FBHomeConfModel.h"

@implementation FBHomeConfItemModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"ID":@"id",
    };
}
@end

@implementation FBHomeConfModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"top_button":[FBHomeConfItemModel class],
        @"middle_button":[FBHomeConfItemModel class],
        @"bottom_button":[FBHomeConfItemModel class],
        @"banners":[FBHomeConfItemModel class],
        @"menu_button":[FBHomeConfItemModel class],

    };
}
@end
