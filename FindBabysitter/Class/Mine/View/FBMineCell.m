//
//  FBMineCell.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/1.
//

#import "FBMineCell.h"

@implementation FBMineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self.contentView addSubview:iconImgView];
    self.iconImgView = iconImgView;
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.offset(32);
        make.width.offset(20);
        make.height.offset(20);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    titleLab.font = RegularFont(16);
    titleLab.text = @"标题";
    [self.contentView addSubview:titleLab];
    self.titleLab = titleLab;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(iconImgView.mas_right).offset(15);
    }];
    
    UIImageView *arrowImgView = [[UIImageView alloc] init];
    arrowImgView.image = [UIImage imageNamed:@"img_mine_arrow"];
    [self.contentView addSubview:arrowImgView];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.offset(-30);
        make.width.offset(8);
        make.height.offset(12);
    }];
}
@end
