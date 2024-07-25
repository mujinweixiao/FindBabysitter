//
//  FBFlashController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/1.
//

#import "FBFlashController.h"
#import "FBFlashCell.h"
#import "FBDistributionController.h"
@interface FBFlashController ()<UITableViewDelegate,UITableViewDataSource,BMKMapViewDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)UILabel *supportAreaTitleLab;
@property(nonatomic,strong)UILabel *supportSubTitleLab;
@property(nonatomic,strong)BMKMapView *mapView;



@property(nonatomic,strong)FBTemplateFiveModel *fiveModel;
@end

@implementation FBFlashController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    [self dealDataToUI];
    
    if([FBHomeConfManager shareInstance].homeConfModel.menu_button.count == 2){
        FBHomeConfItemModel *first = [[FBHomeConfManager shareInstance].homeConfModel.menu_button firstObject];
        FBHomeConfItemModel *last = [[FBHomeConfManager shareInstance].homeConfModel.menu_button lastObject];

        self.title = first.shortcut_title;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupUI];
}
#pragma mark - priv
- (void)dealDataToUI
{
    FBTemplateFiveModel *model = [FBHomeConfManager shareInstance].templateModel.template_page_5;
    self.title = model.title;
    self.fiveModel = model;
    [self.mainTableView reloadData];
}
#pragma mark - data
#pragma mark - click
- (void)sureBtnClick
{
    FBTemplateFiveTypeModel *selectItemModel;
    for (int i = 0; i < self.fiveModel.variety_types.count; i ++) {
        FBTemplateFiveTypeModel *itemModel = [self.fiveModel.variety_types objectAtIndex:i];
        if(itemModel.is_default == 1){
            selectItemModel = itemModel;
        }
    }
    if(!selectItemModel){
        [self showHint:@"请选择选项"];
        return;
    }
    
    FBDistributionController *vc = [[FBDistributionController alloc] init];
    vc.selectItemModel = selectItemModel;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fiveModel.variety_types.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FBTemplateFiveTypeModel *model = [self.fiveModel.variety_types objectAtIndex:indexPath.row];
    
    FBFlashCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.titleLab.text = model.title;
    cell.subtitleLab.text = model.desc;
    //img_select_blue img_select_gray
    if(model.is_default == 1){
        cell.rootView.backgroundColor = [UIColor colorWithHex:@"#F3F7FB"];
        cell.selectImgView.image = [UIImage imageNamed:@"img_select_blue"];
    }else{
        cell.rootView.backgroundColor = [UIColor clearColor];
        cell.selectImgView.image = [UIImage imageNamed:@"img_select_gray"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i = 0; i < self.fiveModel.variety_types.count; i ++) {
        FBTemplateFiveTypeModel *itemModel = [self.fiveModel.variety_types objectAtIndex:i];
        if(i == indexPath.row){
            itemModel.is_default = 1;
        }else{
            itemModel.is_default = 2;
        }
    }
    [self.mainTableView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.headerView){
        self.supportAreaTitleLab.text = self.fiveModel.supporting_regions;
        self.supportSubTitleLab.text = self.fiveModel.desc;
        return self.headerView;
    }
    UIView *headerView = [self setupHeaderView];
    self.headerView = headerView;
    self.supportAreaTitleLab.text = self.fiveModel.supporting_regions;
    self.supportSubTitleLab.text = self.fiveModel.desc;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 227;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(self.footerView){
        return self.footerView;
    }
    UIView *rootView = [self setupFooterView];
    self.footerView = rootView;
    return rootView;
}

#pragma mark - UI
- (void)setupUI
{
//    self.title = @"闪送";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.layer.cornerRadius = 27;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:@"预约配送" forState:UIControlStateNormal];
    [sureBtn setImage:[UIImage imageNamed:@"img_arrow_white_right"] forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHex:@"#FFFFFF"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = MediumFont(20);
    sureBtn.backgroundColor = [UIColor colorWithHex:@"#4971FF"];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.right.offset(-16);
        make.height.offset(54);
        
        make.bottom.offset(-SafeAreaTabBarHeight-10);
    }];
    
    CGFloat textWidth = 102;
    CGFloat sureWidth = KScreenW - 16*2.0;
    CGFloat textLeft = (sureWidth - textWidth)/2.0;
    sureBtn.titleEdgeInsets = UIEdgeInsetsMake(0, textLeft-20, 0, textLeft);
    sureBtn.imageEdgeInsets = UIEdgeInsetsMake(0, textLeft + textWidth - 60, 0, 0);
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[FBFlashCell class] forCellReuseIdentifier:@"cell"];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    self.mainTableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(StatusBarHeight + 44);
        make.left.offset(0);
        make.bottom.equalTo(sureBtn.mas_top).offset(0);
        make.right.offset(0);
    }];
}
- (UIView *)setupHeaderView
{
    UIView *rootView = [[UIView alloc] init];
    rootView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"本服务目前仅支持北京地区";
    titleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    titleLab.font = BoldFont(16);
    [rootView addSubview:titleLab];
    self.supportAreaTitleLab = titleLab;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(14);
        make.left.offset(30);
    }];
    
    UILabel *subtitleLab = [[UILabel alloc] init];
    subtitleLab.text = @"其他城市会在近期陆续开放，敬请期待～";
    subtitleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    subtitleLab.font = MediumFont(14);
    subtitleLab.numberOfLines = 0;
    [rootView addSubview:subtitleLab];
    self.supportSubTitleLab = subtitleLab;
    [subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(5);
        make.left.offset(30);
        make.right.offset(-16);
    }];
    
    
    return rootView;
}
- (UIView *)setupFooterView
{
    UIView *rootView = [[UIView alloc] init];
    rootView.backgroundColor = [UIColor clearColor];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#E2E7ED"];
    [rootView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.offset(1);
    }];
    
    UIView *mapTotalView = [[UIView alloc] init];
    mapTotalView.layer.cornerRadius = 10;
    mapTotalView.layer.masksToBounds = YES;
    [rootView addSubview:mapTotalView];
    [mapTotalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(20);
        make.left.offset(30);
        make.right.offset(-30);
        make.bottom.offset(-30);
    }];
    
    // 请求定位权限
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    [locationManager requestWhenInUseAuthorization];

    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, KScreenW - 60, 227 - 50)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    [mapTotalView addSubview:_mapView];
    
    return rootView;
}
@end
