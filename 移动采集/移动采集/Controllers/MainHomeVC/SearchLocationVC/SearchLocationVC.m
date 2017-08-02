//
//  SearchLocationVC.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/27.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "SearchLocationVC.h"
#import "NetWorkHelper.h"
#import "UITableView+Lr_Placeholder.h"

@interface SearchLocationVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet UITableView *tb_content;

@end

@implementation SearchLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所在位置";
    
    self.tb_content.isNeedPlaceholderView = YES;
    self.tb_content.firstReload = YES;
    
    //隐藏多余行的分割线
    self.tb_content.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    [self.tb_content setSeparatorInset:UIEdgeInsetsZero];
//    [self.tb_content setLayoutMargins:UIEdgeInsetsZero];
    _tf_search.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    //设置显示模式为永远显示(默认不显示)
    _tf_search.leftViewMode = UITextFieldViewModeAlways;
    
    if (_arr_content == nil) {
        
        if (_searchType == SearchLocationTypeIllegal){
            [self getRoadName];
        }else{
            [self getAccidentCodes];
        }
        
    }
   
    WS(weakSelf);
    self.tb_content.reloadBlock = ^{
        
        SW(strongSelf, weakSelf);
        if (strongSelf.arr_content) {
            strongSelf.arr_content = nil;
        }
        strongSelf.tb_content.isNetAvailable = NO;
        
        if (_searchType == SearchLocationTypeIllegal){
            [strongSelf getRoadName];
        }else{
            [strongSelf getAccidentCodes];
        }
        
    };
    
    [_tf_search addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    WS(weakSelf);

    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        if (strongSelf.arr_content) {
            strongSelf.arr_content = nil;
        }
        strongSelf.tb_content.isNetAvailable = NO;
        
        if (_searchType == SearchLocationTypeIllegal){
            [strongSelf getRoadName];
        }else{
            [strongSelf getAccidentCodes];
        }
    };

}

#pragma mark - 数据请求部分

- (void)getAccidentCodes{

    WS(weakSelf);
    AccidentGetCodesManger *manger = [AccidentGetCodesManger new];
    manger.isNeedLoadHud = YES;
    manger.loadingMessage = @"请求中...";

    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf,weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            [ShareValue sharedDefault].accidentCodes = manger.accidentGetCodesResponse;
            strongSelf.arr_content = [ShareValue sharedDefault].accidentCodes.road;
            strongSelf.arr_temp = [ShareValue sharedDefault].accidentCodes.road;
            [strongSelf.tb_content reloadData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    
        SW(strongSelf,weakSelf);
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            strongSelf.tb_content.isNetAvailable = YES;
            [strongSelf.tb_content reloadData];
        }
    }];

}

#pragma mark - 获取道路通用值

- (void)getRoadName{

    WS(weakSelf);
    
    CommonGetRoadManger *manger = [[CommonGetRoadManger alloc] init];
    manger.isNeedLoadHud = YES;
    manger.loadingMessage = @"请求中...";

    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf,weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {

            [ShareValue sharedDefault].roadModels = manger.commonGetRoadResponse;
            strongSelf.arr_content = manger.commonGetRoadResponse;
            strongSelf.arr_temp =  manger.commonGetRoadResponse;
            [strongSelf.tb_content reloadData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf,weakSelf);
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            strongSelf.tb_content.isNetAvailable = YES;
            [strongSelf.tb_content reloadData];
        }
        
    }];
    
}

#pragma mark - buttonMethods

- (IBAction)handleBtnCancalClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.arr_content) {
        return self.arr_content.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchLocationID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"SearchLocationID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_searchType == SearchLocationTypeIllegal) {
        CommonGetRoadModel *model = _arr_content[indexPath.row];
        cell.textLabel.text = model.getRoadName;
    }else{
        AccidentGetCodesModel *model = _arr_content[indexPath.row];
        cell.textLabel.text = model.modelName;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [cell setSeparatorInset:UIEdgeInsetsZero];
//    [cell setLayoutMargins:UIEdgeInsetsZero];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_searchType == SearchLocationTypeIllegal) {
        CommonGetRoadModel *model = _arr_content[indexPath.row];
        if (self.getRoadBlock) {
            self.getRoadBlock(model);
        }
    }else{
        AccidentGetCodesModel *model = _arr_content[indexPath.row];
        if (self.searchLocationBlock) {
            self.searchLocationBlock(model);
        }
    }

    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 实时监听UITextField内容的变化

-(void)passConTextChange:(id)sender{
    UITextField* textField = (UITextField*)sender;
    if (!_arr_temp || _arr_temp.count == 0) {
        return;
    }
    
    if (textField.text.length == 0) {
        self.arr_content = _arr_temp;
        [_tb_content reloadData];
        return;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    WS(weakSelf);
    [_arr_temp enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SW(strongSelf, weakSelf);
        if (strongSelf.searchType == SearchLocationTypeIllegal) {
            CommonGetRoadModel *model = (CommonGetRoadModel *)obj;
            if ([model.getRoadName containsString:textField.text]) {
                [arr addObject:model];
            }
        }else{
            AccidentGetCodesModel *model = (AccidentGetCodesModel *)obj;
            if ([model.modelName containsString:textField.text]) {
                [arr addObject:model];
            }
        }
        
       
    }];
    self.arr_content = [NSArray arrayWithArray:arr];
    [self.tb_content reloadData];
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
    LxPrintf(@"SearchLocationVC dealloc");
    
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
