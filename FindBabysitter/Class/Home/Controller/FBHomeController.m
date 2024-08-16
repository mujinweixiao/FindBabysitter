//
//  FBHomeController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/1.
//

#import "FBHomeController.h"
#import "HW3DBannerView.h"
#import "FBAuntieRecruitmentController.h"
#import "FBCookLadyViewController.h"
#import "FBOnlineBabysitterController.h"//云上保姆
#import "FBCleanAirController.h"//清洗空调
#import "FBJoinStudyController.h"//参加学习
#import "FBLoginPopController.h"//登录
#import "FBHomeConfModel.h"//首页配置
#import "FBTemplateModel.h"//模版
#import "FBAuntieRecruitmentController.h"//阿姨招募
#import "FBHomeAdPopView.h"//广告弹窗
@interface FBHomeController ()<FBHomeAdPopViewDelegate>
@property (nonatomic, strong) HW3DBannerView *viewBanner;
@property(nonatomic,strong)FBHomeConfModel *homeConfModel;

///搜索按钮
@property(nonatomic,strong)UIButton *searchBtn;
//大按钮部分
@property(nonatomic,strong)UIImageView *bigItemBackgroundImgView;
@property(nonatomic,strong)UILabel *bigItemTitleLab;
@property(nonatomic,strong)UILabel *bigItemGoLab;
@property(nonatomic,strong)UILabel *bigItemContentLab;
@property(nonatomic,strong)UIImageView *fireImgView;
//小1按钮
@property(nonatomic,strong)UILabel *littleItemOneTitleLab;
@property(nonatomic,strong)UILabel *littleItemOneSubTitleLab;
//小2按钮
@property(nonatomic,strong)UILabel *littleItemTwoTitleLab;
@property(nonatomic,strong)UILabel *littleItemTwoSubTitleLab;
//横向四个按钮
@property(nonatomic,strong)UILabel *horOneTitleLab;
@property(nonatomic,strong)UIImageView *horOneImgView;
@property(nonatomic,strong)UILabel *horTwoTitleLab;
@property(nonatomic,strong)UIImageView *horTwoImgView;
@property(nonatomic,strong)UILabel *horThreeTitleLab;
@property(nonatomic,strong)UIImageView *horThreeImgView;
@property(nonatomic,strong)UILabel *horFourTitleLab;
@property(nonatomic,strong)UIImageView *horFourImgView;

//广告弹窗
@property(nonatomic,strong)FBHomeAdPopView *adPopView;

@end

@implementation FBHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = YES;
    
    
    [self setupUI];
    [self requestTempData];
    [self requestConfData];
    [self requestToSubmitActiveData];
    
    
    //首页配置接口请求成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netLinkSuccess:) name:NotNetLinkSuccess object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - not
