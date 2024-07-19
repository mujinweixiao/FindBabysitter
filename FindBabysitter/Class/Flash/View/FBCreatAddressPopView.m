//
//  FBCreatAddressPopView.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/3.
//

#import "FBCreatAddressPopView.h"
@interface FBCreatAddressPopView()


@end

@implementation FBCreatAddressPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame]){
        [self setupUI];
    }
    return self;
}
#pragma mark - click
- (void)closeBtnClick
{
    self.hidden = YES;
}
- (void)sureBtnClick
{
    if([self.delegate respondsToSelector:@selector(creatAddressPopViewSureClick)]){
        [self.delegate creatAddressPopViewSureClick];
    }
}
- (void)contactsBtnClick:(UIButton *)sender
{
    self.recordSex = sender.tag;
    self.womanBtn.selected = NO;
    self.manBtn.selected = NO;

    sender.selected = YES;
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
        make.height.offset(364+10);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"请填写收货地址";
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
    
    UIView *contactView = [self setupContactsView];
    [rootView addSubview:contactView];
    [contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(20);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(70);
    }];
    
    UIView *twoInputView = [self setupInputViewWithTag:2];
    [rootView addSubview:twoInputView];
    [twoInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contactView.mas_bottom).offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(30);
    }];
    
    UIView *threeInputView = [self setupInputViewWithTag:3];
    [rootView addSubview:threeInputView];
    [threeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoInputView.mas_bottom).offset(10);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(30);
    }];
    
    UIView *fourInputView = [self setupInputViewWithTag:4];
    [rootView addSubview:fourInputView];
    [fourInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeInputView.mas_bottom).offset(10);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(30);
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
        make.top.equalTo(fourInputView.mas_bottom).offset(26);
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
    self.nameTextField = textField;
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
