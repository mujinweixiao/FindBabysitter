//
//  FBAuntieRecruitmentController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/1.
//

#import "FBAuntieRecruitmentController.h"

@interface FBAuntieRecruitmentController ()
@property(nonatomic,strong)UILabel *oneTitleLab;
@property(nonatomic,strong)UILabel *twoTitleLab;
@property(nonatomic,strong)UITextField *phoneTextField;
@end

@implementation FBAuntieRecruitmentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;
    
    [self setupUI];
    [self dealData];
}

#pragma mark - data
- (void)dealData
{
    self.title = [FBHomeConfManager shareInstance].templateModel.template_page_6.title;
    self.oneTitleLab.text = [FBHomeConfManager shareInstance].templateModel.template_page_6.form_title;
    self.twoTitleLab.text = [FBHomeConfManager shareInstance].templateModel.template_page_6.form_desc;
}
- (void)requestSumitData
{
    NSMutableDictionary *extra_data = [[NSMutableDictionary alloc] init];
    [extra_data setValue:self.phoneTextField.text forKey:@"mobile"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"template_page_6" forKey:@"template_page"];
    [dict setValue:extra_data.mj_JSONString forKey:@"extra_data"];
    
    [[FBHelper getCurrentController] showHudInView:[FBHelper getCurrentController].view hint:@""];
    [FBUMManager event:@"template_page_button_6" attributes:@{}];
    [FBRequestData requestWithUrl:toSubmitForm_Url para:dict Complete:^(NSData * _Nonnull data) {
        [[FBHelper getCurrentController] hideHud];
        NSDictionary *registerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *code = [registerDic string:@"code"];
        if([code isEqualToString:@"0"]){
            [[FBHelper getCurrentController] showHint:@"提交成功"];
            NSDictionary *data = [registerDic dictionary:@"data"];
            NSString *url = [data string:@"url"];
            if(url.length > 0){
                FBWebViewController *vc = [[FBWebViewController alloc] init];
                vc.urlStr = url;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                FBSubmitSuccessController *vc = [[FBSubmitSuccessController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            NSString *msg = [registerDic string:@"msg"];
            [[FBHelper getCurrentController] showHint:msg];
        }
        NSLog(@"");
        
    } fail:^(NSError * _Nonnull error) {
        [[FBHelper getCurrentController] hideHud];
        [[FBHelper getCurrentController] showHint:@"请求失败"];
    }];
}
#pragma mark - click
- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sureBtnClick
{
    if([FBHomeConfManager shareInstance].templateModel.template_page_6.is_login == 1){//需要登录
        if([FBUserInfoModel shareInstance].token.length > 0){
            [self requestSumitData];
        }else{
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate oneLittleItemBtnClick];
        }
    }else{
        FBWebViewController *webvc = [[FBWebViewController alloc] init];
        webvc.navTitle = @"";
        webvc.urlStr = [FBHomeConfManager shareInstance].templateModel.template_page_1.url;
        [self.navigationController pushViewController:webvc animated:YES];
    }
}
#pragma mark - UI
- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.bottom.offset(0);
        make.right.offset(0);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    [scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.top.offset(0);
        make.bottom.offset(0);
        make.width.offset(KScreenW);
    }];
    
    UIImageView *topImgView = [[UIImageView alloc] init];
    topImgView.image = [UIImage imageNamed:@"img_ayizhaomu_background"];
    [contentView addSubview:topImgView];
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.equalTo(topImgView.mas_width).multipliedBy(495.0/375.0);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"阿姨招募";
    titleLab.textColor = [UIColor colorWithHex:@"#000000"];
    titleLab.font = BoldFont(16);
    [contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.offset(StatusBarHeight + 10);
    }];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"icon_navbar_btn_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLab);
        make.left.offset(5);
        make.width.offset(50);
        make.height.offset(50);
    }];
    
    UIView *bottomView = [self setupContentView];
    [contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView.mas_bottom).offset(-40);
        make.left.offset(16);
        make.right.offset(-16);
        
        make.bottom.offset(-20);
    }];
}
- (UIView *)setupContentView
{
    UIView *rootView = [[UIView alloc] init];
    rootView.backgroundColor = [UIColor colorWithHex:@"#FFFFFF"];
    rootView.layer.cornerRadius = 10;
    rootView.layer.masksToBounds = YES;
    rootView.layer.borderWidth = 2;
    rootView.layer.borderColor = [UIColor colorWithHex:@"#4971FF"].CGColor;
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"培训后可获得专业技能认可";
    titleLab.textColor = [UIColor colorWithHex:@"#4971FF"];
    titleLab.font = BoldFont(26);
    [rootView addSubview:titleLab];
    self.oneTitleLab = titleLab;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(25);
        make.left.offset(16);
    }];
    
    UILabel *subtitleLab = [[UILabel alloc] init];
    subtitleLab.text = @"更多家政培训课程，可填写信息咨询";
    subtitleLab.textColor = [UIColor colorWithHex:@"#666A77"];
    subtitleLab.font = MediumFont(16);
    [rootView addSubview:subtitleLab];
    self.twoTitleLab = subtitleLab;
    [subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(5);
        make.left.offset(16);
    }];
    
//    UIView *phoneView = [[UIView alloc] init];
//    phoneView.layer.cornerRadius = 10;
//    phoneView.layer.masksToBounds = YES;
//    [rootView addSubview:phoneView];
//    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(subtitleLab.mas_bottom).offset(10);
//        make.left.offset(17);
//        make.right.offset(-17);
//        make.height.offset(50);
//    }];
    
    UITextField *phoneTextField = [[UITextField alloc] init];
    phoneTextField.layer.cornerRadius = 10;
    phoneTextField.layer.masksToBounds = YES;
    phoneTextField.placeholder = @"请输入手机号";
    phoneTextField.backgroundColor = [UIColor colorWithHex:@"#F3F7FB"];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 10)];
    phoneTextField.leftView = leftView;
    phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    phoneTextField.font = MediumFont(12);
    [rootView addSubview:phoneTextField];
    self.phoneTextField = phoneTextField;
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subtitleLab.mas_bottom).offset(15);
        make.left.offset(17);
        make.right.offset(-17);
        make.height.offset(50);
    }];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.layer.cornerRadius = 22;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:@"提交" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHex:@"#FFFFFF"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = MediumFont(14);
    sureBtn.backgroundColor = [UIColor colorWithHex:@"#4971FF"];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneTextField.mas_bottom).offset(20);
        make.left.offset(17);
        make.right.offset(-17);
        make.height.offset(44);
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.text = @"提交视为您同意与您联系培训事宜";
    tipLab.textColor = [UIColor colorWithHex:@"#16171A"];
    tipLab.font = MediumFont(16);
    [rootView addSubview:tipLab];
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureBtn.mas_bottom).offset(10);
        make.left.offset(15);
        
        make.bottom.offset(-25);
    }];
    
    return rootView;
}
@end
