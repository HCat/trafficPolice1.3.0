//
//  MainFunctionListVC.m
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "MainFunctionListVC.h"
#import "MainFuncitonCell.h"

@interface MainFunctionListVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MainFunctionListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

#pragma mark - 配置UI界面

- (void)configUI{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MainFuncitonCell" bundle:nil] forCellReuseIdentifier:@"MainFuncitonCellID"];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr_content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommonMenuModel *itemModel = self.arr_content[indexPath.row];
    
    MainFuncitonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainFuncitonCellID" forIndexPath:indexPath];
    cell.menuModel = itemModel;
    return cell;
    
}

#pragma - mark UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   
}


#pragma mark - dealloc

- (void)dealloc{
    LxPrintf(@"MainFunctionListVC dealloc");
}

@end
