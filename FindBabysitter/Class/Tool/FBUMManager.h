//
//  FBUMManager.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBUMManager : NSObject
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;
@end

NS_ASSUME_NONNULL_END
