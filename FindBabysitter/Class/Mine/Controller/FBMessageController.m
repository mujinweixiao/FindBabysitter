//
//  FBMessageController.m
//  FindBabysitter
//
//  Created by 响  闫 on 2024/7/1.
//

#import "FBMessageController.h"
#import "FBMessageCell.h"
#import "FBMessageModel.h"
@interface FBMessageController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation FBMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self setupUI];
    [self refreshData];
}
#pragma mark -- 请求数据
-(void)refreshData{
    
    self.page = 1;
    
    [self hideHud];
    [self showHudInView:self.view hint:@""];
//
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(_page);
    param[@"limit"] = @(50);

    [FBRequestData requestWithUrl:noticeLists_Url para:param Complete:^(NSData *data) {
        NSDictionary *registerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSUInteger code = [registerDic[@"code"] integerValue];
        if (code == 0) {
            NSLog(@"----anchorAuthHistory_Url=%@",registerDic);

            self.dataArray = [FBMessageModel mj_objectArrayWithKeyValuesArray:registerDic[@"data"][@"lists"]];
   
            self.page = 2;
            
            [self.mainTableView.mj_footer resetNoMoreData];
            if (self.dataArray.count == 0) {
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
                        
        }else{
            [self showHint:registerDic[@"msg"]];
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            
            // 结束刷新
        }
        
        if(self.dataArray.count==0){
            self.mainTableView.mj_footer.hidden = YES;
        }
        
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView reloadData];
        [self hideHud];
        
    } fail:^(NSError *error) {
        [self.mainTableView.mj_header endRefreshing];
        [self hideHud];
        [self showHint:@"请求出错"];
    }];
    
    
    
}

#pragma mark ---------加载更多
- (void)refreshMoreData{
    
    [self hideHud];
    [self showHudInView:self.view hint:@""];
        
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(_page);
    param[@"limit"] = @(50);
    [FBRequestData requestWithUrl:noticeLists_Url para:param Complete:^(NSData *data) {
        
        NSDictionary *registerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSUInteger code = [registerDic[@"code"] integerValue];
        if (code == 0) {
            NSMutableArray *array_m = [FBMessageModel mj_objectArrayWithKeyValuesArray:registerDic[@"data"][@"lists"]];

            if (array_m.count > 0) {
                [self.dataArray addObjectsFromArray:array_m];
                //设置页码
                self.page++ ;
                // 结束刷新
                [self.mainTableView.mj_footer endRefreshing];
                
            }else{
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (array_m.count < 50) {
                [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            
        }else{
            [self.mainTableView.mj_footer endRefreshingWithNoMoreData];
            [self showHint:registerDic[@"msg"]];
            
        }
        
        [self.mainTableView reloadData];
        [self hideHud];
        
    } fail:^(NSError *error) {
        
        [self.mainTableView.mj_footer endRefreshing];
        [self hideHud];
        [self showHint:@"请求出错"];
    }];
    
    
}
//已读消息
- (void)requestSetReadData
{
    [self hideHud];
    [self showHudInView:self.view hint:@""];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"" forKey:@"id"];

    [FBRequestData requestWithUrl:noticeSetRead_Url para:param Complete:^(NSData *data) {
        NSDictionary *registerDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSUInteger code = [registerDic[@"code"] integerValue];
        if (code == 0) {
            
        }else{
            [self showHint:registerDic[@"msg"]];
        }
        [self hideHud];
        
    } fail:^(NSError *error) {
        [self hideHud];
        [self showHint:@"请求出错"];
    }];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FBMessageModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    FBMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.itemModel = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *rootView = [[UIView alloc] init];
    return rootView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 16;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *rootView = [[UIView alloc] init];
    return rootView;
}
#pragma mark - UI
- (void)setupUI
{
    self.title = @"消息中心";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[FBMessageCell class] forCellReuseIdentifier:@"cell"];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    self.mainTableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(StatusBarHeight + 44);
        make.left.offset(0);
        make.bottom.offset(0);
        make.right.offset(0);
    }];
    
    self.mainTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    //    [self.tableView.mj_header beginRefreshing];
    self.mainTableView.mj_footer =[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMoreData)];
}

@end
