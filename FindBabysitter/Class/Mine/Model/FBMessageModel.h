//
//  FBMessageModel.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBMessageModel : NSObject
///
@property (nonatomic, copy) NSString *ID;
///
@property (nonatomic, copy) NSString *member_id;
///通知标题
@property (nonatomic, copy) NSString *notice_title;
///通知内容
@property (nonatomic, copy) NSString *notice_content;
///创建时间
@property (nonatomic, copy) NSString *create_time;
///读取状态，1已读，2未读
@property (nonatomic, copy) NSString *notice_status;
///
@property (nonatomic, copy) NSString *update_time;

@end

NS_ASSUME_NONNULL_END
