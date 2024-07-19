//
//  FBNavigationController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/1.
//

//
//  ************ 注意 *************
//  不要使用 UINavigationControllerDelegate，代理
//  否则 界面中的UINavigationController+FDFullscreenPopGesture方法失效
//  失效的方法包括，界面的侧滑功能，隐藏导航栏
//
//

#ifndef __IPHONE_15_0
#define __IPHONE_15_0 150000
#endif

#import "FBNavigationController.h"

//UINavigationControllerDelegate 不要用代理，UINavigationController+FDFullscreenPopGesture要不然侧滑以及用到的隐藏导航栏不好用
@interface FBNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation FBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[UINavigationBar appearance] setBarTintColor:RGB(62, 166, 91)];
    

    /** 适配iOS13 present 到顶部  (向文) **/
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
    
    
    NSDictionary *titleTextAttributes = @{NSFontAttributeName:BoldFont(18), NSForegroundColorAttributeName:RGB(51, 51, 51)};
    //控制导航栏的背景颜色和底部线的隐藏
   if (@available(iOS 13.0, *)) {
       UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
       [appearance configureWithOpaqueBackground];//重置导航栏背景颜色和阴影
       appearance.backgroundColor = RGB(255, 255, 255);
       appearance.shadowImage = [UIImage new];
       appearance.shadowColor = nil;
       appearance.titleTextAttributes = titleTextAttributes;
       self.navigationBar.standardAppearance = appearance;
       self.navigationBar.scrollEdgeAppearance = appearance;
   } else {
       // Fallback on earlier versions
       self.navigationBar.barTintColor = [UIColor clearColor];
       [self.navigationBar setTitleTextAttributes:titleTextAttributes];
       [self.navigationBar setShadowImage:[UIImage new]];
       [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

   }
    
    
    
#if (__IPHONE_OS_VERSION_MAX_ALLOWED  >= __IPHONE_15_0)
    if (@available(iOS 15.0, *)) {
        [UITableView appearance].sectionHeaderTopPadding = 0;
    }
#endif
    
    
    
}
+(void)initialize{
    [self setupNavigationBarTheme];
}
+ (void)setupNavigationBarTheme{
    UINavigationBar *appearance = [UINavigationBar appearance];
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = RGB(51, 51, 51);
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    [appearance setTitleTextAttributes:textAttrs];
}




-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    // 左上角的返回键
    // 注意：第一个控制器不需要返回键
    // if不是第一个push进来的子控制器{
    if (self.childViewControllers.count >= 1) {
        // 左上角的返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.mj_size = CGSizeMake(44, 44);
        [backButton setImage:[UIImage imageNamed:@"icon_navbar_btn_back"] forState:UIControlStateNormal];
        // 让按钮内部的所有内容左对齐
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        [backButton sizeToFit];
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0); // 这里微调返回键的位置可以让它看上去和左边紧贴
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        viewController.hidesBottomBarWhenPushed = YES; // 隐藏底部的工具条
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)backAction{
    [self popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
    // UIStatusBarStyleDefault 黑色
    //UIStatusBarStyleLightContent 白色
}

@end

