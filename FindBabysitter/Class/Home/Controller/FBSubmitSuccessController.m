//
//  FBSubmitSuccessController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/10.
//

#import "FBSubmitSuccessController.h"

@interface FBSubmitSuccessController ()

@end

@implementation FBSubmitSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}
#pragma mark - click
- (void)sureBtnClick
{
    
}
#pragma mark - UI
- (void)setupUI
{
    self.title = @"云上保姆";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImgView = [[UIImageView alloc] init];
    iconImgView.image = [UIImage imageNamed:@"img_sumbit_success"];
    [self.view addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.offset(StatusBarHeight + 44 + 88);
        make.width.offset(180);
        make.height.offset(180);
    }];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.backgroundColor = [UIColor colorWithHex:@"#4971FF"];
    sureBtn.layer.cornerRadius = 22;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHex:@"#FFFFFF"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = BoldFont(13);
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImgView.mas_bottom).offset(50);
        make.left.offset(33);
        make.right.offset(-33);
        make.height.offset(44);
    }];
    
}

@end
