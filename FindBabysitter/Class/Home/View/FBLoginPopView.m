//
//  FBLoginPopView.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/3.
//

#import "FBLoginPopView.h"
#import "YYText.h"
@interface FBLoginPopView()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *phoneTextField;
@property(nonatomic,strong)UITextField *codeTextField;
@property(nonatomic,strong) UIButton *agreementBtn;
@property(nonatomic,strong) UIButton *sureBtn;

/** 倒计时 **/
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimeInterval dqtime;
@property(nonatomic,strong)UIButton *buttonSendCode;
@end

@implementation FBLoginPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame]){
        [self setupUI];
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
        self.displayLink.paused = YES;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}
#pragma mark - priv
/** 倒计时方法 **/
- (void)displayLinkAction{
    
    self.dqtime--;
    int currentSeconds = self.dqtime/60.0;
    if (currentSeconds == 0) {
        self.displayLink.paused = YES;
//        self.rootView.buttonSendCode.alpha = 1;
        [self.buttonSendCode setUserInteractionEnabled:YES];
        [self.buttonSendCode setTitle:@"重新获取" forState:UIControlStateNormal];
//        self.rootView.buttonSendCode.backgroundColor = RGB(51, 51, 51);

        
    }else{
        [self.buttonSendCode setTitle:[NSString stringWithFormat:@"%ds",currentSeconds] forState:UIControlStateNormal];
//        self.rootView.buttonSendCode.backgroundColor = RGB(85, 187, 119);
//
    }
    
}
- (void)loginBtnStateChange
{
    if((self.phoneTextField.text.length > 0) && (self.codeTextField.text.length > 0) && self.agreementBtn.selected){
        [self.sureBtn setTitleColor:[UIColor colorWithHex:@"#FFFFFF"] forState:UIControlStateNormal];
        self.sureBtn.backgroundColor = [UIColor colorWithHex:@"#4971FF"];
    }else{
        [self.sureBtn setTitleColor:[UIColor colorWithHex:@"#B9BDCF"] forState:UIControlStateNormal];
        self.sureBtn.backgroundColor = [UIColor colorWithHex:@"#F3F7FB"];
    }
}
#pragma mark - TextField
- (void)textFieldDidChangeSelection:(UITextField *)textField
{
    [self loginBtnStateChange];
}
#pragma mark - click
- (void)closeBtnClick
{
    [[FBHelper getCurrentController] dismissViewControllerAnimated:YES completion:nil];
}
- (void)sureBtnClick
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.phoneTextField.text forKey:@"mobile"];
    [dict setValue:self.codeTextField.text forKey:@"code"];
    [dict setValue:kUserInfoModel.deviceToken forKey:@"device_tokens"];

    [[FBHelper getCurrentController] showHudInView:[FBHelper getCurrentController].view hint:@""];
    [FBRequestData requestWithUrl:quickLogin_Url para:dict Complete:^(NSData * _Nonnull data) {
        [[FBHelper getCurrentController] hideHud];
        NSDictionary *registerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *code = [registerDic string:@"code"];
        if([code isEqualToString:@"0"]){
            NSDictionary *data = [registerDic dictionary:@"data"];
            NSDictionary *token = [data dictionary:@"token"];
            NSString *token_type = [token string:@"token_type"];
            NSString *expires_in = [token string:@"expires_in"];
            NSString *access_token = [token string:@"access_token"];
            NSString *refresh_token = [token string:@"refresh_token"];
            NSString *mobile = [data string:@"mobile"];

            
            //本地token赋值
            [kUserInfoModel nullUserInfoData];
            kUserInfoModel.token = access_token;
            kUserInfoModel.mobile = mobile;
            [[FBHelper getCurrentController] dismissViewControllerAnimated:YES completion:nil];
            
            //dismiss
            [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
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
- (void)getCodeBtnClick
{
    if(self.phoneTextField.text.length == 0){
        [[FBHelper getCurrentController] showHint:@"请输入手机号"];
        return;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.phoneTextField.text forKey:@"mobile"];
    [dict setValue:@"1" forKey:@"scene"];
    
    [[FBHelper getCurrentController] showHudInView:[FBHelper getCurrentController].view hint:@""];
    [FBRequestData requestWithUrl:sendSms_Url para:dict Complete:^(NSData * _Nonnull data) {
        [[FBHelper getCurrentController] hideHud];
        NSDictionary *registerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *code = [registerDic string:@"code"];
        if ([code isEqualToString:@"0"]) {
            [self.buttonSendCode setUserInteractionEnabled:NO];
            self.dqtime = 61*60;
            self.displayLink.paused = NO;
        }else{
            NSString *msg = [registerDic string:@"msg"];
            [[FBHelper getCurrentController] showHint:msg];
        }
        NSLog(@"");
        
    } fail:^(NSError * _Nonnull error) {
        self.displayLink.paused = YES;
        [self.buttonSendCode setUserInteractionEnabled:YES];
        [self.buttonSendCode setTitle:@"重新获取" forState:UIControlStateNormal];
        [[FBHelper getCurrentController] hideHud];
        [[FBHelper getCurrentController] showHint:@"请求失败"];
    }];
}
- (void)agreementBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self loginBtnStateChange];
}
#pragma mark - UI
- (void)setupUI
{
    self.backgroundColor = [UIColor colorWithHex:@"#16171A" alpha:0.6];
    
    UIView *rootView = [[UIView alloc] init];
    rootView.layer.cornerRadius = 10;
    rootView.layer.masksToBounds = YES;
    rootView.backgroundColor = [UIColor whiteColor];
    [self addSubview:rootView];
    [rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.bottom.offset(10);
        make.right.offset(0);
        make.height.offset(412+10);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"登录享受更多服务";
    titleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    titleLab.font = BoldFont(16);
    [rootView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.left.offset(30);
    }];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage imageNamed:@"img_pop_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLab);
        make.right.offset(-10);
        make.width.offset(50);
        make.height.offset(50);
    }];
    
    UIView *phoneView = [self setupPhoneView];
    [rootView addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(20);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(60);
    }];
    
    UIView *codeView = [self setupVercodeView];
    [rootView addSubview:codeView];
    [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.mas_bottom).offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(60);
    }];
    
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.layer.cornerRadius = 27;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHex:@"#B9BDCF"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = MediumFont(20);
    sureBtn.backgroundColor = [UIColor colorWithHex:@"#F3F7FB"];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:sureBtn];
    self.sureBtn = sureBtn;
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(codeView.mas_bottom).offset(29);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.offset(54);
    }];
    
    UIButton *agreementBtn = [[UIButton alloc] init];
    [agreementBtn setImage:[UIImage imageNamed:@"img_circle_noselect"] forState:UIControlStateNormal];
    [agreementBtn setImage:[UIImage imageNamed:@"img_agreement_select"] forState:UIControlStateSelected];
    [agreementBtn addTarget:self action:@selector(agreementBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:agreementBtn];
    self.agreementBtn = agreementBtn;
    [agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sureBtn.mas_bottom).offset(15);
        make.left.offset(40);
        make.width.offset(40);
        make.height.offset(40);
    }];
    
    YYLabel *agreementLab = [[YYLabel alloc] init];
    agreementLab.font = RegularFont(12);
    [rootView addSubview:agreementLab];
    [agreementLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(agreementBtn);
        make.left.equalTo(agreementBtn.mas_right).offset(-10);
    }];
    
    //已阅读并同意《用户协议》和《隐私政策》
    NSMutableAttributedString *agreementStr = [[NSMutableAttributedString alloc] initWithString:@"已阅读并同意"];
    agreementStr.yy_font = MediumFont(14);
    agreementStr.yy_color = [UIColor colorWithHex:@"#16171A"];
    
    NSMutableAttributedString *clickStr = [[NSMutableAttributedString alloc] initWithString:@"《用户协议》"];
    clickStr.yy_font = BoldFont(14);
    clickStr.yy_color = [UIColor colorWithHex:@"#4971FF"];
    [clickStr yy_setTextHighlightRange:clickStr.yy_rangeOfAll color:[UIColor colorWithHex:@"#55BB77"] backgroundColor:[UIColor clearColor] tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        //自定义代码，此处根据需要调整
        NSLog(@"-------------点击了用户协议--------------");
        
        FBWebViewController *vc = [[FBWebViewController alloc] init];
        vc.urlStr = ServeAgreement;
        vc.navTitle = @"用户协议";
        [[FBHelper getCurrentController].navigationController pushViewController:vc animated:YES];

    }];
    [agreementStr appendAttributedString:clickStr];
    
    
    NSMutableAttributedString *clickStr1 = [[NSMutableAttributedString alloc] initWithString:@"和"];
    clickStr1.yy_font = MediumFont(14);
    clickStr1.yy_color = [UIColor colorWithHex:@"#16171A"];
