//
//  AddressBookHomeVC.m
//  移动采集
//
//  Created by hcat on 2017/10/17.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AddressBookHomeVC.h"
#import "LGUIView.h"
#import <MJRefresh.h>
#import "AddressBookAPI.h"
#import "UITableView+Lr_Placeholder.h"
#import "AddressBookCell.h"
#import "NetWorkHelper.h"

@interface AddressBookHomeVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *v_search;
@property (weak, nonatomic) IBOutlet UIView *v_top_search;
@property (weak, nonatomic) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet UITableView *tb_search;


@property (strong,nonatomic) LGUIView *v_index;
@property (strong,nonatomic) NSMutableArray * arr_addressBook;  //排序之后的通讯录
@property (nonatomic,strong) NSMutableArray * arr_index;        //排序索引
@property (nonatomic,strong) NSMutableArray * arr_data;         //服务端返回的数据
@property (nonatomic,strong) NSMutableArray * arr_search;      //搜索之后的数据

@end

@implementation AddressBookHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    self.arr_addressBook = [NSMutableArray array];
    self.arr_index = [NSMutableArray array];
    
    _tableView.isNeedPlaceholderView = YES;
    _tableView.firstReload = YES;
    
    [_tableView registerNib:[UINib nibWithNibName:@"AddressBookCell" bundle:nil] forCellReuseIdentifier:@"AddressBookCellID"];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _v_search.hidden = YES;
   
    
    [_tb_search registerNib:[UINib nibWithNibName:@"AddressBookCell" bundle:nil] forCellReuseIdentifier:@"AddressBookCellID"];
    _tb_search.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _tf_search.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    _tf_search.leftViewMode = UITextFieldViewModeAlways;
    [_tf_search addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self creatLGIndexView];
    [self requestForAddressBook];
    
    [self initRefresh];
    
    
    
    [_tableView.mj_header beginRefreshing];
    
    WS(weakSelf);
    [_tableView setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tableView.isNetAvailable = NO;
         [strongSelf.tableView.mj_header beginRefreshing];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.tableView.isNetAvailable = NO;
        [strongSelf.tableView.mj_header beginRefreshing];
    };
    
    
}

#pragma mark - 通讯录数据请求

- (void)requestForAddressBook{
    
    WS(weakSelf);
    AddressBookGetListManger * manger = [[AddressBookGetListManger alloc] init];

    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        [strongSelf.tableView.mj_header endRefreshing];
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            strongSelf.arr_data = [[NSMutableArray alloc] initWithArray:manger.addressBookList];
            NSMutableArray *arr_model = [[NSMutableArray alloc] initWithArray:manger.addressBookList];
            strongSelf.arr_addressBook = [strongSelf userSorting:arr_model];
            [strongSelf creatLGIndexView];
            [strongSelf.tableView reloadData];
        }
    
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
   
        SW(strongSelf,weakSelf);
        [strongSelf.tableView.mj_header endRefreshing];
       
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            if (strongSelf.arr_addressBook.count > 0) {
                [strongSelf.arr_addressBook removeAllObjects];
            }
            
            if (strongSelf.v_index) {
                [strongSelf.v_index removeFromSuperview];
                strongSelf.v_index = nil;
            }
            
            strongSelf.tableView.isNetAvailable = YES;
            [strongSelf.tableView reloadData];
        }
        
       
        
    }];

}

#pragma mark - 创建IndexView

- (void)creatLGIndexView{
    
    if (_arr_index && _arr_index.count > 0) {
        
        if (_v_index) {
            [_v_index removeFromSuperview];
            _v_index = nil;
        }
        
        
        _v_index = [[LGUIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 0, 20, self.view.bounds.size.height) indexArray:_arr_index];
        _v_index.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_v_index];
        WS(weakSelf);
        [_v_index selectIndexBlock:^(NSInteger section){
            SW(strongSelf, weakSelf);
             [strongSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
                                     animated:NO
                               scrollPosition:UITableViewScrollPositionTop];
         }];
    }
    
}

#pragma mark - 创建下拉刷新，以及上拉加载更多

- (void)initRefresh{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestForAddressBook)];
    [header setTitle:@"下拉查询" forState:MJRefreshStateIdle];
    [header setTitle:@"松手开始查询" forState:MJRefreshStatePulling];
    [header setTitle:@"查询中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;

}

