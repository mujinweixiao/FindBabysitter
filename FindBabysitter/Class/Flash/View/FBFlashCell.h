//
//  FBFlashCell.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBFlashCell : UITableViewCell
@property(nonatomic,strong)UIView *rootView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *subtitleLab;
@property(nonatomic,strong)UIImageView *selectImgView;

@end

NS_ASSUME_NONNULL_END
