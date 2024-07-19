//
//  FBNearbyController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/1.
//

#import "FBNearbyController.h"

@interface FBNearbyController ()
@property(nonatomic,strong)UIImageView *topImgView;
@property(nonatomic,strong)UILabel *oneTitleLab;
@property(nonatomic,strong)UILabel *oneContentLab;

@property(nonatomic,strong)UIButton *oneBtn;
@property(nonatomic,strong)UIButton *twoBtn;
@property(nonatomic,strong)UIButton *threeBtn;
@property(nonatomic,strong)UIButton *fourBtn;
///记录类型 1育儿嫂  2月嫂 3做饭保姆 4住家保姆
@property(nonatomic,assign)NSInteger recordType;

@property(nonatomic,strong)UIButton *manBtn;
@property(nonatomic,strong)UIButton *womanBtn;
///记录性别 1：女  2：男
@property(nonatomic,assign)NSInteger recordSex;

@property(nonatomic,strong)UITextField *cityTextField;
@property(nonatomic,strong)UITextField *nameTextField;
@property(nonatomic,strong)UITextField *mobileTextField;
@property(nonatomic,strong)UITextField *wechatTextField;
@property(nonatomic,strong)UITextField *contentTextField;

@end

@implementation FBNearbyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self dealDataToUI];
}
#pragma mark - priv
- (void)dealDataToUI
{
    FBTemplateTwoModel *model = [FBHomeConfManager shareInstance].templateModel.template_page_2;
    self.title = model.title;
    [self.topImgView sd_setImageWithURL:[NSURL URLWithString:model.banner]];
    self.oneTitleLab.text = model.supporting_regions;
    self.oneContentLab.text = model.desc;
}
- (void)requestSumitData
{
    //location_city 所在城市
    //nanny_type  options": [
    //    "月嫂",
    //    "育儿嫂",
    //    "住家保姆",
    //    "做饭保姆"
    //  ]
    //contacts  联系人
    //sex  "先生", "女士"
    //mobile 手机号
    //wechat_number 微信号
    //remarks 补充说明
    
    NSString *nanny_type = @"";
    if(self.recordType == 1){
        nanny_type = @"育儿嫂";
    }else if(self.recordType == 2){
        nanny_type = @"月嫂";
    }else if(self.recordType == 3){
        nanny_type = @"做饭保姆";
    }else if(self.recordType == 4){
        nanny_type = @"住家保姆";
    }
    NSString *sex = @"";
    if(self.recordSex == 1){
        sex = @"女士";
    }else if(self.recordSex == 2){
        sex = @"先生";
    }
    
    NSMutableDictionary *extra_data = [[NSMutableDictionary alloc] init];
    [extra_data setValue:self.cityTextField.text forKey:@"location_city"];
    [extra_data setValue:nanny_type forKey:@"nanny_type"];
    [extra_data setValue:self.nameTextField.text forKey:@"contacts"];
    [extra_data setValue:sex forKey:@"sex"];
    [extra_data setValue:self.mobileTextField.text forKey:@"mobile"];
    [extra_data setValue:self.wechatTextField.text forKey:@"wechat_number"];
    [extra_data setValue:self.contentTextField.text forKey:@"remarks"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"template_page_2" forKey:@"template_page"];
    [dict setValue:extra_data.mj_JSONString forKey:@"extra_data"];
    
    [[FBHelper getCurrentController] showHudInView:[FBHelper getCurrentController].view hint:@""];
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
- (void)sureBtnClick
{
    [self requestSumitData];
}
- (void)typeBtnClick:(UIButton *)sender
{
    self.recordType = sender.tag;
    
    self.oneBtn.selected = NO;
    self.twoBtn.selected = NO;
    self.threeBtn.selected = NO;
    self.fourBtn.selected = NO;

    sender.selected = YES;
}
- (void)contactsBtnClick:(UIButton *)sender
{
    self.recordSex = sender.tag;
    
    self.manBtn.selected = NO;
    self.womanBtn.selected = NO;

    sender.selected = YES;
}
#pragma mark - UI
- (void)setupUI
{
    self.title = @"附近";
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
    topImgView.image = [UIImage imageNamed:@"img_onlinebaby_top_background"];
    [contentView addSubview:topImgView];
    self.topImgView = topImgView;
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(StatusBarHeight + 44 + 16);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.equalTo(topImgView.mas_width).multipliedBy(130.0/346.0);
    }];
    
    UILabel *oneTitleLab = [[UILabel alloc] init];
    oneTitleLab.text = @"本服务目前仅支持北京地区";
    oneTitleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    oneTitleLab.font = BoldFont(16);
    [contentView addSubview:oneTitleLab];
    self.oneTitleLab = oneTitleLab;
    [oneTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView.mas_bottom).offset(14);
        make.left.offset(30);
    }];
    
    UILabel *oneContentLab = [[UILabel alloc] init];
    oneContentLab.text = @"尊敬的用户朋友，在使用我们这款app5~7天以后，若您仍未找到心仪的保姆，请填写以下信息，我们会安排专人与您联系，为您重新推荐。";
    oneContentLab.textColor = [UIColor colorWithHex:@"#16171A"];
    oneContentLab.font = MediumFont(14);
    oneContentLab.numberOfLines = 0;
    [contentView addSubview:oneContentLab];
    self.oneContentLab = oneContentLab;
    [oneContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneTitleLab.mas_bottom).offset(10);
        make.left.offset(30);
        make.right.offset(-30);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#E2E7ED"];
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneContentLab.mas_bottom).offset(16);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.offset(1);
    }];
    
    UIView *oneInputView = [self setupInputViewWithTag:1];
    [contentView addSubview:oneInputView];
    [oneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(10);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(30);
    }];
    
    UIView *typeView = [self setupTypeView];
    [contentView addSubview:typeView];
    [typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneInputView.mas_bottom).offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(70);
    }];
    
    UIView *contactView = [self setupContactsView];
    [contentView addSubview:contactView];
    [contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeView.mas_bottom).offset(10);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(70);
    }];
    
    UIView *twoInputView = [self setupInputViewWithTag:2];
    [contentView addSubview:twoInputView];
    [twoInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contactView.mas_bottom).offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(30);
    }];
    
    UIView *threeInputView = [self setupInputViewWithTag:3];
    [contentView addSubview:threeInputView];
    [threeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoInputView.mas_bottom).offset(10);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(30);
    }];
    
    UIView *fourInputView = [self setupInputViewWithTag:4];
    [contentView addSubview:fourInputView];
    [fourInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeInputView.mas_bottom).offset(10);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(30);
    }];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.layer.cornerRadius = 27;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:@"请尽快联系我，提交" forState:UIControlStateNormal];
    [sureBtn setImage:[UIImage imageNamed:@"img_arrow_white_right"] forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHex:@"#FFFFFF"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = MediumFont(20);
    sureBtn.backgroundColor = [UIColor colorWithHex:@"#4971FF"];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fourInputView.mas_bottom).offset(37);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.offset(54);
        
        make.bottom.offset(-20-SafeAreaBottomHeight);
    }];
    
    CGFloat textWidth = 200;
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
- (UIView *)setupInputViewWithTag:(int)tag
{
    UIView *rootView = [[UIView alloc] init];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"标题";
    titleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    titleLab.font = MediumFont(14);
    [rootView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rootView);
        make.left.offset(30);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.font = MediumFont(14);
    textField.textAlignment = NSTextAlignmentRight;
    [rootView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(150);
        make.bottom.offset(0);
        make.right.offset(-30);
    }];
    
    if(tag == 1){
        titleLab.text = @"所在城市";
        textField.placeholder = @"请选择所在城市";
        self.cityTextField = textField;
    }else if(tag == 2){
        titleLab.text = @"手机号";
        textField.placeholder = @"请填写联系人手机号码";
        self.mobileTextField = textField;
    }else if(tag == 3){
        titleLab.text = @"微信号";
        textField.placeholder = @"请填写联系人微信号（选填）";
        self.wechatTextField = textField;
    }else if(tag == 4){
        titleLab.text = @"补充说明";
        textField.placeholder = @"请填写补充说明（选填）";
        self.contentTextField = textField;
    }
    
    return rootView;
}
- (UIView *)setupTypeView
{
    UIView *rootView = [[UIView alloc] init];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"保姆类型";
    titleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    titleLab.font = MediumFont(14);
    [rootView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(30);
    }];
    
