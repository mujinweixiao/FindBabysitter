//
//  FBLoginPopController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/8.
//

#import "FBLoginPopController.h"
#import "FBLoginPopView.h"
@interface FBLoginPopController ()

@end

@implementation FBLoginPopController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;
    [self setupUI];
}
#pragma mark - UI
- (void)setupUI
{
    self.view.backgroundColor = [UIColor clearColor];
    
    FBLoginPopView *rootView = [[FBLoginPopView alloc] init];
    [self.view addSubview:rootView];
    [rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

@end
