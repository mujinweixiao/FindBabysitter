//
//  FBHomeAdPopView.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/8/15.
//

#import "FBHomeAdPopView.h"
//@interface GBHomeAdPopView()
//@end
@implementation FBHomeAdPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame]){
        [self setupUI];
    }
    return self;
}
#pragma mark - click
- (void)goBtnClick
{
    if([self.delegate respondsToSelector:@selector(homeAdPopViewSureClick)]){
        [self.delegate homeAdPopViewSureClick];
    }
    
//    if([FBHomeConfManager shareInstance].homeConfModel.alter_button.count > 0){
//        FBHomeConfItemModel *item = [[FBHomeConfManager shareInstance].homeConfModel.alter_button firstObject];
//        
//        self.hidden = YES;
//        FBWebViewController *vc = [[FBWebViewController alloc] init];
//        vc.urlStr = @"";
//        vc.navTitle = item.shortcut_title;
//        [[FBHelper getCurrentController].navigationController pushViewController:vc animated:YES];
//    }
}
- (void)closeBtnClick
{
    self.hidden = YES;
}
#pragma mark - UI
- (void)setupUI
{
    NSLog(@"屏幕宽高 %f %f",KScreenW,KScreenH);
    
    self.backgroundColor = [UIColor colorWithHex:@"#000000" alpha:0.6];
    
    UIImageView *backgroundImgView = [[UIImageView alloc] init];
    backgroundImgView.layer.cornerRadius = 10;
    backgroundImgView.layer.masksToBounds = YES;
    backgroundImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:backgroundImgView];
    self.backgroundImgView = backgroundImgView;
    [backgroundImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.left.offset(54);
        make.right.offset(-54);
        make.height.equalTo(backgroundImgView.mas_width).multipliedBy(330.0/268.0);
        
//        make.centerX.equalTo(self);
//        make.width.offset(134);
//        make.height.offset(165);
    }];
    
    UIButton *goBtn = [[UIButton alloc] init];
    [goBtn addTarget:self action:@selector(goBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:goBtn];
    [goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backgroundImgView);
    }];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage imageNamed:@"img_circle_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(backgroundImgView.mas_bottom).offset(10);
        make.width.offset(40);
        make.height.offset(40);
    }];
    
}
@end