//    [clickStr1 yy_setTextHighlightRange:clickStr1.yy_rangeOfAll color:[UIColor colorWithHex:@"#55BB77"] backgroundColor:[UIColor clearColor] tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
//   
//    }];
    [agreementStr appendAttributedString:clickStr1];
    
    NSMutableAttributedString *clickStr2 = [[NSMutableAttributedString alloc] initWithString:@"《隐私政策》"];
    clickStr2.yy_font = BoldFont(14);
    clickStr2.yy_color = [UIColor colorWithHex:@"#4971FF"];
    [clickStr2 yy_setTextHighlightRange:clickStr2.yy_rangeOfAll color:[UIColor colorWithHex:@"#55BB77"] backgroundColor:[UIColor clearColor] tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        //自定义代码，此处根据需要调整
        NSLog(@"-------------点击了隐私协议--------------");
        
        FBWebViewController *vc = [[FBWebViewController alloc] init];
        vc.urlStr = PrivacyAgreement;
        vc.navTitle = @"隐私协议";
        [[FBHelper getCurrentController].navigationController pushViewController:vc animated:YES];
        
    }];
    [agreementStr appendAttributedString:clickStr2];
    agreementLab.attributedText = agreementStr;
    
}
- (UIView *)setupPhoneView{
    UIView *rootView = [[UIView alloc] init];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"请输入手机号";
    textField.font = MediumFont(15);
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.delegate = self;
    [rootView addSubview:textField];
    self.phoneTextField = textField;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(30);
        make.right.offset(-30);
        make.bottom.offset(0);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#E2E7ED"];
    [rootView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.bottom.offset(0);
        make.right.offset(-30);
        make.height.offset(1);
    }];
    
    return rootView;
}
- (UIView *)setupVercodeView{
    UIView *rootView = [[UIView alloc] init];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"请输入短信验证码";
    textField.font = MediumFont(15);
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.delegate = self;
    [rootView addSubview:textField];
    self.codeTextField = textField;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(30);
        make.right.offset(-100);
        make.bottom.offset(0);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#E2E7ED"];
    [rootView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.bottom.offset(0);
        make.right.offset(-30);
        make.height.offset(1);
    }];
    
    UIButton *getCodeBtn = [[UIButton alloc] init];
    getCodeBtn.backgroundColor = [UIColor colorWithHex:@"#4971FF"];
    getCodeBtn.layer.cornerRadius = 12;
    getCodeBtn.layer.masksToBounds = YES;
    [getCodeBtn addTarget:self action:@selector(getCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [getCodeBtn setTitle:@"验证码" forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[UIColor colorWithHex:@"#FFFFFF"] forState:UIControlStateNormal];
    getCodeBtn.titleLabel.font = BoldFont(10);
    [rootView addSubview:getCodeBtn];
    self.buttonSendCode = getCodeBtn;
    [getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rootView);
        make.right.offset(-30);
        make.width.offset(60);
        make.height.offset(24);
    }];
    
    return rootView;
}
@end
