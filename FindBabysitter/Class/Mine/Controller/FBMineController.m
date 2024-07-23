//
//  FBMineController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/1.
//

#import "FBMineController.h"
#import "FBMineCell.h"
#import "FBAboutUsController.h"
#import "FBFeedbackController.h"
#import "FBUserListController.h"
#import "FBMessageController.h"
@interface FBMineController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)UILabel *phoneLab;
@end

@implementation FBMineController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mainTableView reloadData];
    
    //手机号展示
    NSString *originalNumber = kUserInfoModel.mobile;
    NSString *hiddenNumber = [self hideMiddleDigitsOfPhoneNumber:originalNumber];
    if(hiddenNumber.length > 0){
        self.phoneLab.text = hiddenNumber;
    }else{
        self.phoneLab.text = @"--";
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupUI];
    [self requestData];
}
#pragma mark - data
- (void)requestData
{
    NSArray *array = @[
        @{@"ID":@"message",@"icon":@"img_mine_message",@"title":@"消息中心"},
        @{@"ID":@"feedback",@"icon":@"img_mine_feedback",@"title":@"意见反馈"},
        @{@"ID":@"about",@"icon":@"img_mine_about",@"title":@"关于我们"},
        @{@"ID":@"list",@"icon":@"img_min_list",@"title":@"个人信息收集清单"},
    ];
    self.dataArray = array;
    [self.mainTableView reloadData];
}
#pragma mark - priv
- (NSString *)hideMiddleDigitsOfPhoneNumber:(NSString *)phoneNumber {
    if (phoneNumber.length >= 11) {
        NSString *prefix = [phoneNumber substringToIndex:3];
        NSString *suffix = [phoneNumber substringFromIndex:7];
        NSString *hiddenPart = @"****";
        return [NSString stringWithFormat:@"%@%@%@", prefix, hiddenPart, suffix];
    } else {
        // Handle invalid phone number length
        return phoneNumber;
    }
}
#pragma mark - click
- (void)logoutBtnClick
{
    //本地token赋值
    [kUserInfoModel nullUserInfoData];
    self.phoneLab.text = @"--";
    [self showHint:@"退出成功"];
    [self.mainTableView reloadData];
}
- (void)headerBtnClick
{
    if(kUserInfoModel.token.length == 0){//未登录
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate oneLittleItemBtnClick];
    }else{
        
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
//    NSString *ID = [dict string:@"ID"];
    NSString *icon = [dict string:@"icon"];
    NSString *title = [dict string:@"title"];
    
    FBMineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.iconImgView.image = [UIImage imageNamed:icon];
    cell.titleLab.text = title;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    @[
//        @{@"ID":@"message",@"icon":@"img_mine_message",@"title":@"消息中心"},
//        @{@"ID":@"feedback",@"icon":@"img_mine_feedback",@"title":@"意见反馈"},
//        @{@"ID":@"about",@"icon":@"img_mine_about",@"title":@"关于我们"},
//        @{@"ID":@"list",@"icon":@"img_min_list",@"title":@"个人信息收集清单"},
//    ]
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    NSString *ID = [dict string:@"ID"];
    if([ID isEqualToString:@"message"]){
        FBMessageController *vc = [[FBMessageController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([ID isEqualToString:@"feedback"]){
        FBFeedbackController *vc = [[FBFeedbackController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([ID isEqualToString:@"about"]){
        FBAboutUsController *vc = [[FBAboutUsController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if([ID isEqualToString:@"list"]){
//        FBUserListController *vc = [[FBUserListController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
        FBWebViewController *vc = [[FBWebViewController alloc] init];
        vc.urlStr = UserCollectionList;
        vc.navTitle = @"个人信息收集清单";
        [[FBHelper getCurrentController].navigationController pushViewController:vc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.headerView){
        return self.headerView;
    }
    UIView *headerView = [self setupHeaderView];
    self.headerView = headerView;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 90;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(self.footerView){
        if(kUserInfoModel.token.length == 0){//未登录
            self.footerView.hidden = YES;
        }else{
            self.footerView.hidden = NO;
        }
        return self.footerView;
    }
    UIView *rootView = [self setupFooterView];
    self.footerView = rootView;
    if(kUserInfoModel.token.length == 0){//未登录
        self.footerView.hidden = YES;
    }else{
        self.footerView.hidden = NO;
    }
    return rootView;
}
#pragma mark - UI
- (void)setupUI
{
    self.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[FBMineCell class] forCellReuseIdentifier:@"cell"];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    self.mainTableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(StatusBarHeight + 44);
        make.left.offset(0);
        make.bottom.offset(-SafeAreaTabBarHeight);
        make.right.offset(0);
    }];
}
- (UIView *)setupHeaderView
{
    UIView *rootView = [[UIView alloc] init];
    rootView.backgroundColor = [UIColor clearColor];
    
    UIImageView *headerImgView = [[UIImageView alloc] init];
    headerImgView.image = [UIImage imageNamed:@"img_headr_placher"];
    [rootView addSubview:headerImgView];
    [headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rootView);
        make.left.offset(30);
        make.width.offset(60);
        make.height.offset(60);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    titleLab.text = @"--";
    titleLab.font = RegularFont(24);
    [rootView addSubview:titleLab];
    self.phoneLab = titleLab;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(rootView.mas_centerY).offset(10);
        make.left.equalTo(headerImgView.mas_right).offset(10);
    }];
    
    
    UILabel *subtitleLab = [[UILabel alloc] init];
    subtitleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    subtitleLab.text = @"Hi~欢迎来到云上保姆";
    subtitleLab.font = MediumFont(14);
    [rootView addSubview:subtitleLab];
    [subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rootView.mas_centerY).offset(5);
        make.left.equalTo(titleLab);
    }];
    
    UIButton *headerBtn = [[UIButton alloc] init];
    [headerBtn addTarget:self action:@selector(headerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:headerBtn];
    [headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootView);
    }];
    
    return rootView;
}
- (UIView *)setupFooterView
{
    UIView *rootView = [[UIView alloc] init];
    rootView.backgroundColor = [UIColor clearColor];
    
    UIButton *logoutBtn = [[UIButton alloc] init];
    logoutBtn.backgroundColor = [UIColor colorWithHex:@"#F3F7FB"];
    logoutBtn.layer.cornerRadius = 22;
    logoutBtn.layer.masksToBounds = YES;
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor colorWithHex:@"#666A77"] forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = BoldFont(14);
    [logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:logoutBtn];
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.bottom.offset(-10);
        make.right.offset(-16);
        make.height.offset(44);
    }];
    
    return rootView;
}
@end
