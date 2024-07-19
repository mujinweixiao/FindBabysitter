//
//  FBCreatAddressPopView.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/3.
//  创建地址弹窗

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FBCreatAddressPopViewDelegate <NSObject>
- (void)creatAddressPopViewSureClick;
@end

@interface FBCreatAddressPopView : UIView
@property(nonatomic,weak)id<FBCreatAddressPopViewDelegate>delegate;

@property(nonatomic,strong)UITextField *cityTextField;
@property(nonatomic,strong)UITextField *mobileTextField;
@property(nonatomic,strong)UITextField *wechatTextField;
@property(nonatomic,strong)UITextField *contentTextField;
@property(nonatomic,strong)UITextField *nameTextField;
@property(nonatomic,strong)UIButton *womanBtn;
@property(nonatomic,strong)UIButton *manBtn;
//1:女 2：男
@property(nonatomic,assign)NSInteger recordSex;
@end

NS_ASSUME_NONNULL_END
