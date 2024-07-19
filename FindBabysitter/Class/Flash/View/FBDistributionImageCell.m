//
//  FBDistributionImageCell.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/3.
//

#import "FBDistributionImageCell.h"

@implementation FBDistributionImageCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self == [super initWithFrame:frame]){
        [self setupUI];
    }
    return self;
}
#pragma mark - UI
- (void)setupUI
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView *iconImgView = [[UIImageView alloc] init];
    iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    iconImgView.layer.cornerRadius = 10;
    iconImgView.layer.masksToBounds = YES;
    iconImgView.layer.borderColor = [UIColor colorWithHex:@"#4971FF"].CGColor;
    iconImgView.layer.borderWidth = 1.0;
    iconImgView.backgroundColor = [UIColor colorWithHex:@"#ECF6FF"];
    [self.contentView addSubview:iconImgView];
    self.iconImgView = iconImgView;
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
@end
