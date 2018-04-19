//
//  VehicleSearchListVC.m
//  移动采集
//
//  Created by hcat on 2018/4/4.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleSearchListVC.h"
#import "YUSegmentedControl.h"
#import "UITableView+Lr_Placeholder.h"
#import "LRSettingCell.h"
#import "SearchImportCarVC.h"
#import "SRAlertView.h"
#import "VehicleDetailVC.h"

@implementation SearchCarItemModel


@end


@interface VehicleSearchListVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet YUSegmentedControl *segmentedControl;
@property(nonatomic,assign) SearchType searchType;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *mArr_items;


@end

@implementation VehicleSearchListVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [_tf_search addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.mArr_items = [NSMutableArray array];
    
    [self initPageMenu];
    
    [_tf_search becomeFirstResponder];
    
    _tableView.isNeedPlaceholderView = YES;
    _tableView.str_placeholder = @"暂无搜索内容";
    _tableView.firstReload = YES;
    
   
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _searchType = SearchTypePlatNo;
    [self searchData:@(_searchType)];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
    
}


#pragma mark - initPageMenu

- (void)initPageMenu{
 
    [_segmentedControl setUpWithTitles:@[@"车牌号",@"自编号"]];
    [_segmentedControl setTextAttributes:@{
                                           NSFontAttributeName: [UIFont systemFontOfSize:14.0 weight:UIFontWeightLight],
                                           NSForegroundColorAttributeName: DefaultMenuUnSelectedColor
                                           } forState:YUSegmentedControlStateNormal];
    [_segmentedControl setTextAttributes:@{
                                           NSFontAttributeName: [UIFont systemFontOfSize:14.0 weight:UIFontWeightLight],
                                           NSForegroundColorAttributeName: DefaultMenuSelectedColor
                                           } forState:YUSegmentedControlStateSelected];
    _segmentedControl.indicator.backgroundColor = DefaultMenuSelectedColor;
    [_segmentedControl addTarget:self action:@selector(segmentedControlTapped:) forControlEvents:UIControlEventValueChanged];
    [_segmentedControl setBackgroundColor:UIColorFromRGB(0xffffff)];
    _segmentedControl.showsVerticalDivider = NO;
    _segmentedControl.showsTopSeparator = YES;
    _segmentedControl.showsBottomSeparator = NO;
    
    
}


#pragma mark - requestData

- (void)searchData:(NSNumber *)searchtype{
    
    WS(weakSelf);
    
    VehicleGetVehicleListManger *manger = [[VehicleGetVehicleListManger alloc] init];
    manger.content = _tf_search.text;
    manger.searchType = searchtype;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        
        [strongSelf.mArr_items removeAllObjects];
        
        for (VehicleListModel * model in manger.vehicleList) {
            
            SearchCarItemModel *item = [[SearchCarItemModel alloc]init];
            item.accessoryType = LRSettingAccessoryTypeDisclosureIndicator;
            item.vehicleModel = model;
            if (strongSelf.searchType == SearchTypePlatNo) {
                item.funcName = model.plateNo;
                item.img = [UIImage imageNamed:@"icon_car_search"];
            }else if (strongSelf.searchType == SearchTypeSinceNumber){
                item.funcName = model.selfNo;
                item.img = [UIImage imageNamed:@"icon_search_sinceNumber"];
            }
            
            item.executeCode = ^{
                [strongSelf searchVehicle:item.vehicleModel.plateNo];
                
            };
            
            [strongSelf.mArr_items addObject:item];
            
        }
        
        [strongSelf.tableView reloadData];
  
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        
    }];
    
}

- (void)searchVehicle:(NSString *)plateNO{
    
    
    if(![ShareFun validateCarNumber:plateNO]){
        [LRShowHUD showError:@"请输入正确的车牌号" duration:1.5f];
        return;
    }
    
    WS(weakSelf);
    
    VehicleLocationByPlateNoManger *manger = [[VehicleLocationByPlateNoManger alloc] init];
    manger.plateNo = plateNO;
    manger.isNeedLoadHud = YES;
    manger.loadingMessage =  @"搜索中..";
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        
        if(manger.vehicleGPSModel){
            
            SearchImportCarVC *t_vc = [[SearchImportCarVC alloc] init];
            t_vc.search_vehicleModel = manger.vehicleGPSModel;
            [strongSelf.navigationController pushViewController:t_vc animated:YES];
            
        }else{
           
            [strongSelf showAlertViewWithcontent:@"未找到车辆相关位置,点击按钮查看车辆相关信息?" leftTitle:nil rightTitle:@"查看车辆信息" block:^(AlertViewActionType actionType) {
                if (actionType == AlertViewActionTypeRight) {
                    VehicleDetailVC * t_vc = [[VehicleDetailVC alloc] init];
                    t_vc.type = VehicleRequestTypeCarNumber;
                    t_vc.NummberId = manger.plateNo;
                    [strongSelf.navigationController pushViewController:t_vc animated:YES];
                    
                }
            }];
            
            
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        
    }];
    
}

#pragma mark - 弹出提示框

-(void)showAlertViewWithcontent:(NSString *)content leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle block:(AlertViewDidSelectAction)selectAction{
    
    SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:content
                                                leftActionTitle:leftTitle
                                               rightActionTitle:rightTitle
                                                 animationStyle:AlertViewAnimationNone
                                                   selectAction:selectAction];
    alertView.blurCurrentBackgroundView = NO;
    [alertView show];
    
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mArr_items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"setting";
    
    SearchCarItemModel *itemModel = self.mArr_items[indexPath.row];
    
    LRSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LRSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.item = itemModel;
    return cell;
    
}

#pragma - mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchCarItemModel *itemModel = self.mArr_items[indexPath.row];
    if (itemModel.executeCode) {
        itemModel.executeCode();
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

#pragma mark - scrollViewDelegate
//用于滚动到顶部的时候使得tableView不能再继续下拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _tableView){
        
        if (scrollView.contentOffset.y < 0) {
            CGPoint position = CGPointMake(0, 0);
            [scrollView setContentOffset:position animated:NO];
            return;
        }
    }
}





#pragma mark - buttonAction

- (IBAction)handleBtnBackClickingAction:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)handleBtnSearchClickingAction:(id)sender {
    
    if (_tf_search.text.length > 0) {
        [self searchData:@(_searchType)];
    }else{
        [LRShowHUD showError:@"请输入搜索内容" duration:1.5f];
    }
    
}

- (void)segmentedControlTapped:(YUSegmentedControl *)sender {
    NSUInteger selectedIndex = _segmentedControl.selectedSegmentIndex;
    LxDBAnyVar(selectedIndex);
    
    if (selectedIndex == 0) {
        _searchType = SearchTypePlatNo;
    }else if (selectedIndex == 1){
        _searchType = SearchTypeSinceNumber;
    }
    
    [self searchData:@(_searchType)];
    
}


#pragma mark - UITextField内容变化

-(void)passConTextChange:(id)sender{
    
    UITextField* textField = (UITextField*)sender;
    LxDBAnyVar(textField.text);
    NSInteger length =  textField.text.length;

    if (textField == _tf_search) {
        
        if (length > 0) {
            [self searchData:@(_searchType)];
        }
        
    }
    
}

#pragma mark - deallloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"VehicleSearchListVC dealloc");
    
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
