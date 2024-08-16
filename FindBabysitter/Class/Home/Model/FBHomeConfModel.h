//
//  FBHomeConfModel.h
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FBHomeConfItemModel : NSObject
///
@property(nonatomic,copy)NSString *ID;
///
@property(nonatomic,copy)NSString *shortcut_title;
///
@property(nonatomic,copy)NSString *shortcut_icon;
///1模版，2链接
@property(nonatomic,copy)NSString *shortcut_type;
///
@property(nonatomic,copy)NSString *shortcut_value;
///
@property(nonatomic,copy)NSString *shortcut_desc;
///
@property(nonatomic,copy)NSString *shortcut_label;
///
@property(nonatomic,copy)NSString *shortcut_horn_icon;
@end

@interface FBHomeConfModel : NSObject
///顶部按钮
@property (nonatomic, strong) NSArray *top_button;
///中部按钮
@property (nonatomic, strong) NSArray *middle_button;
///底部按钮
@property (nonatomic, strong) NSArray *bottom_button;
///轮播图
@property (nonatomic, strong) NSArray *banners;
///菜单按钮
@property (nonatomic, strong) NSArray *menu_button;
///弹窗
@property (nonatomic, strong) NSArray *alter_button;

@end

NS_ASSUME_NONNULL_END
