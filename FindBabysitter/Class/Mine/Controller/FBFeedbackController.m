//
//  FBFeedbackController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/1.
//

#import "FBFeedbackController.h"

@interface FBFeedbackController ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *placeholderLab;

@end

@implementation FBFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length > 0){
        self.placeholderLab.hidden = YES;
    }else{
        self.placeholderLab.hidden = NO;
    }
}
#pragma mark - click
- (void)sureBtnClick
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.textView.text forKey:@"content"];
    
    [[FBHelper getCurrentController] showHudInView:[FBHelper getCurrentController].view hint:@""];
    [FBRequestData requestWithUrl:toSubmitFeedBack_Url para:dict Complete:^(NSData * _Nonnull data) {
        [[FBHelper getCurrentController] hideHud];
        NSDictionary *registerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *code = [registerDic string:@"code"];
        if([code isEqualToString:@"0"]){
            [[FBHelper getCurrentController] showHint:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark - UI
- (void)setupUI
{
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.textColor = [UIColor colorWithHex:@"#082366"];
    textView.font = [UIFont systemFontOfSize:14];
    textView.backgroundColor = [UIColor colorWithHex:@"#F3F7FB"];
    textView.delegate = self;
    textView.layer.cornerRadius = 10;
    textView.layer.masksToBounds = YES;
    [self.view addSubview:textView];
    self.textView = textView;
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(StatusBarHeight + 44 + 15);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(192);
    }];
    
    UILabel *placeholderLab = [[UILabel alloc] init];
    placeholderLab.text = @"请输入您需要反馈的信息";
    placeholderLab.textColor = [UIColor colorWithHex:@"#999999"];
    placeholderLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:placeholderLab];
    self.placeholderLab = placeholderLab;
    [placeholderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_top).offset(8);
        make.left.equalTo(textView.mas_left).offset(6);
    }];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    sureBtn.layer.cornerRadius = 22;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:@"提交" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHex:@"#FFFFFF"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = MediumFont(14);
    sureBtn.backgroundColor = [UIColor colorWithHex:@"#4971FF"];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(25);
        make.left.offset(18);
        make.right.offset(-18);
        make.height.offset(44);
    }];
}

@end