//网络连接成功
- (void)netLinkSuccess:(NSNotification *)notification{
    [self requestTempData];
    [self requestConfData];
    [self requestToSubmitActiveData];
}
#pragma mark - data
- (void)requestTempData
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
//    [[FBHelper getCurrentController] showHudInView:[FBHelper getCurrentController].view hint:@""];
    [FBRequestData requestWithUrl:templateConfig_Url para:dict Complete:^(NSData * _Nonnull data) {
        [[FBHelper getCurrentController] hideHud];
        NSDictionary *registerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *code = [registerDic string:@"code"];
        if([code isEqualToString:@"0"]){
            NSDictionary *data = [registerDic dictionary:@"data"];
            FBTemplateModel *tempModel = [FBTemplateModel mj_objectWithKeyValues:data];
            [FBHomeConfManager shareInstance].templateModel = tempModel;
            NSLog(@"");
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
- (void)requestConfData
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [[FBHelper getCurrentController] hideHud];
    [[FBHelper getCurrentController] showHudInView:[FBHelper getCurrentController].view hint:@""];
    [FBRequestData requestWithUrl:homeConfig_Url para:dict Complete:^(NSData * _Nonnull data) {
        [[FBHelper getCurrentController] hideHud];
        NSDictionary *registerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *code = [registerDic string:@"code"];
        if([code isEqualToString:@"0"]){
            NSDictionary *data = [registerDic dictionary:@"data"];
            FBHomeConfModel *homeConfModel = [FBHomeConfModel mj_objectWithKeyValues:data];
            [FBHomeConfManager shareInstance].homeConfModel = homeConfModel;
            self.homeConfModel = homeConfModel;
            
            NSNotification *notification = [NSNotification notificationWithName:NotHomeConfigRequestSuccess object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
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
- (void)setHomeConfModel:(FBHomeConfModel *)homeConfModel
{
    _homeConfModel = homeConfModel;
    
    //搜索按钮，返回整个图
    FBHomeConfItemModel *topItemModel = [homeConfModel.top_button objectAtIndex:0];

    //大item
    FBHomeConfItemModel *threeItemModel = [homeConfModel.middle_button objectAtIndex:2];
    self.bigItemTitleLab.text = threeItemModel.shortcut_title;
    self.bigItemGoLab.text = threeItemModel.shortcut_label;
    self.bigItemContentLab.text = threeItemModel.shortcut_desc;
    [self.fireImgView sd_setImageWithURL:[NSURL URLWithString:threeItemModel.shortcut_horn_icon]];
    [self.bigItemBackgroundImgView sd_setImageWithURL:[NSURL URLWithString:threeItemModel.shortcut_icon]];
    
    //小1item
    FBHomeConfItemModel *oneItemModel = [homeConfModel.middle_button objectAtIndex:0];
    self.littleItemOneTitleLab.text = oneItemModel.shortcut_title;
    self.littleItemOneSubTitleLab.text = oneItemModel.shortcut_desc;
    
    //小2item
    FBHomeConfItemModel *twoItemModel = [homeConfModel.middle_button objectAtIndex:1];
    self.littleItemTwoTitleLab.text = twoItemModel.shortcut_title;
    self.littleItemTwoSubTitleLab.text = twoItemModel.shortcut_desc;
    
    //横向四个
    FBHomeConfItemModel *horOneModel = [homeConfModel.bottom_button objectAtIndex:0];
    FBHomeConfItemModel *horTwoModel = [homeConfModel.bottom_button objectAtIndex:1];
    FBHomeConfItemModel *horThreeModel = [homeConfModel.bottom_button objectAtIndex:2];
    FBHomeConfItemModel *horFourModel = [homeConfModel.bottom_button objectAtIndex:3];
    self.horOneTitleLab.text = horOneModel.shortcut_title;
    [self.horOneImgView sd_setImageWithURL:[NSURL URLWithString:horOneModel.shortcut_icon]];
    self.horTwoTitleLab.text = horTwoModel.shortcut_title;
    [self.horTwoImgView sd_setImageWithURL:[NSURL URLWithString:horTwoModel.shortcut_icon]];
    self.horThreeTitleLab.text = horThreeModel.shortcut_title;
    [self.horThreeImgView sd_setImageWithURL:[NSURL URLWithString:horThreeModel.shortcut_icon]];
    self.horFourTitleLab.text = horFourModel.shortcut_title;
    [self.horFourImgView sd_setImageWithURL:[NSURL URLWithString:horFourModel.shortcut_icon]];

    //轮播图
    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
    for (FBHomeConfItemModel *itemModel in homeConfModel.banners) {
        if(itemModel.shortcut_icon.length > 0){
            [imgArray addObject:itemModel.shortcut_icon];
        }
    }
    _viewBanner.data = imgArray;
    
    //弹窗
    if(homeConfModel.alter_button.count > 0){
        self.adPopView.hidden = NO;
        FBHomeConfItemModel *item = [homeConfModel.alter_button firstObject];
        [self.adPopView.backgroundImgView sd_setImageWithURL:[NSURL URLWithString:item.shortcut_icon]];
    }
    
}
#pragma mark - 应用第一次安装
//应用第一次安装调用
- (void)requestToSubmitActiveData
{
    NSString *uuid = [FBHelper iOSUUID];
    if(uuid.length == 0){
        return;
    }
    
    NSString *firstOpen = [[NSUserDefaults standardUserDefaults] objectForKey:FBFirstOpen];
    if(firstOpen.length > 0){
        return;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[FBHelper iOSUUID] forKey:@"uuid"];
    [dict setValue:[FBHelper getIdfa] forKey:@"idfa"];
    [dict setValue:[FBHelper getAppVersion] forKey:@"os_version"];
    [dict setValue:@"iOS" forKey:@"os_system"];
    [dict setValue:[FBHelper iphoneType] forKey:@"os_model"];
    
    [FBRequestData requestWithUrl:toSubmitActive_Url para:dict Complete:^(NSData * _Nonnull data) {
        [[FBHelper getCurrentController] hideHud];
        NSDictionary *registerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *code = [registerDic string:@"code"];
        if([code isEqualToString:@"0"]){
            NSLog(@"");
            [[NSUserDefaults standardUserDefaults] setValue:FBFirstOpen forKey:FBFirstOpen];
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
#pragma mark - 弹窗代理
- (void)homeAdPopViewSureClick
{
    self.adPopView.hidden = YES;
    
    FBHomeConfItemModel *topItemModel = [self.homeConfModel.alter_button objectAtIndex:0];
    [self clickItemWithModel:topItemModel];
}
#pragma mark - click
- (void)searchBtnClick
{
    [FBUMManager event:@"top_button" attributes:@{}];
    
    FBHomeConfItemModel *topItemModel = [self.homeConfModel.top_button objectAtIndex:0];
    [self clickItemWithModel:topItemModel];
}
- (void)oneLittleItemBtnClick
{
    [FBUMManager event:@"middle_button_1" attributes:@{}];

    FBHomeConfItemModel *oneItemModel = [self.homeConfModel.middle_button objectAtIndex:0];
    [self clickItemWithModel:oneItemModel];
}
- (void)twoLittleItemBtnClick
{
    [FBUMManager event:@"middle_button_2" attributes:@{}];

    FBHomeConfItemModel *twoItemModel = [self.homeConfModel.middle_button objectAtIndex:1];
    [self clickItemWithModel:twoItemModel];

//    FBCookLadyViewController *vc = [[FBCookLadyViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}
- (void)bigItemBtnClick
{
    [FBUMManager event:@"middle_button_3" attributes:@{}];

    FBHomeConfItemModel *threeItemModel = [self.homeConfModel.middle_button objectAtIndex:2];
    [self clickItemWithModel:threeItemModel];
}
- (void)itemBtnClick:(UIButton *)sender
{
    
    FBHomeConfItemModel *horModel = [self.homeConfModel.bottom_button objectAtIndex:sender.tag - 1];
    [self clickItemWithModel:horModel];

    if(sender.tag == 1){
        [FBUMManager event:@"bottom_button_1" attributes:@{}];
    }else if(sender.tag == 2){
        [FBUMManager event:@"bottom_button_2" attributes:@{}];
    }else if(sender.tag == 3){
        [FBUMManager event:@"bottom_button_3" attributes:@{}];
    }else if(sender.tag == 4){
        [FBUMManager event:@"bottom_button_4" attributes:@{}];
    }
}
//点击去哪
- (void)clickItemWithModel:(FBHomeConfItemModel *)itemModel
{
    if([itemModel.shortcut_type isEqualToString:@"2"]){
        FBWebViewController *webvc = [[FBWebViewController alloc] init];
        webvc.navTitle = itemModel.shortcut_title;
        webvc.urlStr = itemModel.shortcut_value;
        [self.navigationController pushViewController:webvc animated:YES];
        return;
    }
    
    if([itemModel.shortcut_value isEqualToString:@"template_page_1"]){
        FBCleanAirController *vc = [[FBCleanAirController alloc] init];
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([itemModel.shortcut_value isEqualToString:@"template_page_2"]){
        
    }else if([itemModel.shortcut_value isEqualToString:@"template_page_3"]){
        FBOnlineBabysitterController *vc = [[FBOnlineBabysitterController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([itemModel.shortcut_value isEqualToString:@"template_page_4"]){
        FBCookLadyViewController *vc = [[FBCookLadyViewController alloc] init];
        vc.type = 4;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([itemModel.shortcut_value isEqualToString:@"template_page_5"]){
        
    }else if([itemModel.shortcut_value isEqualToString:@"template_page_6"]){
        FBAuntieRecruitmentController *vc = [[FBAuntieRecruitmentController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([itemModel.shortcut_value isEqualToString:@"template_page_7"]){//
        FBCleanAirController *vc = [[FBCleanAirController alloc] init];
        vc.type = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([itemModel.shortcut_value isEqualToString:@"template_page_8"]){
        FBCookLadyViewController *vc = [[FBCookLadyViewController alloc] init];
        vc.type = 8;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
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
        make.bottom.offset(-SafeAreaTabBarHeight);
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
    topImgView.image = [UIImage imageNamed:@"img_home_top_background"];
    [contentView addSubview:topImgView];
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.equalTo(topImgView.mas_width).multipliedBy(1482.0/1125.0);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"云上保姆";
    titleLab.textColor = [UIColor colorWithHex:@"#FFFFFF"];
    titleLab.font = BoldFont(16);
    [contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.offset(StatusBarHeight + 10);
    }];
    
    UIButton *searchBtn = [[UIButton alloc] init];
    [searchBtn setImage:[UIImage imageNamed:@"img_home_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:searchBtn];
    self.searchBtn = searchBtn;
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView.mas_bottom).offset(-40);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(84);
    }];
    
    UIView *bigItemView = [self setupBigItemView];
    [contentView addSubview:bigItemView];
    [bigItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchBtn.mas_bottom).offset(10);
        make.right.offset(-15);
        make.left.equalTo(contentView.mas_centerX).offset(7);
        make.height.equalTo(bigItemView.mas_width).multipliedBy(191.0/165.0);
    }];
    
    UIView *oneLittleItemView = [self setupLittleItemViewWithTag:1];
    [contentView addSubview:oneLittleItemView];
    [oneLittleItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bigItemView);
        make.left.offset(15);
        make.bottom.equalTo(bigItemView.mas_centerY).offset(-8);
        make.right.equalTo(contentView.mas_centerX).offset(-7);
    }];
    
    UIView *twoLittleItemView = [self setupLittleItemViewWithTag:2];
    [contentView addSubview:twoLittleItemView];
    [twoLittleItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneLittleItemView.mas_bottom).offset(15);
        make.left.equalTo(oneLittleItemView);
        make.right.equalTo(oneLittleItemView);
        make.bottom.equalTo(bigItemView).offset(0);
    }];
    
    UIImageView *fireImgView = [[UIImageView alloc] init];
    fireImgView.image = [UIImage imageNamed:@"img_home_fire"];
    [contentView addSubview:fireImgView];
    self.fireImgView = fireImgView;
    [fireImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bigItemView.mas_top).offset(-8);
        make.right.equalTo(bigItemView.mas_right).offset(8);
        make.width.offset(31);
        make.height.offset(37);
    }];
    
    UIView *itemView = [self setupItemBtnView];
    [contentView addSubview:itemView];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bigItemView.mas_bottom).offset(16);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.offset(90);
    }];
    
    UIView *bannerView = [self setupBannerView];
    [contentView addSubview:bannerView];
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(itemView.mas_bottom).offset(16);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.offset(130);
        
        make.bottom.offset(-10);
    }];
    
    //广告图
    UIWindow *window = kKeyWindow;
    FBHomeAdPopView *adPopView = [[FBHomeAdPopView alloc] init];
    adPopView.hidden = YES;
    adPopView.delegate = self;
    [window addSubview:adPopView];
    self.adPopView = adPopView;
    [adPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
}
- (UIView *)setupLittleItemViewWithTag:(int)tag
{
    UIView *rootView = [[UIView alloc] init];
    rootView.layer.cornerRadius = 10;
    rootView.layer.masksToBounds = YES;
    rootView.layer.borderWidth = 1.0;
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.font = BoldFont(18);
    [rootView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(rootView.mas_centerY).offset(-3);
        make.left.offset(15);
    }];
    
    UIImageView *arrowImgView = [[UIImageView alloc] init];
    [rootView addSubview:arrowImgView];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLab);
        make.left.equalTo(titleLab.mas_right).offset(2);
        make.width.offset(15);
        make.height.offset(15);
    }];
    
    UILabel *subtitleLab = [[UILabel alloc] init];
    subtitleLab.font = MediumFont(13);
    [rootView addSubview:subtitleLab];
    [subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rootView.mas_centerY).offset(3);
        make.left.offset(15);
    }];
    
    UIButton *itemBtn = [[UIButton alloc] init];
    [rootView addSubview:itemBtn];
    [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootView);
    }];
    
    if(tag == 1){
        rootView.backgroundColor = [UIColor colorWithHex:@"#F8FEEC"];
        rootView.layer.borderColor = [UIColor colorWithHex:@"#9DD318"].CGColor;
        titleLab.text = @"育儿嫂";
        subtitleLab.text = @"专业护理 育儿宝贝";
        titleLab.textColor = [UIColor colorWithHex:@"#9DD318"];
        arrowImgView.image = [UIImage imageNamed:@"img_home_green_arrow"];
        subtitleLab.textColor = [UIColor colorWithHex:@"#666A77"];
        [itemBtn addTarget:self action:@selector(oneLittleItemBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.littleItemOneTitleLab = titleLab;
        self.littleItemOneSubTitleLab = subtitleLab;
    }else if (tag == 2){
        rootView.backgroundColor = [UIColor colorWithHex:@"#ECF6FF"];
        rootView.layer.borderColor = [UIColor colorWithHex:@"#4971FF"].CGColor;
        titleLab.text = @"做饭阿姨";
        subtitleLab.text = @"为全家 烹饪佳肴";
        titleLab.textColor = [UIColor colorWithHex:@"#4971FF"];
        arrowImgView.image = [UIImage imageNamed:@"img_home_blue_arrow"];
        subtitleLab.textColor = [UIColor colorWithHex:@"#666A77"];
        [itemBtn addTarget:self action:@selector(twoLittleItemBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.littleItemTwoTitleLab = titleLab;
        self.littleItemTwoSubTitleLab = subtitleLab;
    }
    
    return rootView;
}
- (UIView *)setupBigItemView
{
    UIView *rootView = [[UIView alloc] init];
    
    UIImageView *backgroundImgView = [[UIImageView alloc] init];
    backgroundImgView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImgView.image = [UIImage imageNamed:@"img_home_bigitem"];
    [rootView addSubview:backgroundImgView];
    self.bigItemBackgroundImgView = backgroundImgView;
    [backgroundImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootView);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"找月嫂";
    titleLab.font = BoldFont(18);
    titleLab.textColor = [UIColor colorWithHex:@"#FF8D3B"];
    [rootView addSubview:titleLab];
    self.bigItemTitleLab = titleLab;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(15);
    }];
    
    UILabel *goLab = [[UILabel alloc] init];
    goLab.text = @"去挑选";
    goLab.font = BoldFont(10);
    goLab.textColor = [UIColor colorWithHex:@"#FF8D3B"];
    goLab.backgroundColor = [UIColor colorWithHex:@"#FFFFFF"];
    goLab.layer.cornerRadius = 12;
    goLab.layer.masksToBounds = YES;
    goLab.textAlignment = NSTextAlignmentCenter;
    [rootView addSubview:goLab];
    self.bigItemGoLab = goLab;
    [goLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(2);
        make.left.offset(15);
        make.width.offset(60);
        make.height.offset(24);
    }];
    
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.text = @"护理精细\n价格透明";
    contentLab.font = MediumFont(13);
    contentLab.textColor = [UIColor colorWithHex:@"#FF8D3B"];
    contentLab.numberOfLines = 0;
    [rootView addSubview:contentLab];
    self.bigItemContentLab = contentLab;
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.bottom.offset(-35);
    }];
    
    UIButton *itemBtn = [[UIButton alloc] init];
    [itemBtn addTarget:self action:@selector(bigItemBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:itemBtn];
    [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootView);
    }];
    
    return rootView;
}
- (UIView *)setupItemBtnView
{
    UIView *rootView = [[UIView alloc] init];
    
    UIView *oneBtn = [self setupItemBtnWithTag:1];
    [rootView addSubview:oneBtn];
    [oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.bottom.offset(0);
        make.width.equalTo(rootView.mas_width).multipliedBy(0.25);
    }];
    
    UIView *twoBtn = [self setupItemBtnWithTag:2];
    [rootView addSubview:twoBtn];
    [twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.equalTo(oneBtn.mas_right).offset(0);
        make.bottom.offset(0);
        make.width.equalTo(oneBtn);
    }];
    
    UIView *threeBtn = [self setupItemBtnWithTag:3];
    [rootView addSubview:threeBtn];
    [threeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.equalTo(twoBtn.mas_right).offset(0);
        make.bottom.offset(0);
        make.width.equalTo(oneBtn);
    }];
    
    UIView *fourBtn = [self setupItemBtnWithTag:4];
    [rootView addSubview:fourBtn];
    [fourBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.equalTo(threeBtn.mas_right).offset(0);
        make.bottom.offset(0);
        make.width.equalTo(oneBtn);
    }];
    
    return rootView;
}
- (UIView *)setupItemBtnWithTag:(int)tag
{
    UIView *rootView = [[UIView alloc] init];
    
    NSString *text = @"";
    NSString *img = @"";
    if(tag == 1){
        text = @"参加学习";
        img = @"img_home_join_stude";
    }else if(tag == 2){
        text = @"阿姨招募";
        img = @"img_home_ayizm";
    }else if(tag == 3){
        text = @"清洗空调";
        img = @"img_home_clear";
    }else if(tag == 4){
        text = @"甲醛治理";
        img = @"img_home_jiaquan";
    }
    
    UIImageView *iconImgView = [[UIImageView alloc] init];
    iconImgView.image = [UIImage imageNamed:img];
    [rootView addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootView);
        make.top.offset(9);
        make.width.offset(40);
        make.height.offset(40);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = text;
    titleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    titleLab.font = RegularFont(12);
    [rootView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rootView);
        make.top.equalTo(iconImgView.mas_bottom).offset(10);
    }];
    
    UIButton *itemBtn = [[UIButton alloc] init];
    itemBtn.tag = tag;
    [itemBtn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:itemBtn];
    [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootView);
    }];
    
    if(tag == 1){
        self.horOneTitleLab = titleLab;
        self.horOneImgView = iconImgView;
    }else if(tag == 2){
        self.horTwoTitleLab = titleLab;
        self.horTwoImgView = iconImgView;
    }else if(tag == 3){
        self.horThreeTitleLab = titleLab;
        self.horThreeImgView = iconImgView;
    }else if(tag == 4){
        self.horFourTitleLab = titleLab;
        self.horFourImgView = iconImgView;
    }
    
    return rootView;
}
- (UIView *)setupBannerView
{
    UIView *rootView = [[UIView alloc] init];
    rootView.layer.cornerRadius = 10;
    rootView.layer.masksToBounds = YES;
    
    _viewBanner = [HW3DBannerView initWithFrame:CGRectMake(0, 0, KScreenW - 16.0*2.0, 130) imageSpacing:0 imageWidth:KScreenW - 16.0*2.0];
    _viewBanner.backgroundColor = [UIColor whiteColor];
    _viewBanner.initAlpha = 1; // 设置两边卡片的透明度
    _viewBanner.imageRadius = 0; // 设置卡片圆角
    _viewBanner.imageHeightPoor = 0; // 设置中间卡片与两边卡片的高度差
    _viewBanner.showPageControl = YES;// 不显示PageControl
    _viewBanner.autoScroll = YES;//关闭自动滚动
    _viewBanner.placeHolderImage = [UIImage imageNamed:@"home_img_banner"];

    _viewBanner.contentMode = UIViewContentModeScaleAspectFill;//图片填充方式
    [rootView addSubview:_viewBanner];
    
    _viewBanner.data = @[
        
    ];
    
    
    MJWeakSelf;
    _viewBanner.scrollImageBlock = ^(NSInteger currentIndex) {        
    };
    _viewBanner.clickImageBlock = ^(NSInteger currentIndex) {
        FBHomeConfItemModel *itemModel = [weakSelf.homeConfModel.banners objectAtIndex:currentIndex];
        [weakSelf clickItemWithModel:itemModel];
        
        if(currentIndex == 0){
            [FBUMManager event:@"banner_button_1" attributes:@{}];
        }else if(currentIndex == 1){
            [FBUMManager event:@"banner_button_2" attributes:@{}];
        }else if(currentIndex == 2){
            [FBUMManager event:@"banner_button_3" attributes:@{}];
        }else if(currentIndex == 3){
            [FBUMManager event:@"banner_button_4" attributes:@{}];
        }
    };
    
    return rootView;
}
@end
