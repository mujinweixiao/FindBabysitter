//
//  FBTabBarController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/1.
//

#import "FBTabBarController.h"
#import "FBNavigationController.h"
#import "FBHomeController.h"
#import "FBNearbyController.h"
#import "FBFlashController.h"
#import "FBMineController.h"
@interface FBTabBarController ()<UITabBarControllerDelegate,UITabBarDelegate>

@end

@implementation FBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    //设置所有UITabBarItem的文字属性
    [self setupItemTitleTextAttributes];
    //添加子控制器
    [self setupChildViewControllers];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
     return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupItemTitleTextAttributes{
    
    /** 适配iOS13  (向文) **/
    if(@available(iOS 13.0, *)) {

        [[UITabBar appearance] setTintColor:[UIColor colorWithHex:@"#16171A"]];
        [[UITabBar appearance] setUnselectedItemTintColor: [UIColor colorWithHex:@"#B9BDCF"]];

    }else{
        UITabBarItem *item = [UITabBarItem appearance];
        NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
        normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
        
        normalAttrs[NSForegroundColorAttributeName] =  [UIColor colorWithHex:@"#B9BDCF"];
        [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
        
        NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
        selectedAttrs[NSForegroundColorAttributeName] =  [UIColor colorWithHex:@"#16171A"];
        [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    }


}

- (void)setupChildViewControllers{
    
    FBHomeController *home = [[FBHomeController alloc]init];
    [self setupOneChildViewController:home title:@"首页" image:@"img_tab_home_noselect" selectedImage:@"img_tab_home_select"];
    
    FBNearbyController *nearby = [[FBNearbyController alloc]init];
    [self setupOneChildViewController:nearby title:@"附近" image:@"img_tab_nearby_noselect" selectedImage:@"img_tab_nearby_select"];
    
    FBFlashController *flash = [[FBFlashController alloc]init];
    [self setupOneChildViewController:flash title:@"闪送" image:@"img_tab_flash_noselect" selectedImage:@"img_tab_flash_select"];
    
    FBMineController *mine = [[FBMineController alloc]init];
    [self setupOneChildViewController:mine title:@"我的" image:@"img_tab_mine_noselect" selectedImage:@"img_tab_mine_select"];
}

- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    
    vc.title = title;
    UIImage *imageSele =[UIImage imageNamed:selectedImage];
    if (image.length) {
        vc.tabBarItem.image = [UIImage imageNamed:image];
        vc.tabBarItem.selectedImage = [imageSele imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    FBNavigationController *nav = [[FBNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}


-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}




@end

