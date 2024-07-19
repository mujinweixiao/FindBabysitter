//
//  FBHomeConfManager.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/8.
//

#import "FBHomeConfManager.h"

@implementation FBHomeConfManager
+ (instancetype)shareInstance{
    
    static FBHomeConfManager *instance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[FBHomeConfManager alloc] init] ;
    }) ;
    return instance ;
}

@end