//    月嫂      育儿嫂
//    住家保姆      做饭保姆
    //img_circle_select  img_circle_noselect
    
    UIButton *oneBtn = [[UIButton alloc] init];
    [oneBtn setTitle:@"育儿嫂" forState:UIControlStateNormal];
    [oneBtn setImage:[UIImage imageNamed:@"img_circle_noselect"] forState:UIControlStateNormal];
    [oneBtn setImage:[UIImage imageNamed:@"img_circle_select"] forState:UIControlStateSelected];
    [oneBtn setTitleColor:[UIColor colorWithHex:@"#9DA2B3"] forState:UIControlStateNormal];
    oneBtn.titleLabel.font = MediumFont(14);
    oneBtn.tag = 1;
    [oneBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:oneBtn];
    self.oneBtn = oneBtn;
    [oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.right.offset(-30);
        make.width.offset(60);
        make.height.offset(30);
    }];
    
    UIButton *twoBtn = [[UIButton alloc] init];
    [twoBtn setTitle:@"月嫂" forState:UIControlStateNormal];
    [twoBtn setImage:[UIImage imageNamed:@"img_circle_noselect"] forState:UIControlStateNormal];
    [twoBtn setImage:[UIImage imageNamed:@"img_circle_select"] forState:UIControlStateSelected];
    [twoBtn setTitleColor:[UIColor colorWithHex:@"#9DA2B3"] forState:UIControlStateNormal];
    twoBtn.titleLabel.font = MediumFont(14);
    twoBtn.tag = 2;
    [twoBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:twoBtn];
    self.twoBtn = twoBtn;
    [twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneBtn);
        make.right.equalTo(oneBtn.mas_left).offset(0);
        make.width.offset(60);
        make.height.equalTo(oneBtn);
    }];
    
    UIButton *threeBtn = [[UIButton alloc] init];
    [threeBtn setTitle:@"做饭保姆" forState:UIControlStateNormal];
    [threeBtn setImage:[UIImage imageNamed:@"img_circle_noselect"] forState:UIControlStateNormal];
    [threeBtn setImage:[UIImage imageNamed:@"img_circle_select"] forState:UIControlStateSelected];
    [threeBtn setTitleColor:[UIColor colorWithHex:@"#9DA2B3"] forState:UIControlStateNormal];
    threeBtn.titleLabel.font = MediumFont(14);
    threeBtn.tag = 3;
    [threeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:threeBtn];
    self.threeBtn = threeBtn;
    [threeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneBtn.mas_bottom).offset(0);
        make.right.equalTo(oneBtn);
        make.width.offset(80);
        make.height.equalTo(oneBtn);
    }];
    
    UIButton *fourBtn = [[UIButton alloc] init];
    [fourBtn setTitle:@"住家保姆" forState:UIControlStateNormal];
    [fourBtn setImage:[UIImage imageNamed:@"img_circle_noselect"] forState:UIControlStateNormal];
    [fourBtn setImage:[UIImage imageNamed:@"img_circle_select"] forState:UIControlStateSelected];
    [fourBtn setTitleColor:[UIColor colorWithHex:@"#9DA2B3"] forState:UIControlStateNormal];
    fourBtn.titleLabel.font = MediumFont(14);
    fourBtn.tag = 4;
    [fourBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:fourBtn];
    self.fourBtn = fourBtn;
    [fourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeBtn);
        make.right.equalTo(threeBtn.mas_left);
        make.width.offset(80);
        make.height.equalTo(oneBtn);
    }];
    
    return rootView;
}
//联系人部分
- (UIView *)setupContactsView
{
    UIView *rootView = [[UIView alloc] init];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"联系人";
    titleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    titleLab.font = MediumFont(14);
    [rootView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.left.offset(30);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.font = MediumFont(14);
    textField.textAlignment = NSTextAlignmentRight;
    textField.placeholder = @"请填写联系人姓名";
    [rootView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(150);
        make.right.offset(-30);
        make.height.offset(30);
    }];
    
    UIButton *oneBtn = [[UIButton alloc] init];
    [oneBtn setTitle:@"女士" forState:UIControlStateNormal];
    [oneBtn setImage:[UIImage imageNamed:@"img_circle_noselect"] forState:UIControlStateNormal];
    [oneBtn setImage:[UIImage imageNamed:@"img_circle_select"] forState:UIControlStateSelected];
    [oneBtn setTitleColor:[UIColor colorWithHex:@"#9DA2B3"] forState:UIControlStateNormal];
    oneBtn.titleLabel.font = MediumFont(14);
    oneBtn.tag = 1;
    [oneBtn addTarget:self action:@selector(contactsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:oneBtn];
    self.womanBtn = oneBtn;
    [oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom).offset(0);
        make.right.offset(-30);
        make.width.offset(50);
        make.height.offset(30);
    }];
    
    UIButton *twoBtn = [[UIButton alloc] init];
    [twoBtn setTitle:@"先生" forState:UIControlStateNormal];
    [twoBtn setImage:[UIImage imageNamed:@"img_circle_noselect"] forState:UIControlStateNormal];
    [twoBtn setImage:[UIImage imageNamed:@"img_circle_select"] forState:UIControlStateSelected];
    [twoBtn setTitleColor:[UIColor colorWithHex:@"#9DA2B3"] forState:UIControlStateNormal];
    twoBtn.titleLabel.font = MediumFont(14);
    twoBtn.tag = 2;
    [twoBtn addTarget:self action:@selector(contactsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:twoBtn];
    self.manBtn = twoBtn;
    [twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneBtn);
        make.right.equalTo(oneBtn.mas_left).offset(0);
        make.width.offset(60);
        make.height.equalTo(oneBtn);
    }];
        
    return rootView;
}
@end
