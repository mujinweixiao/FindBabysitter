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
@property(nonatomic,strong)FBNearbyController *nearby;
@property(nonatomic,strong)FBFlashController *flash;
@end

@implementation FBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    //设置所有UITabBarItem的文字属性
    [self setupItemTitleTextAttributes];
    //添加子控制器
    [self setupChildViewControllers];
    
    //首页配置接口请求成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeConfRequestSuccess:) name:NotHomeConfigRequestSuccess object:nil];
}
//首页配置监听
- (void)homeConfRequestSuccess:(NSNotification *)notification{
    if([FBHomeConfManager shareInstance].homeConfModel.menu_button.count == 2){
        FBHomeConfItemModel *first = [[FBHomeConfManager shareInstance].homeConfModel.menu_button firstObject];
        FBHomeConfItemModel *last = [[FBHomeConfManager shareInstance].homeConfModel.menu_button lastObject];

        //闪送
        self.flash.title = first.shortcut_title;
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:first.shortcut_horn_icon] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if(image){
                self.flash.tabBarItem.image = image;
            }
        }];
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:first.shortcut_icon] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if(image){
                self.flash.tabBarItem.selectedImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
        }];
        
        //附近
        self.nearby.title = last.shortcut_title;
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:last.shortcut_horn_icon] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if(image){
                self.nearby.tabBarItem.image = image;
            }
        }];
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:last.shortcut_icon] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if(image){
                self.nearby.tabBarItem.selectedImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
        }];
    }
    
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"Tabbar点击-begin");
    
    if(tabBarController.selectedIndex == 1){
        [FBUMManager event:@"menu_button_1" attributes:@{}];
        NSLog(@"Tabbar点击-附近");
    }else if (tabBarController.selectedIndex == 2){
        [FBUMManager event:@"menu_button_2" attributes:@{}];
        NSLog(@"Tabbar点击-闪送");
    }
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
    self.nearby = nearby;
    [self setupOneChildViewController:nearby title:@"附近" image:@"img_tab_nearby_noselect" selectedImage:@"img_tab_nearby_select"];
//    [self setupOneChildViewController:nearby title:@"附近" image:@"" selectedImage:@""];

    
    FBFlashController *flash = [[FBFlashController alloc]init];
    self.flash = flash;
    [self setupOneChildViewController:flash title:@"闪送" image:@"img_tab_flash_noselect" selectedImage:@"img_tab_flash_select"];
//    [self setupOneChildViewController:flash title:@"闪送" image:@"" selectedImage:@""];

    
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

