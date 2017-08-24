//
//  UserHomeVC.m
//  移动采集
//
//  Created by hcat on 2017/7/18.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "UserHomeVC.h"

#import "LRSettingCell.h"
#import "LRSettingItemModel.h"
#import "LRSettingSectionModel.h"

#import "UserSetVC.h"
#import "UserModel.h"

#import "AccidentListVC.h"

@interface UserHomeVC ()

@property (nonatomic,strong) NSArray  *sectionArray; /**< section模型数组*/
@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (nonatomic,strong) NSMutableArray *mArr_items;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_height_table;


@end

@implementation UserHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.mArr_items = [NSMutableArray array];
    [_tb_content setSeparatorInset:UIEdgeInsetsMake(0, 47, 0, 0)];
    [_tb_content setLayoutMargins:UIEdgeInsetsMake(0, 47, 0, 0)];
    [self setupSections];
}

#pragma mark - setUp

- (void)setupSections{
    
    WS(weakSelf);
   
    if ([UserModel isPermissionForAccidentList]) {
        
        LRSettingItemModel *item1 = [[LRSettingItemModel alloc]init];
        item1.accessoryType = LRSettingAccessoryTypeDisclosureIndicator;
        item1.funcName = @"事故处理";
        item1.img = [UIImage imageNamed:@"list_accident"];
        item1.executeCode = ^{
            LxPrintf(@"事故处理");
            SW(strongSelf, weakSelf);
            AccidentListVC *t_vc = [AccidentListVC new];
            t_vc.accidentType = AccidentTypeAccident;
            t_vc.isHandle = @1;
            [strongSelf.navigationController pushViewController:t_vc animated:YES];
            
        };
        [self.mArr_items addObject:item1];

    }
    
    if ([UserModel isPermissionForFastAccidentList]) {
        LRSettingItemModel *item2 = [[LRSettingItemModel alloc]init];
        item2.accessoryType = LRSettingAccessoryTypeDisclosureIndicator;
        item2.funcName = @"快处事故处理";
        item2.img = [UIImage imageNamed:@"list_fastAccident"];
        item2.executeCode = ^{
            LxPrintf(@"快处事故处理");
            SW(strongSelf, weakSelf);
            AccidentListVC *t_vc = [AccidentListVC new];
            t_vc.accidentType = AccidentTypeFastAccident;
            t_vc.isHandle = @1;
            t_vc.title = @"快处";
            [strongSelf.navigationController pushViewController:t_vc animated:YES];
        };
        [self.mArr_items addObject:item2];
    }

    if ([UserModel isPermissionForIllegalList]) {
        LRSettingItemModel *item3 = [[LRSettingItemModel alloc]init];
        item3.accessoryType = LRSettingAccessoryTypeDisclosureIndicator;
        item3.funcName = @"违法停车处理";
        item3.img = [UIImage imageNamed:@"list_illegalPark"];
        item3.executeCode = ^{
            LxPrintf(@"违法停车处理");
            
        };
        [self.mArr_items addObject:item3];
    }
    
    if ([UserModel isPermissionForThroughList]) {
        LRSettingItemModel *item4 = [[LRSettingItemModel alloc]init];
        item4.accessoryType = LRSettingAccessoryTypeDisclosureIndicator;
        item4.funcName = @"闯禁令违法行为采集";
        item4.img = [UIImage imageNamed:@"list_through"];
        item4.executeCode = ^{
            LxPrintf(@"闯禁令违法行为采集");
            
        };
        [self.mArr_items addObject:item4];
    }
    
    if ([UserModel isPermissionForVideoCollectList]) {
        LRSettingItemModel *item5 = [[LRSettingItemModel alloc]init];
        item5.accessoryType = LRSettingAccessoryTypeDisclosureIndicator;
        item5.funcName = @"警情视频采集";
        item5.img = [UIImage imageNamed:@"list_video"];
        item5.executeCode = ^{
            LxPrintf(@"警情视频采集");
            
            
        };
        [self.mArr_items addObject:item5];
    }
    
    self.layout_height_table.constant = self.mArr_items.count * 49;
    [self.view layoutIfNeeded];
    
    LRSettingSectionModel *section1 = [[LRSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 0;
    
    section1.sectionHeaderBgColor = [UIColor clearColor];
    section1.itemArray = self.mArr_items;
    
    self.sectionArray = @[section1];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LRSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"setting";
    
    LRSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    LRSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    LRSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.sectionHeaderName;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    LRSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.sectionHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LRSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    LRSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (itemModel.executeCode) {
        itemModel.executeCode();
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 47, 0, 0)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 47, 0, 0)];
}

#pragma mark - buttonMethods

- (IBAction)handleBtnSettingClicked:(id)sender {
    UserSetVC *userVC = [[UserSetVC alloc] init];
    [self.navigationController pushViewController:userVC animated:YES];
    
}



#pragma mark - AKTabBar Method

- (NSString *)tabImageName{
    return @"tabbar_user_n";
}

- (NSString *)tabSelectedImageName{
    return @"tabbar_user_h";
}

- (NSString *)tabTitle{
    return NSLocalizedString(@"我的", nil);
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    LxPrintf(@"UserHomeVC dealloc");
    
}

@end
