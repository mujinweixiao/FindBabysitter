//
//  FBCleanAirController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/2.
//

#import "FBCleanAirController.h"
#import "FBAppointmentPopView.h"//预约弹窗
@interface FBCleanAirController ()
@property(nonatomic,strong)FBAppointmentPopView *appointmentPopView;

@property(nonatomic,strong)UIImageView *topImgView;
@property(nonatomic,strong)UILabel *oneTitleLab;
@property(nonatomic,strong)UILabel *twoContentLab;
@property(nonatomic,strong)UILabel *threeContentLab;
@property(nonatomic,strong)UILabel *priceLab;
@property(nonatomic,strong) UILabel *footerLab;

@end

@implementation FBCleanAirController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self dealDataToUI];
}
#pragma mark - click
- (void)sureBtnClick
{
    self.appointmentPopView.hidden = NO;
}
#pragma mark - priv
- (void)dealDataToUI
{
    FBTemplateOneModel *model = [FBHomeConfManager shareInstance].templateModel.template_page_1;
    self.title = model.title;
    [self.topImgView sd_setImageWithURL:[NSURL URLWithString:model.banner]];
    self.twoContentLab.text = model.cost_desc;
    self.threeContentLab.text = model.service_details;
    self.priceLab.text = model.fee_standards;
    self.footerLab.text = [NSString stringWithFormat:@"/起  %@",model.paid_services];
}
#pragma mark - UI
- (void)setupUI
{
    self.title = @"清洗空调/甲醛治理";
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
    topImgView.image = [UIImage imageNamed:@"img_cleanair_top_background"];
    [contentView addSubview:topImgView];
    self.topImgView = topImgView;
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(StatusBarHeight + 44 + 16);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.equalTo(topImgView.mas_width).multipliedBy(130.0/346.0);
    }];
    
    UILabel *oneTitleLab = [[UILabel alloc] init];
    oneTitleLab.text = @"收费标准";
    oneTitleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    oneTitleLab.font = BoldFont(16);
    [contentView addSubview:oneTitleLab];
    self.oneTitleLab = oneTitleLab;
    [oneTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView.mas_bottom).offset(14);
        make.left.offset(30);
    }];
    
    UIView *priceView = [self setupPriceView];
    [contentView addSubview:priceView];
    [priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneTitleLab.mas_bottom).offset(10);
        make.left.offset(34);
        make.right.offset(-34);
        make.height.offset(30);
    }];
    
    UIView *onelineView = [[UIView alloc] init];
    onelineView.backgroundColor = [UIColor colorWithHex:@"#E2E7ED"];
    [contentView addSubview:onelineView];
    [onelineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceView.mas_bottom).offset(16);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.offset(1);
    }];
    
    UILabel *twoTitleLab = [[UILabel alloc] init];
    twoTitleLab.text = @"费用说明";
    twoTitleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    twoTitleLab.font = BoldFont(16);
    [contentView addSubview:twoTitleLab];
    [twoTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(onelineView.mas_bottom).offset(18);
        make.left.offset(30);
    }];
    
    UILabel *twoContentLab = [[UILabel alloc] init];
    twoContentLab.text = @"1、计费面积以产权登记面积为准，对于产权登记面积之外的赠送、扩建区域(如loft建筑、复式建筑等)，如需治理，需按增加面积计费。\n2、上门费:【距服务开始前1小时内】或【商家已到场并开始服务后】，若用户申请取消订单，需支付30元上门费;若服务正常完成，无需支付。";
    twoContentLab.textColor = [UIColor colorWithHex:@"#16171A"];
    twoContentLab.font = MediumFont(14);
    twoContentLab.numberOfLines = 0;
    [contentView addSubview:twoContentLab];
    self.twoContentLab = twoContentLab;
    [twoContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoTitleLab.mas_bottom).offset(10);
        make.left.offset(30);
        make.right.offset(-30);
    }];
    
    UIView *twolineView = [[UIView alloc] init];
    twolineView.backgroundColor = [UIColor colorWithHex:@"#E2E7ED"];
    [contentView addSubview:twolineView];
    [twolineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoContentLab.mas_bottom).offset(16);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.offset(1);
    }];
    
    UILabel *threeTitleLab = [[UILabel alloc] init];
    threeTitleLab.text = @"服务详情";
    threeTitleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    threeTitleLab.font = BoldFont(16);
    [contentView addSubview:threeTitleLab];
    [threeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twolineView.mas_bottom).offset(20);
        make.left.offset(30);
    }];
    
    UILabel *threeContentLab = [[UILabel alloc] init];
    threeContentLab.text = @"1. 取出空调过滤网将面板打开到面板停开位置，约60度，抽出空气过滤网稍向上提起空气过滤网中央的手柄，向下方抽出。\n2. 清洗过滤网积灰比较少时，用水洗或用吸尘器吸；积灰严重时，请放在含有中性洗涤剂的水中浸泡10--15分钟。装上过滤网后，把风量及制冷量调至最大30分钟。";
    threeContentLab.textColor = [UIColor colorWithHex:@"#16171A"];
    threeContentLab.font = MediumFont(14);
    threeContentLab.numberOfLines = 0;
    [contentView addSubview:threeContentLab];
    self.threeContentLab = threeContentLab;
    [threeContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeTitleLab.mas_bottom).offset(10);
        make.left.offset(30);
        make.right.offset(-30);
    }];
    

    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.layer.cornerRadius = 27;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:@"我已知晓，需预约" forState:UIControlStateNormal];
    [sureBtn setImage:[UIImage imageNamed:@"img_arrow_white_right"] forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHex:@"#FFFFFF"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = MediumFont(20);
    sureBtn.backgroundColor = [UIColor colorWithHex:@"#4971FF"];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeContentLab.mas_bottom).offset(37);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.offset(54);
        
        make.bottom.offset(-20-SafeAreaBottomHeight);
    }];
    
    CGFloat textWidth = 172;
    CGFloat sureWidth = KScreenW - 16*2.0;
    CGFloat textLeft = (sureWidth - textWidth)/2.0;
    sureBtn.titleEdgeInsets = UIEdgeInsetsMake(0, textLeft-10, 0, textLeft);
    sureBtn.imageEdgeInsets = UIEdgeInsetsMake(0, textLeft + textWidth, 0, 0);
    
