//
//  FBHomeAdPopView.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/8/15.
//  首页弹窗广告图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FBHomeAdPopViewDelegate <NSObject>
- (void)homeAdPopViewSureClick;
@end

@interface FBHomeAdPopView : UIView
@property(nonatomic,weak)id<FBHomeAdPopViewDelegate>delegate;
@property(nonatomic,strong)UIImageView *backgroundImgView;
@end

NS_ASSUME_NONNULL_END
