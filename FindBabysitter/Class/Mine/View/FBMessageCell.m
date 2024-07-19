//
//  FBMessageCell.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/1.
//

#import "FBMessageCell.h"

@implementation FBMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}
#pragma mark - data
- (void)setItemModel:(FBMessageModel *)itemModel
{
    _itemModel = itemModel;
    
    if([itemModel.notice_status isEqualToString:@"2"]){
        self.iconImgView.image = [UIImage imageNamed:@"img_message_ring_red"];
    }else{
        self.iconImgView.image = [UIImage imageNamed:@"img_message_ring"];
    }
    self.titleLab.text = itemModel.notice_title;
    self.contentLab.text = itemModel.notice_content;
    self.timeLab.text = itemModel.create_time;
}
#pragma mark - UI
- (void)setupUI
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *rootView = [[UIView alloc] init];
    rootView.backgroundColor = [UIColor colorWithHex:@"#F3F7FB"];
    rootView.layer.cornerRadius = 10;
    rootView.layer.masksToBounds = YES;
    [self.contentView addSubview:rootView];
    [rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(16);
        make.left.offset(16);
        make.bottom.offset(0);
        make.right.offset(-16);
    }];
    
    //img_message_ring img_message_ring_red
    UIImageView *iconImgView = [[UIImageView alloc] init];
    iconImgView.image = [UIImage imageNamed:@"img_message_ring"];
    [rootView addSubview:iconImgView];
    self.iconImgView = iconImgView;
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(25);
        make.left.offset(21);
        make.width.offset(14);
        make.height.offset(18);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"标题";
    titleLab.textColor = [UIColor colorWithHex:@"#4971FF"];
    titleLab.font = BoldFont(16);
    [rootView addSubview:titleLab];
    self.titleLab = titleLab;
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconImgView);
        make.left.equalTo(iconImgView.mas_right).offset(5);
    }];
    
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.text = @"您好，您的物流信息已更新。最新到达站点  华北管理区【北京市】转运中心 ";
    contentLab.textColor = [UIColor colorWithHex:@"#011C13"];
    contentLab.font = MediumFont(14);
    contentLab.numberOfLines = 0;
    [rootView addSubview:contentLab];
    self.contentLab = contentLab;
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImgView.mas_bottom).offset(15);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHex:@"#E2E7ED"];
    [rootView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLab.mas_bottom).offset(15);
        make.left.offset(17);
        make.right.offset(-17);
        make.height.offset(0.5);
    }];
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.text = @"2024-06-19 20:07:48";
    timeLab.textColor = [UIColor colorWithHex:@"#1C1B01"];
    timeLab.font = MediumFont(14);
    [rootView addSubview:timeLab];
    self.timeLab = timeLab;
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(5);
        make.left.offset(17);
        make.right.offset(-17);
        make.height.offset(20);
        
        make.bottom.offset(-20);
    }];
    
}

@end
