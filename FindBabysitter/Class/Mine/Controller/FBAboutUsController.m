//
//  FBAboutUsController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/1.
//

#import "FBAboutUsController.h"

@interface FBAboutUsController ()
@property(nonatomic,strong)UIImageView *iconImgView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *versionLab;
@property(nonatomic,strong)UILabel *emailLab;

@property(nonatomic,copy)NSString *privacy_agreement;
@property(nonatomic,copy)NSString *service_agreement;
@end

@implementation FBAboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self requestData];
}
#pragma mark - data
- (void)requestData
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [self showHudInView:[FBHelper getCurrentController].view hint:@""];
    [FBRequestData requestWithUrl:aboutUs_Url para:dict Complete:^(NSData * _Nonnull data) {
        [self hideHud];
        NSDictionary *registerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *code = [registerDic string:@"code"];
        if([code isEqualToString:@"0"]){
            NSDictionary *data = [registerDic dictionary:@"data"];
            NSString *title = [data string:@"title"];
            NSString *image = [data string:@"image"];
            NSString *contact_information = [data string:@"contact_information"];
            NSString *privacy_agreement = [data string:@"privacy_agreement"];
            NSString *service_agreement = [data string:@"service_agreement"];


            [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:image]];
            self.titleLab.text = title;
            self.versionLab.text = [NSString stringWithFormat:@"Version %@",[FBHelper getAppVersion]];
            self.emailLab.text = contact_information;
            self.privacy_agreement = privacy_agreement;
            self.service_agreement = service_agreement;
        }else{
            NSString *msg = [registerDic string:@"msg"];
            [self showHint:msg];
        }
        NSLog(@"");
        
    } fail:^(NSError * _Nonnull error) {
        [self hideHud];
        [self showHint:@"请求失败"];
    }];
}
- (void)requestDeleteUserData
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [self showHudInView:[FBHelper getCurrentController].view hint:@""];
    [FBRequestData requestWithUrl:accountCancellation_Url para:dict Complete:^(NSData * _Nonnull data) {
        [self hideHud];
        NSDictionary *registerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *code = [registerDic string:@"code"];
        if([code isEqualToString:@"0"]){
            [self showHint:@"注销成功"];
            [kUserInfoModel nullUserInfoData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            NSString *msg = [registerDic string:@"msg"];
            [self showHint:msg];
        }
        NSLog(@"");
        
    } fail:^(NSError * _Nonnull error) {
        [self hideHud];
        [self showHint:@"请求失败"];
    }];
}
#pragma mark - click
- (void)cancelAccountBtnClick
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号注销后将删除有关您账号的一切信息，确认操作？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestDeleteUserData];
    }];
    [alertC addAction:cancelAction];
    [alertC addAction:sureAction];
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
}
- (void)agreementBtnClick
{
    FBWebViewController *vc = [[FBWebViewController alloc] init];
    vc.urlStr = self.service_agreement;
    vc.navTitle = @"用户协议";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)privacyBtnClick
{
    FBWebViewController *vc = [[FBWebViewController alloc] init];
    vc.urlStr = self.privacy_agreement;
    vc.navTitle = @"隐私协议";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UI
- (void)setupUI
{
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImgView = [[UIImageView alloc] init];
    iconImgView.image = [UIImage imageNamed:@"img_aboutus_icon"];
    [self.view addSubview:iconImgView];
    self.iconImgView = iconImgView;
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.offset(StatusBarHeight + 44 + 80);
        make.width.offset(140);
        make.height.offset(140);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"云上保姆";
    titleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    titleLab.font = BoldFont(24);
    titleLab.numberOfLines = 0;
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    self.titleLab = titleLab;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(iconImgView.mas_bottom).offset(5);
    }];
    
    UILabel *versionLab = [[UILabel alloc] init];
    versionLab.text = @"Version 1.0.0";
    versionLab.textColor = [UIColor colorWithHex:@"#16171A"];
    versionLab.font = BoldFont(16);
    versionLab.numberOfLines = 0;
    versionLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLab];
    self.versionLab = versionLab;
    [versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(titleLab.mas_bottom).offset(0);
    }];
    
    UILabel *emailLab = [[UILabel alloc] init];
    emailLab.text = @"";
    emailLab.textColor = [UIColor colorWithHex:@"#666A77"];
    emailLab.font = MediumFont(14);
    emailLab.numberOfLines = 0;
    [self.view addSubview:emailLab];
    self.emailLab = emailLab;
    [emailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(versionLab.mas_bottom).offset(15);
    }];
    
    UIButton *cancelAccountBtn = [[UIButton alloc] init];
    [cancelAccountBtn setTitle:@"注销账号" forState:UIControlStateNormal];
    [cancelAccountBtn setTitleColor:[UIColor colorWithHex:@"#9DA2B3"] forState:UIControlStateNormal];
    cancelAccountBtn.titleLabel.font = MediumFont(14);
    [cancelAccountBtn addTarget:self action:@selector(cancelAccountBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelAccountBtn];
    [cancelAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.offset(- SafeAreaBottomHeight - 70);
        make.width.offset(100);
        make.height.offset(40);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#4971FF"];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(cancelAccountBtn.mas_bottom).offset(5);
        make.width.offset(0.5);
        make.height.offset(20);
    }];
    
    UIButton *agreementBtn = [[UIButton alloc] init];
    [agreementBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [agreementBtn setTitleColor:[UIColor colorWithHex:@"#4971FF"] forState:UIControlStateNormal];
    agreementBtn.titleLabel.font = BoldFont(14);
    [agreementBtn addTarget:self action:@selector(agreementBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreementBtn];
    [agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView);
        make.right.equalTo(lineView.mas_left);
        make.width.offset(100);
        make.height.offset(40);
    }];
    
    UIButton *privacyBtn = [[UIButton alloc] init];
    [privacyBtn setTitle:@"《隐私政策》" forState:UIControlStateNormal];
    [privacyBtn setTitleColor:[UIColor colorWithHex:@"#4971FF"] forState:UIControlStateNormal];
    privacyBtn.titleLabel.font = BoldFont(14);
    [privacyBtn addTarget:self action:@selector(privacyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:privacyBtn];
    [privacyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView);
        make.left.equalTo(lineView.mas_right);
        make.width.equalTo(agreementBtn);
        make.height.equalTo(agreementBtn);
    }];
}
@end
