//
//  JointPenaltiesVC.m
//  移动采集
//
//  Created by hcat on 2018/1/22.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "JointPenaltiesVC.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JointPenaltiesCell.h"

#import "JointLawAPI.h"


@interface JointPenaltiesVC ()

@property (nonatomic,strong) NSMutableArray * arr_selected;
@property (nonatomic,strong) NSMutableArray *arr_data;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *v_bottom;

@property (weak, nonatomic) IBOutlet UIButton *btn_bottom;

@end

@implementation JointPenaltiesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"处罚条例";
    
    self.arr_selected = [NSMutableArray array];
    self.arr_data = [NSMutableArray array];
    [self loadPenaltiesData];
    
    if (_arr_penalts) {
        [self.arr_selected addObjectsFromArray:_arr_penalts];
    }
    
    
    [_tableView registerNib:[UINib nibWithNibName:@"JointPenaltiesCell" bundle:nil] forCellReuseIdentifier:@"JointPenaltiesCellID"];
    
    //隐藏多余行的分割线
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    
    [self judgeCanComit];
    
}

#pragma mark - 请求数据

- (void)loadPenaltiesData{
    
    WS(weakSelf);
    
    JointLawGetIllegalCodeListManger * manger = [[JointLawGetIllegalCodeListManger alloc] init];
    manger.launchOrgType = @2;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            [strongSelf.arr_data addObjectsFromArray:manger.list];
            
            NSMutableIndexSet *set = [[NSMutableIndexSet alloc]init];
            
            if (_arr_penalts && _arr_penalts.count > 0) {
                for(int i =0 ; i < strongSelf.arr_data.count ; i++){
                    JointLawIllegalCodeModel *t_model_i = strongSelf.arr_data[i];
                    for (int j = 0; j < strongSelf.arr_penalts.count; j++) {
                        JointLawIllegalCodeModel *t_model_j = strongSelf.arr_data[j];
                        
                        if([t_model_j.illegalCode isEqualToNumber:t_model_i.illegalCode]){
                            [set addIndex:i];
                            break;
                        }
                    }
                }
                
                [strongSelf.arr_data removeObjectsAtIndexes:set];
            }
            
            [strongSelf.tableView reloadData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return _arr_selected.count;
    }else{
        int count = 0;
        for (int i = 0; i < _arr_data.count; i++) {
            JointLawIllegalCodeModel *model = _arr_data[i];
            if (model.isSelected == NO) {
                count = count + 1;
            }
        }
    
        return count;
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf);
    
    if (indexPath.section == 0) {
        
        return [tableView fd_heightForCellWithIdentifier:@"JointPenaltiesCellID" cacheByIndexPath:indexPath configuration:^(JointPenaltiesCell *cell) {
            SW(strongSelf, weakSelf);
            cell.model = strongSelf.arr_selected[indexPath.row];
            
        }];
        
    }else if (indexPath.section == 1){
        
        return [tableView fd_heightForCellWithIdentifier:@"JointPenaltiesCellID" cacheByIndexPath:indexPath configuration:^(JointPenaltiesCell *cell) {
            SW(strongSelf, weakSelf);
            
            
            JointLawIllegalCodeModel * model = strongSelf.arr_data[indexPath.row];
            if (model.isSelected == NO) {
                cell.model = strongSelf.arr_data[indexPath.row];
            }
        }];
        
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        JointPenaltiesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JointPenaltiesCellID"];
        cell.fd_enforceFrameLayout = NO;
        cell.model = _arr_selected[indexPath.row];
        return cell;
        
    }else if (indexPath.section == 1){
        
        JointPenaltiesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JointPenaltiesCellID"];
        cell.fd_enforceFrameLayout = NO;
        JointLawIllegalCodeModel * model = _arr_data[indexPath.row];
        if (model.isSelected == NO) {
            cell.model = _arr_data[indexPath.row];
        }
        
        return cell;
        
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        JointLawIllegalCodeModel *model = _arr_selected[indexPath.row];
        model.isSelected = NO;
        [_arr_data addObject:model];
        [_arr_selected removeObject:model];
    }else{
        JointLawIllegalCodeModel *model = _arr_data[indexPath.row];
        model.isSelected = YES;
        [_arr_selected addObject:model];
        [_arr_data removeObject:model];
    
    }
    
    [self.tableView reloadData];
    
    [self judgeCanComit];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

#pragma mark - 确定按钮事件

- (IBAction)handleBtnMakeSureClicked:(id)sender {
    
    if(self.block){
        self.block(_arr_selected);
        [self.navigationController popViewControllerAnimated:YES];
    }

}

#pragma mark - 判断是否可以点击确定按钮

- (void)judgeCanComit{
    
    if (_arr_selected.count == 0) {
        _btn_bottom.enabled = NO;
        [_btn_bottom setBackgroundColor:DefaultBtnNuableColor];
    }else{
        _btn_bottom.enabled = YES;
        [_btn_bottom setBackgroundColor:DefaultBtnColor];
    }
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"JointPenaltiesVC dealloc");
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
