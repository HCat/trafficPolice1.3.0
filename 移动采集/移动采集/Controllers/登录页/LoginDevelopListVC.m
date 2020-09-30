//
//  LoginDevelopListVC.m
//  移动采集
//
//  Created by hcat on 2018/8/21.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "LoginDevelopListVC.h"
#import "CommonAPI.h"

@interface LoginDevelopListVC ()
@property (weak, nonatomic) IBOutlet UITableView *tb_content;

@end

@implementation LoginDevelopListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请选择要登录的机构";
    _tb_content.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tb_content setSeparatorInset:UIEdgeInsetsZero];
    [_tb_content setLayoutMargins:UIEdgeInsetsZero];
    
    [_tb_content reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate && Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_data.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DevelopCellID"];
    
    if (cell == nil) {
       
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DevelopCellID"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cell.contentView.bounds.size.height)];
        [cell.contentView addSubview:label];
        label.font = [UIFont systemFontOfSize:15.f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGB(0x444444);
        label.tag =  110;
    }
   
    UILabel * label = [cell.contentView viewWithTag:110];
    
    PoliceOrgModel *model = _arr_data[indexPath.row];
    
    label.text = model.name;
    

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PoliceOrgModel *model = _arr_data[indexPath.row];
    [[ShareValue sharedDefault] setOrgId: model.code];
    [self.navigationController popToRootViewControllerAnimated:YES];
}





#pragma mark - dealloc

- (void)dealloc{
    LxPrintf(@"LoginDevelopListVC dealloc");
    
}

@end
