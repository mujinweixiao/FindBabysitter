//
//  FBOnlineBabysitterController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/2.
//

#import "FBOnlineBabysitterController.h"

@interface FBOnlineBabysitterController ()
@property(nonatomic,strong)UIImageView *topImgView;
@property(nonatomic,strong)UILabel *oneContentLab;
@property(nonatomic,strong)UILabel *twoContentLab;
@property(nonatomic,strong)UILabel *threeContentLab;
@property(nonatomic,strong)UILabel *fourContentLab;

@end

@implementation FBOnlineBabysitterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    [self dealDataToUI];
}
#pragma mark - priv
- (void)dealDataToUI
{
    FBTemplateThreeModel *model = [FBHomeConfManager shareInstance].templateModel.template_page_3;
    self.title = model.title;
    [self.topImgView sd_setImageWithURL:[NSURL URLWithString:model.banner]];
    self.oneContentLab.text = model.service_content;
    self.twoContentLab.text = model.service_duration;
    self.threeContentLab.text = model.common_problem;
    self.fourContentLab.text = model.remarks;
}
#pragma mark - click
- (void)sureBtnClick
{
    if([FBHomeConfManager shareInstance].templateModel.template_page_3.is_login == 1){//需要登录
        if([FBUserInfoModel shareInstance].token.length > 0){
            FBWebViewController *webvc = [[FBWebViewController alloc] init];
            webvc.navTitle = @"";
            webvc.urlStr = [FBHomeConfManager shareInstance].templateModel.template_page_3.url;
            [self.navigationController pushViewController:webvc animated:YES];
        }else{
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate oneLittleItemBtnClick];
        }
    }else{
        FBWebViewController *webvc = [[FBWebViewController alloc] init];
        webvc.navTitle = @"";
        webvc.urlStr = [FBHomeConfManager shareInstance].templateModel.template_page_3.url;
        [self.navigationController pushViewController:webvc animated:YES];
    }
}
#pragma mark - UI
- (void)setupUI
{
    self.title = @"云上保姆";
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
    oneTitleLab.text = @"服务内容";
    oneTitleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    oneTitleLab.font = BoldFont(16);
    [contentView addSubview:oneTitleLab];
    [oneTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView.mas_bottom).offset(14);
        make.left.offset(30);
    }];
    
    UILabel *oneContentLab = [[UILabel alloc] init];
    oneContentLab.text = @"1、陪护老人保姆：医院护工、家庭护工、卧床老人、半自理老人、自理老人、半自理病人、卧床病人、自理病人；买菜做饭、打扫卫生、收纳整理、身体清洁、打饭取饭、保健按摩、翻身、清洗衣物、生活护理；照料病、老人日常的饮食，做居所环境卫生、洗床上用品、衣物等。\n2、家居保姆做饭：以主人饮食习惯为主，依据客户要求搭配主副食，保证主人的营养需要，搞厨室卫生，家政服务。　　";
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
    
    UILabel *twoTitleLab = [[UILabel alloc] init];
    twoTitleLab.text = @"服务时长";
    twoTitleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    twoTitleLab.font = BoldFont(16);
    [contentView addSubview:twoTitleLab];
    [twoTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneContentLab.mas_bottom).offset(20);
        make.left.offset(30);
    }];
    
    UILabel *twoContentLab = [[UILabel alloc] init];
    twoContentLab.text = @"住家保姆每天工作8小时/半天阿姨4-6个小时";
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
    
    UILabel *threeTitleLab = [[UILabel alloc] init];
    threeTitleLab.text = @"常见问题";
    threeTitleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    threeTitleLab.font = BoldFont(16);
    [contentView addSubview:threeTitleLab];
    [threeTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoContentLab.mas_bottom).offset(20);
        make.left.offset(30);
    }];
    
    UILabel *threeContentLab = [[UILabel alloc] init];
    threeContentLab.text = @"1. 保姆在工作中存在安全隐患该怎么办？针对这个问题，我们需要告知宁波保姆注意安全，不能随意外出或与陌生人交流\n2. 保姆在工作中遇到家庭成员受伤怎么处理？在家庭成员受伤时，宁波保姆应首先稳定情绪并尽快联系就医。可以采取相应救治措施（如包扎、止血等），同时向雇主报告相关情况。\n3. 保姆是否有疾病时该如何处理？如果宁波保姆在工作期间生病或发现患有传染性疾病，立即向雇主汇报情况并尽快进行就医治疗。";
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
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#E2E7ED"];
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(threeContentLab.mas_bottom).offset(16);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.offset(1);
    }];
    
    UILabel *fourTitleLab = [[UILabel alloc] init];
    fourTitleLab.text = @"备注";
    fourTitleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    fourTitleLab.font = BoldFont(16);
    [contentView addSubview:fourTitleLab];
    [fourTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(18);
        make.left.offset(30);
    }];
    
    UILabel *fourContentLab = [[UILabel alloc] init];
    fourContentLab.text = @"本服务目前仅支持北京地区，其他城市敬请期待～";
    fourContentLab.textColor = [UIColor colorWithHex:@"#16171A"];
    fourContentLab.font = MediumFont(14);
    fourContentLab.numberOfLines = 0;
    [contentView addSubview:fourContentLab];
    self.fourContentLab = fourContentLab;
    [fourContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fourTitleLab.mas_bottom).offset(10);
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
        make.top.equalTo(fourContentLab.mas_bottom).offset(37);
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
@end
