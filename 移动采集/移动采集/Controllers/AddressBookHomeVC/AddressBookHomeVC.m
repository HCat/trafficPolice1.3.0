//
//  AddressBookHomeVC.m
//  移动采集
//
//  Created by hcat on 2017/10/17.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AddressBookHomeVC.h"
#import "LGUIView.h"
#import "AddressBookAPI.h"
#import "UITableView+Lr_Placeholder.h"
#import "AddressBookCell.h"

@interface AddressBookHomeVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) LGUIView *v_index;
@property (strong,nonatomic) NSMutableArray * arr_addressBook;
@property (nonatomic,strong) NSMutableArray * arr_index;

@property (strong,nonatomic) NSString *str_search;

@end

@implementation AddressBookHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    self.arr_addressBook = [NSMutableArray array];
    self.arr_index = [NSMutableArray array];
    
    _tableView.isNeedPlaceholderView = YES;
    if (_str_search) {
        _tableView.str_placeholder = @"暂无搜索内容";
    }
    _tableView.firstReload = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"AddressBookCell" bundle:nil] forCellReuseIdentifier:@"AddressBookCellID"];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self creatLGIndexView];
    [self requestForAddressBook];
    
    WS(weakSelf);
    [_tableView setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tableView.isNetAvailable = NO;
        [strongSelf requestForAddressBook];
    }];
    
}

#pragma mark - 通讯录数据请求

- (void)requestForAddressBook{
    
    WS(weakSelf);
    AddressBookGetListManger * manger = [[AddressBookGetListManger alloc] init];
    
    [manger configLoadingTitle: @"请求"];
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            NSMutableArray *arr_model = [NSMutableArray array];
            [arr_model addObjectsFromArray:manger.addressBookList];
            strongSelf.arr_addressBook = [strongSelf userSorting:arr_model];
            [strongSelf creatLGIndexView];
            [strongSelf.tableView reloadData];
        }
    
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        if (strongSelf.arr_addressBook.count > 0) {
            [strongSelf.arr_addressBook removeAllObjects];
        }
        strongSelf.tableView.isNetAvailable = YES;
        [strongSelf.tableView reloadData];
        
    }];

}

#pragma mark - private

- (void)creatLGIndexView{
    
    if (_arr_index && _arr_index.count > 0) {
        
        _v_index = [[LGUIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 40, 20, self.view.bounds.size.height - 80) indexArray:_arr_index];
        _v_index.backgroundColor = [UIColor redColor];
        [self.view addSubview:_v_index];
        
        [_v_index selectIndexBlock:^(NSInteger section){
             [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
                                     animated:NO
                               scrollPosition:UITableViewScrollPositionTop];
         }];
    }
    
}

#pragma mark - 对首字母进行排序

-(NSMutableArray *)userSorting:(NSMutableArray *)modelArr{
    
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



#pragma mark - tableViewDelegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _arr_index[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arr_addressBook.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSMutableArray *)self.arr_addressBook[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressBookCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableArray *t_arr = _arr_addressBook[indexPath.section];
    if (t_arr) {
        cell.model = t_arr[indexPath.row];
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 47, 0, 0)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 47, 0, 0)];
}

#pragma mark - AKTabBar Method

- (NSString *)tabImageName{
    return @"tabbar_addressBook_n";
}

- (NSString *)tabSelectedImageName{
    return @"tabbar_addressBook_n";
}

- (NSString *)tabTitle{
    return nil;
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
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
