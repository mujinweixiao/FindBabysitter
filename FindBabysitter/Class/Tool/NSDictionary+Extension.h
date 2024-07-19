//
//  NSDictionary+Extension.h
//  YXBase
//
//  Created by 闫响 on 2019/12/05.
//  Copyright © 2019 闫响. All rights reserved.
//

//#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Extension)
- (NSString* _Nonnull) string:(NSString* _Nonnull)key;
- (NSInteger) i:(NSString* _Nonnull)key;
- (float) f:(NSString* _Nonnull)key;
- (BOOL) b:(NSString* _Nonnull)key;
- (NSDictionary* _Nonnull) dictionary:(NSString* _Nonnull)key;
- (NSArray* _Nonnull) array:(NSString* _Nonnull)key;

@end

NS_ASSUME_NONNULL_END
