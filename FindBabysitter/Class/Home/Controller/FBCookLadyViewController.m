//
//  FBCookLadyViewController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/1.
//

#import "FBCookLadyViewController.h"

@interface FBCookLadyViewController ()
@property(nonatomic,strong)UILabel *subtitleLab;

@property(nonatomic,strong)UITextField *serviceDurationTextField;
@property(nonatomic,strong)UITextField *flavorTextField;
@property(nonatomic,strong)UITextField *serviceTimeTextField;
@property(nonatomic,strong)UITextField *serviceAddressTextField;

@end

@implementation FBCookLadyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self dealDataToUI];
}
#pragma mark - data
- (void)requestSumitData
{
//    service_duration  工作时长
    //flavor  您喜欢的饭菜口味"
    //service_time 您希望的阿姨上户时间",
    //service_address "您的服务地址",
    
    NSMutableDictionary *extra_data = [[NSMutableDictionary alloc] init];
    [extra_data setValue:self.serviceDurationTextField.text forKey:@"service_duration"];
    [extra_data setValue:self.flavorTextField.text forKey:@"flavor"];
    [extra_data setValue:self.serviceTimeTextField.text forKey:@"service_time"];
    [extra_data setValue:self.serviceAddressTextField.text forKey:@"service_address"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"template_page_4" forKey:@"template_page"];
    [dict setValue:extra_data.mj_JSONString forKey:@"extra_data"];
    
    [[FBHelper getCurrentController] showHudInView:[FBHelper getCurrentController].view hint:@""];
    [FBUMManager event:@"template_page_button_4" attributes:@{}];
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
#pragma mark - priv
- (void)dealDataToUI
{
    FBTemplateFourModel *model = [FBHomeConfManager shareInstance].templateModel.template_page_4;
    self.title = model.title;
    self.subtitleLab.text = model.form_title;
}
#pragma mark - click
- (void)sureBtnClick
{
    [self requestSumitData];
}
#pragma mark - UI
- (void)setupUI
{
    self.title = @"做饭阿姨";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(StatusBarHeight + 44);
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
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"帮我找找做饭阿姨";
    titleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    titleLab.font = BoldFont(24);
    [contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(30);
    }];
    
    UIView *itemView = [self setupItemTotalView];
    [contentView addSubview:itemView];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(20);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.offset(100);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#E2E7ED"];
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(itemView.mas_bottom).offset(20);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.offset(0.5);
    }];
    
    UILabel *subtitleLab = [[UILabel alloc] init];
    subtitleLab.text = @"您需要怎样的做饭阿姨？说出需求，马上看！";
    subtitleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    subtitleLab.font = BoldFont(15);
    [contentView addSubview:subtitleLab];
    self.subtitleLab = subtitleLab;
    [subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(20);
        make.left.offset(25);
    }];
    
    UIView *oneInput = [self setupInputViewWithTag:1];
    [contentView addSubview:oneInput];
    [oneInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subtitleLab.mas_bottom).offset(5);
        make.left.offset(0);
        make.right.offset(0);
    }];
    
    UIView *twoInput = [self setupInputViewWithTag:2];
    [contentView addSubview:twoInput];
    [twoInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneInput.mas_bottom).offset(5);
        make.left.equalTo(oneInput);
        make.right.equalTo(oneInput);
    }];
    
    UIView *threeInput = [self setupInputViewWithTag:3];
    [contentView addSubview:threeInput];
    [threeInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoInput.mas_bottom).offset(5);
        make.left.equalTo(oneInput);
        make.right.equalTo(oneInput);
    }];
    
    UIView *fourInput = [self setupInputViewWithTag:4];
    [contentView addSubview:fourInput];
    [fourInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeInput.mas_bottom).offset(5);
        make.left.equalTo(oneInput);
        make.right.equalTo(oneInput);
    }];
    
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.layer.cornerRadius = 27;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:@"帮我找做饭阿姨" forState:UIControlStateNormal];
    [sureBtn setImage:[UIImage imageNamed:@"img_arrow_white_right"] forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHex:@"#FFFFFF"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = MediumFont(20);
    sureBtn.backgroundColor = [UIColor colorWithHex:@"#4971FF"];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fourInput.mas_bottom).offset(30);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.offset(54);
        
        make.bottom.offset(-20-SafeAreaBottomHeight);
    }];
    
    CGFloat textWidth = 152;
    CGFloat sureWidth = KScreenW - 16*2.0;
    CGFloat textLeft = (sureWidth - textWidth)/2.0;
    sureBtn.titleEdgeInsets = UIEdgeInsetsMake(0, textLeft-10, 0, textLeft);
    sureBtn.imageEdgeInsets = UIEdgeInsetsMake(0, textLeft + textWidth, 0, 0);
    
    UIImageView *btnIconImgView = [[UIImageView alloc] init];
    btnIconImgView.image = [UIImage imageNamed:@"img_cooklady_bottom_icon"];
    [contentView addSubview:btnIconImgView];
    [btnIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sureBtn.mas_left).offset(23);
        make.bottom.equalTo(sureBtn.mas_bottom).offset(-6);
        make.width.offset(72);
        make.height.offset(72);
    }];
}
- (UIView *)setupItemTotalView
{
    UIView *rootView = [[UIView alloc] init];
    
    UIView *oneView = [self setupItemViewWithTag:1];
    [rootView addSubview:oneView];
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.bottom.offset(0);
        make.width.equalTo(rootView.mas_width).multipliedBy(0.333);
    }];
    
    UIView *twoView = [self setupItemViewWithTag:2];
    [rootView addSubview:twoView];
    [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.equalTo(oneView.mas_right).offset(0);
        make.bottom.offset(0);
        make.width.equalTo(oneView);
    }];
    
    UIView *threeView = [self setupItemViewWithTag:3];
    [rootView addSubview:threeView];
    [threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.equalTo(twoView.mas_right).offset(0);
        make.bottom.offset(0);
        make.width.equalTo(oneView);
    }];
    
    return rootView;
}
- (UIView *)setupItemViewWithTag:(int)tag
{
    UIView *rootView = [[UIView alloc] init];
    
    UIImageView *iconImgView = [[UIImageView alloc] init];
    [rootView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootView);
        make.top.offset(0);
        make.width.offset(44);
        make.height.offset(44);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"XXX";
    titleLab.textColor = [UIColor colorWithHex:@"#FF8731"];
    titleLab.font = BoldFont(16);
    [rootView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootView);
        make.top.equalTo(iconImgView.mas_bottom).offset(10);
    }];
    
    UILabel *subtitleLab = [[UILabel alloc] init];
    subtitleLab.text = @"XXX";
    subtitleLab.textColor = [UIColor colorWithHex:@"#666A77"];
    subtitleLab.font = RegularFont(12);
    [rootView addSubview:subtitleLab];
    [subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootView);
        make.top.equalTo(titleLab.mas_bottom).offset(10);
    }];

    if(tag == 1){
        iconImgView.image = [UIImage imageNamed:@"img_cooklady_item_one"];
        titleLab.text = @"参加学习";
        subtitleLab.text = @"找阿姨时间缩短30%";
    }else if(tag == 2){
        iconImgView.image = [UIImage imageNamed:@"img_cooklady_item_two"];
        titleLab.text = @"精准推荐";
        subtitleLab.text = @"专属顾问服务更满意";
    }else if(tag == 3){
        iconImgView.image = [UIImage imageNamed:@"img_cooklady_item_three"];
        titleLab.text = @"随时沟通";
        subtitleLab.text = @"有问必答快速面试";
    }
    
    return rootView;
}
- (UIView *)setupInputViewWithTag:(int)tag
{
    UIView *rootView = [[UIView alloc] init];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"XXX";
    titleLab.textColor = [UIColor colorWithHex:@"#9DA2B3"];
    titleLab.font = MediumFont(14);
    [rootView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(25);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.layer.cornerRadius = 6;
    textField.layer.masksToBounds = YES;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, 10)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.font = MediumFont(12);
    textField.backgroundColor = [UIColor colorWithHex:@"#F3F7FB"];
    [rootView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(10);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.offset(36);
        
        make.bottom.offset(0);
    }];
    
    if(tag == 1){
        titleLab.text = @"您希望的阿姨工作时长";
        textField.placeholder = @"请输入阿姨工作时长";
        self.serviceDurationTextField = textField;
    }else if(tag == 2){
        titleLab.text = @"您喜欢的饭菜口味";
        textField.placeholder = @"请输入您喜欢的饭菜口味";
        self.flavorTextField = textField;
    }else if(tag == 3){
        titleLab.text = @"您希望的阿姨上户时间";
        textField.placeholder = @"请输入阿姨上户时间";
        self.serviceTimeTextField = textField;
    }else if(tag == 4){
        titleLab.text = @"您的服务地址";
        textField.placeholder = @"请选择服务地址";
        self.serviceAddressTextField = textField;
    }
    
    return rootView;
}
@end
