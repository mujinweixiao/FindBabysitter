//
//  FBFlashCell.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/2.
//

#import "FBFlashCell.h"

@implementation FBFlashCell

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
    
    UIView *rootView = [[UIView alloc] init];
    rootView.layer.cornerRadius = 10;
    rootView.layer.masksToBounds = YES;
//    rootView.backgroundColor = [UIColor colorWithHex:@"#F3F7FB"];
    [self.contentView addSubview:rootView];
    self.rootView = rootView;
    [rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(16);
        make.right.offset(-16);
        make.bottom.offset(0);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"标题";
    titleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    titleLab.font = BoldFont(16);
    [rootView addSubview:titleLab];
    self.titleLab = titleLab;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(14);
        make.left.offset(16);
    }];
    
    UILabel *subtitleLab = [[UILabel alloc] init];
    subtitleLab.text = @"副标题";
    subtitleLab.textColor = [UIColor colorWithHex:@"#16171A"];
    subtitleLab.font = MediumFont(14);
    subtitleLab.numberOfLines = 0;
    [rootView addSubview:subtitleLab];
    self.subtitleLab = subtitleLab;
    [subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLab.mas_bottom).offset(5);
        make.left.offset(16);
        make.right.offset(-16);
        make.bottom.offset(-14);
    }];
    
    //img_select_blue img_select_gray
    UIImageView *selectImgView = [[UIImageView alloc] init];
    selectImgView.image = [UIImage imageNamed:@"img_select_gray"];
    [rootView addSubview:selectImgView];
    self.selectImgView = selectImgView;
    [selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rootView);
        make.right.offset(-16);
        make.width.offset(20);
        make.height.offset(20);
    }];
    
}
@end
