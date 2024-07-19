/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "UIViewController+HUD.h"

#import "MBProgressHUD.h"
#import <objc/runtime.h>
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "UIImage+GIF.h"
static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelText = hint;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}
- (void)showHudInMapView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelText = hint;
    HUD.yOffset = -240;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}


- (void)showHint:(NSString *)hint
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
//    hud.labelText = hint;
    hud.detailsLabelText = hint;
    hud.detailsLabelFont = RegularFont(16);
    hud.margin = 10.f;
    hud.yOffset = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = 180;
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)hideHud{
    [[self HUD] hide:YES];
    [[self HUD] removeFromSuperview];
    [self HUD].customView = nil;
}



- (void)showInView:(UIView *)view hint:(NSString *)hint showTime:(float)showTime completionBlock:(void (^)(void))completionBlock{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelText = hint;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
    
    HUD.minShowTime = showTime;
    [HUD hide:YES afterDelay:showTime];
    HUD.completionBlock = ^{
        !completionBlock ?: completionBlock();
    };
    
}
/** 显示加载动画的方法  (向文) **/
- (void)showGifToView:(NSString *)hint{
//    UIView *view = [[UIApplication sharedApplication].delegate window];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    UIImage *image = [UIImage sd_animatedGIFNamed:@"loading4"];
//    UIImageView *cusImageV = [[UIImageView alloc] initWithImage:image];
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.removeFromSuperViewOnHide = YES;
//    hud.color = [UIColor clearColor];
//    hud.customView = cusImageV;
//    [hud show:YES];
//    [self setHUD:hud];
}



@end
