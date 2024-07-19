//
//  FBDistributionController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/2.
//

#import "FBDistributionController.h"
#import "FBDistributionImageCell.h"
#import "FBCreatAddressPopView.h"
@interface FBDistributionController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FBCreatAddressPopViewDelegate>
@property(nonatomic,strong)UICollectionView *mainCollectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)FBCreatAddressPopView *addressPopView;

@property(nonatomic,strong)UILabel *contentLab;
@property(nonatomic,strong)UILabel *namePhoneLab;
@property(nonatomic,strong)UILabel *adressLab;
@property(nonatomic,strong)UILabel *tipLab;
@property(nonatomic,strong)UILabel *liuLianTypeLab;
@property(nonatomic,strong)UILabel *waiMaiTypeLab;
@end

@implementation FBDistributionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self setupUI];
    [self requestData];
}
#pragma mark - data
- (void)requestData
{
//    @property(nonatomic,strong)UILabel *contentLab;
//    @property(nonatomic,strong)UILabel *namePhoneLab;
//    @property(nonatomic,strong)UILabel *adressLab;
//    @property(nonatomic,strong)UILabel *tipLab;
//    @property(nonatomic,strong)UILabel *liuLianTypeLab;
//    @property(nonatomic,strong)UILabel *waiMaiTypeLab;
    FBTemplateFiveModel *model = [FBHomeConfManager shareInstance].templateModel.template_page_5;

    self.contentLab.text = model.service_content;
    self.namePhoneLab.text = @"   ";
    self.adressLab.text = @"   ";
    self.tipLab.hidden = NO;
    self.liuLianTypeLab.text = self.selectItemModel.title;
    self.waiMaiTypeLab.text = @"外卖配送";
    
    [self.dataArray removeAllObjects];
    for (FBTemplateFiveImgModel *itemModel in model.qualification_desc) {
        if(itemModel.img_url.length > 0){
            [self.dataArray addObject:itemModel.img_url];
        }
    }
    [self.mainCollectionView reloadData];
    
    //计算collectionView高度
    CGFloat itemWidth = (KScreenW - 33*2.0 - 10)/2.0;
    CGFloat itemHeight = 80/150.0 * itemWidth;
    int hangNumber = ceilf(self.dataArray.count/2.0);
    CGFloat collectionHeight = hangNumber * itemHeight + (hangNumber - 1)*10;
    [self.mainCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(collectionHeight);
    }];
}
- (void)requestSumitData
{
    /*
     contacts  联系人
     sex   "先生", "女士"
     mobile 手机号
     receive_address  收货地址"
     wechat_number  微信号
     remarks 补充说明
     */
    NSString *sex = @"";
    if(self.addressPopView.recordSex == 1){
        sex = @"女士";
    }else if(self.addressPopView.recordSex == 2){
        sex = @"先生";
    }
    
    NSMutableDictionary *extra_data = [[NSMutableDictionary alloc] init];
    [extra_data setValue:self.addressPopView.nameTextField.text forKey:@"contacts"];
    [extra_data setValue:sex forKey:@"sex"];
    [extra_data setValue:self.addressPopView.mobileTextField.text forKey:@"mobile"];
    [extra_data setValue:self.addressPopView.contentTextField.text forKey:@"receive_address"];
    [extra_data setValue:self.addressPopView.wechatTextField.text forKey:@"wechat_number"];
    [extra_data setValue:self.addressPopView.contentTextField.text forKey:@"remarks"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"template_page_5" forKey:@"template_page"];
    [dict setValue:extra_data.mj_JSONString forKey:@"extra_data"];
    
    [[FBHelper getCurrentController] showHudInView:[FBHelper getCurrentController].view hint:@""];
    [FBUMManager event:@"template_page_button_5" attributes:@{}];
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
- (void)addressBtnClick
{
    self.addressPopView.hidden = NO;
}
- (void)contactBtnClick
{
    
}
- (void)sureBtnClick
{
    if([FBHomeConfManager shareInstance].templateModel.template_page_5.is_login == 1){//需要登录
        if([FBUserInfoModel shareInstance].token.length > 0){
            [self requestSumitData];
        }else{
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate oneLittleItemBtnClick];
        }
    }else{
        FBWebViewController *webvc = [[FBWebViewController alloc] init];
        webvc.navTitle = @"";
        webvc.urlStr = [FBHomeConfManager shareInstance].templateModel.template_page_5.url;
        [self.navigationController pushViewController:webvc animated:YES];
    }
}
#pragma mark - 弹窗代理
//选择地址弹窗确认
- (void)creatAddressPopViewSureClick
{
    self.addressPopView.hidden = YES;
    
    self.namePhoneLab.hidden = NO;
    self.adressLab.hidden = NO;
    self.tipLab.hidden = YES;
    
    self.namePhoneLab.text = [NSString stringWithFormat:@"%@ %@",self.addressPopView.nameTextField.text,self.addressPopView.mobileTextField.text];
    self.adressLab.text = self.addressPopView.contentTextField.text;
}
#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *imgUrl = [self.dataArray objectAtIndex:indexPath.row];
    
    FBDistributionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.iconImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 33, 0, 33);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (KScreenW - 33*2.0 - 10)/2.0;
    CGFloat height = 80/150.0 * width;
    return CGSizeMake(width, height);
}
#pragma mark - UI
- (void)setupUI
{
    self.title = @"预约配送";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.layer.cornerRadius = 27;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:@"提交需求，请联系我" forState:UIControlStateNormal];
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
        
        make.bottom.offset(-20-SafeAreaBottomHeight);
    }];
    
    CGFloat textWidth = 192;
    CGFloat sureWidth = KScreenW - 16*2.0;
    CGFloat textLeft = (sureWidth - textWidth)/2.0;
    sureBtn.titleEdgeInsets = UIEdgeInsetsMake(0, textLeft-10, 0, textLeft);
    sureBtn.imageEdgeInsets = UIEdgeInsetsMake(0, textLeft + textWidth, 0, 0);
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(StatusBarHeight + 44);
        make.left.offset(0);
        make.bottom.equalTo(sureBtn.mas_top).offset(0);
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
    
    UIView *addressView = [self setupAdressView];
    [contentView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
    }];
    
    UIView *oneHangView = [self setupTextHangViewWithTag:1];
    [contentView addSubview:oneHangView];
    [oneHangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressView.mas_bottom).offset(10);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(35);
    }];
    
    UIView *twoHangView = [self setupTextHangViewWithTag:2];
    [contentView addSubview:twoHangView];
    [twoHangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneHangView.mas_bottom).offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(35);
    }];
    
    UIButton *contactBtn = [[UIButton alloc] init];
    contactBtn.layer.cornerRadius = 22;
    contactBtn.layer.masksToBounds = YES;
    contactBtn.layer.borderColor = [UIColor colorWithHex:@"#4971FF"].CGColor;
    contactBtn.layer.borderWidth = 1;
    contactBtn.backgroundColor = [UIColor colorWithHex:@"#ECF6FF"];
    [contactBtn setTitle:@"联系我确认配送时间" forState:UIControlStateNormal];
    [contactBtn setTitleColor:[UIColor colorWithHex:@"#4971FF"] forState:UIControlStateNormal];
    contactBtn.titleLabel.font = MediumFont(14);
    [contactBtn addTarget:self action:@selector(contactBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:contactBtn];
    [contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoHangView.mas_bottom).offset(10);
        make.left.offset(16);
        make.right.offset(-16);
        make.height.offset(44);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#E2E7ED"];
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contactBtn.mas_bottom).offset(16);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.offset(1);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"服务说明";
    titleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    titleLab.font = BoldFont(16);
    [contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(20);
        make.left.offset(30);
    }];
    
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.text = @"实际服务由第三方服务商独立完成，需求提交后，会由该服务商与您联系，并提供销售与配送服务。";
    contentLab.textColor = [UIColor colorWithHex:@"#16171A"];
    contentLab.font = MediumFont(14);
    contentLab.numberOfLines = 0;
    [contentView addSubview:contentLab];
    self.contentLab = contentLab;
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(10);
        make.left.offset(30);
        make.right.offset(-30);
    }];
    
    UILabel *onetitleLab = [[UILabel alloc] init];
    onetitleLab.text = @"资质说明";
    onetitleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    onetitleLab.font = BoldFont(16);
    [contentView addSubview:onetitleLab];
    [onetitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLab.mas_bottom).offset(15);
        make.left.offset(30);
    }];
    
