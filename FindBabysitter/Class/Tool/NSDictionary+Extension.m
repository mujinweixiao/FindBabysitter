//
//  NSDictionary+Extension.m
//  YXBase
//
//  Created by 闫响 on 2019/12/05.
//  Copyright © 2019 闫响. All rights reserved.
//

#import "NSDictionary+Extension.h"

//#import <AppKit/AppKit.h>


@implementation NSDictionary (Extension)
- (NSString* _Nonnull)string:(NSString* _Nonnull)key
{
    id val = self[key];
    if (val && [val isKindOfClass:[NSString class]]) return (NSString*)val;
    if (val && [val isKindOfClass:[NSNumber class]]) return [val stringValue];
    return @"";
}
- (NSInteger)i:(NSString* _Nonnull)key
{
    id val = self[key];
    if (val) return [val integerValue];
    return 0;
}
- (float)f:(NSString* _Nonnull)key
{
    id val = self[key];
    if (val) return [val floatValue];
    return 0;
}
- (BOOL)b:(NSString* _Nonnull)key
{
    id val = self[key];
    if (val && [val isKindOfClass:[NSString class]]) {
        if ([((NSString*)val) compare:@"true" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            return YES;
        } else if ([((NSString*)val) compare:@"false" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            return NO;
        }
        return NO;
    }
    
    if (val && [val isKindOfClass:[NSNumber class]]){
        return [val boolValue];
    }
    
    return NO;
}
- (NSDictionary* _Nonnull)dictionary:(NSString* _Nonnull)key
{
    id val = self[key];
    if (val && [val isKindOfClass:[NSDictionary class]]) return (NSDictionary*)val;
    return [[NSDictionary alloc] init];
}
- (NSArray* _Nonnull)array:(NSString* _Nonnull)key
{
    id val = self[key];
    if (val && [val isKindOfClass:[NSArray class]]) return (NSArray*)val;
    return [[NSArray alloc] init];
}
@end
