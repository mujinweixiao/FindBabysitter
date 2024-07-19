//
//  FBAppointmentPopView.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/3.
//

#import "FBAppointmentPopView.h"

@interface FBAppointmentPopView()
@property(nonatomic,strong)UITextField *contactsTextField;
@property(nonatomic,strong)UITextField *mobileTextField;
@property(nonatomic,strong)UITextField *serviceAddressTextField;
@property(nonatomic,strong)UITextField *timeTextField;

@end

@implementation FBAppointmentPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame]){
        [self setupUI];
    }
    return self;
}
#pragma mark - data
- (void)requestSumitData
{
//    @property(nonatomic,strong)UITextField *contactsTextField;
//    @property(nonatomic,strong)UITextField *mobileTextField;
//    @property(nonatomic,strong)UITextField *serviceAddressTextField;
//    @property(nonatomic,strong)UITextField *timeTextField;
    
    NSMutableDictionary *extra_data = [[NSMutableDictionary alloc] init];
    [extra_data setValue:self.contactsTextField.text forKey:@"contacts"];
    [extra_data setValue:self.mobileTextField.text forKey:@"mobile"];
    [extra_data setValue:self.serviceAddressTextField.text forKey:@"service_address"];
    [extra_data setValue:self.timeTextField.text forKey:@"service_time"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"template_page_1" forKey:@"template_page"];
    [dict setValue:extra_data.mj_JSONString forKey:@"extra_data"];
    
    [[FBHelper getCurrentController] showHudInView:[FBHelper getCurrentController].view hint:@""];
    [FBUMManager event:@"template_page_button_1" attributes:@{}];
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
                [[FBHelper getCurrentController].navigationController pushViewController:vc animated:YES];
            }else{
                FBSubmitSuccessController *vc = [[FBSubmitSuccessController alloc] init];
                [[FBHelper getCurrentController].navigationController pushViewController:vc animated:YES];
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
- (void)closeBtnClick
{
    self.hidden = YES;
}
- (void)sureBtnClick
{
    [self requestSumitData];
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
        make.height.offset(552+10);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"请填写您的预约信息";
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
    
    UIView *oneInputView = [self setupInputViewWithTag:1];
    [rootView addSubview:oneInputView];
    [oneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(15);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(70);
    }];
    
    UIView *twoInputView = [self setupInputViewWithTag:2];
    [rootView addSubview:twoInputView];
    [twoInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneInputView.mas_bottom).offset(20);
        make.left.equalTo(oneInputView);
        make.right.equalTo(oneInputView);
        make.height.equalTo(oneInputView);
    }];
    
    UIView *threeInputView = [self setupInputViewWithTag:3];
    [rootView addSubview:threeInputView];
    [threeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoInputView.mas_bottom).offset(20);
        make.left.equalTo(oneInputView);
        make.right.equalTo(oneInputView);
        make.height.equalTo(oneInputView);
    }];
    
    UIView *fourInputView = [self setupInputViewWithTag:4];
    [rootView addSubview:fourInputView];
    [fourInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeInputView.mas_bottom).offset(20);
        make.left.equalTo(oneInputView);
        make.right.equalTo(oneInputView);
        make.height.equalTo(oneInputView);
    }];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.layer.cornerRadius = 27;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:@"立即预约" forState:UIControlStateNormal];
    [sureBtn setImage:[UIImage imageNamed:@"img_arrow_white_right"] forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHex:@"#FFFFFF"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = MediumFont(20);
    sureBtn.backgroundColor = [UIColor colorWithHex:@"#4971FF"];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fourInputView.mas_bottom).offset(46);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.offset(54);
    }];
    
    CGFloat textWidth = 102;
    CGFloat sureWidth = KScreenW - 16*2.0;
    CGFloat textLeft = (sureWidth - textWidth)/2.0;
    sureBtn.titleEdgeInsets = UIEdgeInsetsMake(0, textLeft-20, 0, textLeft);
    sureBtn.imageEdgeInsets = UIEdgeInsetsMake(0, textLeft + textWidth - 60, 0, 0);
    
    
}
- (UIView *)setupInputViewWithTag:(int)tag
{
    UIView *rootView = [[UIView alloc] init];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"";
    titleLab.textColor = [UIColor colorWithHex:@"#666A77"];
    titleLab.font = MediumFont(14);
    [rootView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(30);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor colorWithHex:@"#F3F7FB"];
    textField.layer.cornerRadius = 6;
    textField.layer.masksToBounds = YES;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, 10)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.font = MediumFont(12);
    [rootView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.bottom.offset(0);
        make.right.offset(-16);
        make.height.offset(35);
    }];
    
    if(tag == 1){
        titleLab.text = @"联系人";
        textField.placeholder = @"请输入联系人";
        self.contactsTextField = textField;
    }else if(tag == 2){
        titleLab.text = @"手机号码";
        textField.placeholder = @"请输入手机号码";
        self.mobileTextField = textField;
    }else if(tag == 3){
        titleLab.text = @"服务地址";
        textField.placeholder = @"请选择服务地址";
        self.serviceAddressTextField = textField;
    }else if(tag == 4){
        titleLab.text = @"上门时间";
        textField.placeholder = @"请选择上门时间";
        self.timeTextField = textField;
    }
    
    return rootView;
}
@end