//    UIImageView *btnIconImgView = [[UIImageView alloc] init];
//    btnIconImgView.image = [UIImage imageNamed:@"img_cooklady_bottom_icon"];
//    [contentView addSubview:btnIconImgView];
//    [btnIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(sureBtn.mas_left).offset(23);
//        make.bottom.equalTo(sureBtn.mas_bottom).offset(-6);
//        make.width.offset(72);
//        make.height.offset(72);
//    }];
    
    
    FBAppointmentPopView *appointmentPopView = [[FBAppointmentPopView alloc] init];
    appointmentPopView.hidden = YES;
    [self.view addSubview:appointmentPopView];
    self.appointmentPopView = appointmentPopView;
    [appointmentPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (UIView *)setupPriceView
{
    UIView *rootView = [[UIView alloc] init];
    
    UILabel *symLab = [[UILabel alloc] init];
    symLab.text = @"¥";
    symLab.textColor = [UIColor colorWithHex:@"#4971FF"];
    symLab.font = MediumFont(14);
    [rootView addSubview:symLab];
    [symLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.bottom.offset(-5);
    }];
    
    UILabel *priceLab = [[UILabel alloc] init];
    priceLab.text = @"115";
    priceLab.textColor = [UIColor colorWithHex:@"#4971FF"];
    priceLab.font = MediumFont(26);
    [rootView addSubview:priceLab];
    self.priceLab = priceLab;
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(symLab.mas_right).offset(0);
        make.bottom.offset(0);
    }];
    
    UILabel *footerLab = [[UILabel alloc] init];
    footerLab.text = @"/起  空调蒸汽清洗";
    footerLab.textColor = [UIColor colorWithHex:@"#4971FF"];
    footerLab.font = MediumFont(14);;
    [rootView addSubview:footerLab];
    self.footerLab = footerLab;
    [footerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLab.mas_right).offset(0);
        make.bottom.offset(-5);
    }];
    
    return rootView;
}
@end
