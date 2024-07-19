//
//  FBUserListController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/1.
//

#import "FBUserListController.h"

@interface FBUserListController ()

@end

@implementation FBUserListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}
#pragma mark - UI
- (void)setupUI
{
    self.title = @"个人信息收集清单";
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
