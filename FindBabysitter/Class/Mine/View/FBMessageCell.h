//
//  FBMessageCell.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/1.
//

#import <UIKit/UIKit.h>
#import "FBMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FBMessageCell : UITableViewCell
@property (nonatomic, strong)UIImageView *iconImgView;
@property (nonatomic, strong)UILabel *titleLab;
@property (nonatomic, strong)UILabel *contentLab;
@property (nonatomic, strong)UILabel *timeLab;

@property(nonatomic,strong)FBMessageModel *itemModel;
@end

NS_ASSUME_NONNULL_END