//    UIView *imageRootView = [[UIView alloc] init];
//    imageRootView.backgroundColor = [UIColor yellowColor];
//    [contentView addSubview:imageRootView];
//    self.imageRootView = imageRootView;
//    [imageRootView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(onetitleLab.mas_bottom).offset(15);
//        make.left.offset(0);
//        make.right.offset(0);
//        make.height.offset(160);
//        
//        make.bottom.offset(-10);
//    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[FBDistributionImageCell class] forCellWithReuseIdentifier:@"cell"];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.scrollEnabled = NO;
    [contentView addSubview:collectionView];
    self.mainCollectionView = collectionView;
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(onetitleLab.mas_bottom).offset(15);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(160);

        make.bottom.offset(-10);
    }];
    
    
    FBCreatAddressPopView *addressPopView = [[FBCreatAddressPopView alloc] init];
    addressPopView.hidden = YES;
    addressPopView.delegate = self;
    [self.view addSubview:addressPopView];
    self.addressPopView = addressPopView;
    [addressPopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (UIView *)setupAdressView
{
    UIView *rootView = [[UIView alloc] init];
    
    UILabel *namePhoneLab = [[UILabel alloc] init];
    namePhoneLab.text = @"   ";
    namePhoneLab.textColor = [UIColor colorWithHex:@"#16171A"];
    namePhoneLab.font = MediumFont(14);
    [rootView addSubview:namePhoneLab];
    self.namePhoneLab = namePhoneLab;
    [namePhoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(30);
    }];
    
    UILabel *adressLab = [[UILabel alloc] init];
    adressLab.text = @"   ";
    adressLab.textColor = [UIColor colorWithHex:@"#16171A"];
    adressLab.font = BoldFont(16);
    adressLab.numberOfLines = 0;
    [rootView addSubview:adressLab];
    self.adressLab = adressLab;
    [adressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(namePhoneLab.mas_bottom).offset(5);
        make.left.offset(30);
        make.right.offset(-80);
    }];
    
    UIImageView *lineView = [[UIImageView alloc] init];
    lineView.image = [UIImage imageNamed:@"img_huawen_line"];
    lineView.contentMode = UIViewContentModeScaleAspectFill;
    [rootView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adressLab.mas_bottom).offset(14);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(4);
        
        make.bottom.offset(0);
    }];
    
    UIImageView *arrowImgView = [[UIImageView alloc] init];
    arrowImgView.image = [UIImage imageNamed:@"img_arrow_right_black"];
    [rootView addSubview:arrowImgView];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rootView);
        make.right.offset(-30);
        make.width.offset(12);
        make.height.offset(16);
    }];
    
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.text = @"请填写收货地址";
    tipLab.textColor = [UIColor colorWithHex:@"#16171A"];
    tipLab.font = BoldFont(16);
    tipLab.hidden = NO;
    [rootView addSubview:tipLab];
    self.tipLab = tipLab;
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rootView);
        make.left.offset(30);
    }];
    
    UIButton *addressBtn = [[UIButton alloc] init];
    [addressBtn addTarget:self action:@selector(addressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rootView addSubview:addressBtn];
    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rootView);
    }];
    
    return rootView;
}
- (UIView *)setupTextHangViewWithTag:(int)tag
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
    
    UILabel *subtitleLab = [[UILabel alloc] init];
    subtitleLab.text = @"副标题";
    subtitleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    subtitleLab.font = MediumFont(14);
    [rootView addSubview:subtitleLab];
    [subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rootView);
        make.right.offset(-30);
    }];
    
    if(tag == 1){
        titleLab.text = @"榴莲品种";
        subtitleLab.text = @"黑刺榴莲";
        self.liuLianTypeLab = subtitleLab;
    }else if(tag == 2){
        titleLab.text = @"配送方式";
        subtitleLab.text = @"外卖配送";
        self.waiMaiTypeLab = subtitleLab;
    }
    
    return rootView;
}
@end