#pragma mark - buttonAction

- (IBAction)handleBtnSearchClicked:(id)sender{
    self.v_search.hidden = NO;
    [self.view bringSubviewToFront:_v_search];
}

- (IBAction)handleBtnCancelClicked:(id)sender {
    
    self.v_search.hidden = YES;
    self.tf_search.text = nil;
    [self.tf_search resignFirstResponder];
    self.arr_search = [NSMutableArray array];
    [_tb_search reloadData];
    
}



#pragma mark - 对首字母进行排序

-(NSMutableArray *)userSorting:(NSMutableArray *)modelArr{
    
    if (_arr_index && _arr_index.count > 0) {
        [_arr_index removeAllObjects];
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(int i='A';i<='Z';i++)
    {
        NSMutableArray *rulesArray = [[NSMutableArray alloc] init];
        
        NSString *str1 = [NSString stringWithFormat:@"%c",i];
        for(int j=0;j<modelArr.count;j++)
        {
            AddressBookModel *model = [modelArr objectAtIndex:j];  //这个model 是我自己创建的 里面包含用户的姓名 手机号 和 转化成功后的首字母
            if([model.firstChar isEqualToString:str1])
            {
                [rulesArray addObject:model];    //把首字母相同的人物model 放到同一个数组里面
                [modelArr removeObject:model];   //model 放到 rulesArray 里面说明这个model 已经拍好序了 所以从总的modelArr里面删除
                j--;
                
            }else{
                
            }
        }
        if (rulesArray.count !=0) {
            [array addObject:rulesArray];
            [_arr_index addObject:[NSString stringWithFormat:@"%c",i]]; //把大写字母也放到一个数组里面
        }
    }
    
    if (modelArr.count !=0) {
        [array addObject:modelArr];
        [_arr_index addObject:@"#"];  //把首字母不是A~Z里的字符全部放到 array里面 然后返回
    }
    
    return array;
    
}


#pragma mark - 实时监听UITextField内容的变化

-(void)passConTextChange:(id)sender{
    UITextField* textField = (UITextField*)sender;
    if (!_arr_data || _arr_data.count == 0) {
        return;
    }
    
    if (textField.text.length == 0) {
        self.arr_search = [NSMutableArray array];
        [_tb_search reloadData];
        return;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    
    [_arr_data enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        AddressBookModel *model = (AddressBookModel *)obj;
        
        if ([model.realName containsString:textField.text]) {
            [arr addObject:model];
        }
        if ([model.name containsString:textField.text]) {
            [arr addObject:model];
        }
    }];
    self.arr_search = arr;
    [self.tb_search reloadData];
}




#pragma mark - tableViewDelegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (tableView == _tableView) {
        return _arr_index[section];
    }else{
        return nil;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        return 25;
    }else{
        return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == _tableView) {
        return self.arr_addressBook.count;
    }else{
        return 1;
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _tableView) {
        return [(NSMutableArray *)self.arr_addressBook[section] count];
    }else{
        return [_arr_search count];
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressBookCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (tableView == _tableView) {
        NSMutableArray *t_arr = _arr_addressBook[indexPath.section];
        if (t_arr) {
            cell.model = t_arr[indexPath.row];
        };
    }else{
        cell.model = _arr_search[indexPath.row];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 47, 0, 0)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 47, 0, 0)];
}

#pragma mark - scrollViewDelegate
//用于滚动到顶部的时候使得tableView不能再继续下拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _tb_search){
    
        [_tf_search resignFirstResponder];
        if (scrollView.contentOffset.y < 0) {
            CGPoint position = CGPointMake(0, 0);
            [scrollView setContentOffset:position animated:NO];
            return;
        }
    }
}

#pragma mark - AKTabBar Method

- (NSString *)tabImageName{
    return @"tabbar_addressBook_n";
}

- (NSString *)tabSelectedImageName{
    return @"tabbar_addressBook_h";
}

- (NSString *)tabTitle{
    return NSLocalizedString(@"通讯录", nil);
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
     [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
    
    LxPrintf(@"AddressBookHomeVC dealloc");

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
