//
//  FBFlashController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/1.
//

#import "FBFlashController.h"
#import "FBFlashCell.h"
#import "FBDistributionController.h"
#import <WebKit/WebKit.h>

@interface FBFlashController ()<UITableViewDelegate,UITableViewDataSource,BMKMapViewDelegate,BMKLocationManagerDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
//判断网页是否已经加载过
@property(nonatomic,assign)BOOL webLoadSComplete;

@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)UILabel *supportAreaTitleLab;
@property(nonatomic,strong)UILabel *supportSubTitleLab;

@property(nonatomic,strong)BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationManager *locationManager; //定位对象
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象


@property(nonatomic,strong)FBTemplateFiveModel *fiveModel;
@end

@implementation FBFlashController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    [self dealDataToUI];
    [FBHelper getIdfa];

    if([FBHomeConfManager shareInstance].homeConfModel.menu_button.count == 2){
        FBHomeConfItemModel *first = [[FBHomeConfManager shareInstance].homeConfModel.menu_button firstObject];
//        FBHomeConfItemModel *last = [[FBHomeConfManager shareInstance].homeConfModel.menu_button lastObject];

        self.title = first.shortcut_title;
        
        
        if([first.shortcut_type isEqualToString:@"2"]){//网页
            self.webView.hidden = NO;
            //判断展示网页还是模版
            if(!self.webLoadSComplete){
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:first.shortcut_value]]];
                self.webLoadSComplete = YES;
            }
        }else{
            self.webView.hidden = YES;
        }
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
#pragma mark - webviewdelegate
// KVO 监听 estimatedProgress 属性的变化
- (void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context {
   if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
       [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
   }
}

// WKNavigationDelegate 代理方法，当页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
   self.progressView.hidden = NO;
}

// WKNavigationDelegate 代理方法，当页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
   self.progressView.hidden = YES;
}

// 移除 KVO 监听
- (void)dealloc {
   [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
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
    
    //网页view
    WKWebView *webView = [[WKWebView alloc] init];
    webView.navigationDelegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    webView.hidden = YES;
    [self.view addSubview:webView];
    self.webView = webView;
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 创建 UIProgressView
   self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, StatusBarHeight + 44, self.view.frame.size.width, 2)];
    self.progressView.hidden = YES;
   [self.view addSubview:self.progressView];

   // 监听 WKWebView 的 estimatedProgress 属性
   [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
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
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, KScreenW - 60, 227 - 50)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
//    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    _mapView.zoomLevel = 15;
    [mapTotalView addSubview:_mapView];
    
    //开启定位服务
    //连续定位
//    [self.locationManager startUpdatingLocation];
    //单次定位
    [self.locationManager requestLocationWithReGeocode:NO withNetworkState:NO completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if(error == nil){
            self.userLocation.location = location.location;
            
            //实现该方法，否则定位图标不出现
            [self.mapView updateLocationData:self.userLocation];
            [self.mapView setCenterCoordinate:location.location.coordinate];
        }
    }];
    [self.locationManager startUpdatingHeading];
    //显示定位图层
    _mapView.showsUserLocation = YES;
    
    return rootView;
}
#pragma mark - BMKLocationManagerDelegate
/**
 @brief 当定位发生错误时，会调用代理的此方法
 @param manager 定位 BMKLocationManager 类
 @param error 返回的错误，参考 CLError
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error {
    NSLog(@"定位失败");
}

/**
 @brief 该方法为BMKLocationManager提供设备朝向的回调方法
 @param manager 提供该定位结果的BMKLocationManager类的实例
 @param heading 设备的朝向结果
 */
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    if (!heading) {
        return;
    }
    NSLog(@"用户方向更新");
    
    self.userLocation.heading = heading;
    [_mapView updateLocationData:self.userLocation];
}

/**
 @brief 连续定位回调函数
 @param manager 定位 BMKLocationManager 类
 @param location 定位结果，参考BMKLocation
 @param error 错误信息。
 */
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
    if (error) {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    }
    if (!location) {
        return;
    }
    
    self.userLocation.location = location.location;
    
    //实现该方法，否则定位图标不出现
    [_mapView updateLocationData:self.userLocation];
}

/**
 *  @brief 为了适配app store关于新的后台定位的审核机制（app store要求如果开发者只配置了使用期间定位，则代码中不能出现申请后台定位的逻辑），当开发者在plist配置NSLocationAlwaysUsageDescription或者NSLocationAlwaysAndWhenInUseUsageDescription时，需要在该delegate中调用后台定位api：[locationManager requestAlwaysAuthorization]。开发者如果只配置了NSLocationWhenInUseUsageDescription，且只有使用期间的定位需求，则无需在delegate中实现逻辑。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param locationManager 系统 CLLocationManager 类 。
 *  @since 1.6.0
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager doRequestAlwaysAuthorization:(CLLocationManager * _Nonnull)locationManager {
    [locationManager requestAlwaysAuthorization];
}

#pragma mark - Lazy loading
- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        //初始化BMKLocationManager类的实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置定位管理类实例的代理
        _locationManager.delegate = self;
        //设定定位坐标系类型，默认为 BMKLocationCoordinateTypeGCJ02
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设定定位精度，默认为 kCLLocationAccuracyBest
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设定定位类型，默认为 CLActivityTypeAutomotiveNavigation
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //指定定位是否会被系统自动暂停，默认为NO
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        /**
         是否允许后台定位，默认为NO。只在iOS 9.0及之后起作用。
         设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
         由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
         */
        _locationManager.allowsBackgroundLocationUpdates = NO;
        /**
         指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
         注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
         后开始计算。
         */
        _locationManager.locationTimeout = 10;
    }
    return _locationManager;
}

- (BMKUserLocation *)userLocation {
    if (!_userLocation) {
        //初始化BMKUserLocation类的实例
        _userLocation = [[BMKUserLocation alloc] init];
    }
    return _userLocation;
}

@end
