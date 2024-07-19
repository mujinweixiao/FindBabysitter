//
//  FBUMManager.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/19.
//

#import "FBUMManager.h"

@implementation FBUMManager
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;
{
    [MobClick event:eventId attributes:attributes];
}
@end
