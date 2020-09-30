//
//  UserCenterVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/5/18.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "UserCenterVC.h"
#import "LRSettingCell.h"
#import "LRSettingItemModel.h"
#import "LRSettingSectionModel.h"

#import "UserModel.h"
#import "FeedbackVC.h"


@interface UserCenterVC ()

@property (nonatomic,strong) NSArray  *sectionArray;

@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_height_bottom;

@end

@implementation UserCenterVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"个人中心";
    //self.layout_height_bottom.constant = Height_TabBar;
    
    [self.zx_navBar setBackgroundColor:[UIColor whiteColor]];
    self.zx_navTintColor = UIColorFromRGB(0x333333);
    
    
    self.tb_content.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setupSections];
    
}


- (void)setupSections
{
    
    @weakify(self);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    LRSettingItemModel *item1 = [[LRSettingItemModel alloc]init];
    item1.funcName = @"姓名";
    item1.detailText = [UserModel getUserModel].realName;
    item1.accessoryType = LRSettingAccessoryTypeNone;
    
    LRSettingItemModel *item2 = [[LRSettingItemModel alloc]init];
    item2.funcName = @"手机";
    item2.detailText = [UserModel getUserModel].phone;
    item2.accessoryType = LRSettingAccessoryTypeNone;
    
    LRSettingItemModel *item3 = [[LRSettingItemModel alloc]init];
    item3.funcName = @"部门";
    item3.detailText = [UserModel getUserModel].departmentName;
    item3.accessoryType = LRSettingAccessoryTypeNone;
    
    LRSettingItemModel *item4 = [[LRSettingItemModel alloc]init];
    item4.funcName = @"单位";
    item4.detailText = [UserModel getUserModel].orgName;
    item4.accessoryType = LRSettingAccessoryTypeNone;
    
    
    
    LRSettingItemModel *item5 = [[LRSettingItemModel alloc]init];
    item5.accessoryType = LRSettingAccessoryTypeDisclosureIndicator;
    item5.funcName = @"版本更新";
    item5.detailText = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    item5.executeCode = ^{
        LxPrintf(@"版本更新");
        [ShareFun checkForVersionUpdates];
    };
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    float folderSize = [ShareFun folderSizeAtPath:documentPath];
    
    LRSettingItemModel *item6 = [[LRSettingItemModel alloc]init];
    item6.accessoryType = LRSettingAccessoryTypeDisclosureIndicator;
    item6.funcName = @"清除缓存";
    item6.detailText = [NSString stringWithFormat:@"%.2fM", folderSize];
    
    item6.executeCode = ^{
        LxPrintf(@"清除缓存");
        @strongify(self);
        [self clearCache];
        
    };
    
    LRSettingItemModel *item7 = [[LRSettingItemModel alloc]init];
    item7.accessoryType = LRSettingAccessoryTypeDisclosureIndicator;
    item7.funcName = @"意见反馈";
    item7.executeCode = ^{
        LxPrintf(@"意见反馈");
        @strongify(self);
        FeedbackVC *t_vc = [FeedbackVC new];
        [self.navigationController pushViewController:t_vc animated:YES];
    };
    
    
    LRSettingSectionModel *section1 = [[LRSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 10;
    
    section1.sectionHeaderBgColor = [UIColor clearColor];
    section1.itemArray = @[item1,item2,item3,item4];
    
    LRSettingSectionModel *section2 = [[LRSettingSectionModel alloc]init];
    section2.sectionHeaderHeight = 50;
    section2.sectionHeaderName = @"版本信息";
    
    section2.sectionHeaderBgColor = [UIColor clearColor];
    section2.itemArray = @[item5,item6,item7];
    
    self.sectionArray = @[section1,section2];
}

#pragma mark - 清除缓存

- (void)clearCache{

    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        LxPrintf(@"%@", cachPath);
        @strongify(self);
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        LxPrintf(@"files :%lu",(unsigned long)[files count]);
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            LxPrintf(@"清理成功");
            LRSettingSectionModel *sectionModel = self.sectionArray[1];
            LRSettingItemModel *itemModel = sectionModel.itemArray[1];
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            float t_folderSize = [ShareFun folderSizeAtPath:documentPath];
            itemModel.detailText = [NSString stringWithFormat:@"%.2fM", t_folderSize];
            [self.tb_content reloadData];
            
            [LRShowHUD showSuccess:@"缓存清理成功" duration:1.5f inView:self.view config:nil];
        });
    
    });

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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    LRSettingSectionModel *sectionModel = self.sectionArray[section];
    UIView *view = [[UIView alloc] init];

    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    view.backgroundColor = DefaultBGColor;
    
    UILabel *label = [[UILabel alloc] init];
    
    label.frame = CGRectMake(15, 20, view.frame.size.width, view.frame.size.height-20);
    label.text = sectionModel.sectionHeaderName;
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = UIColorFromRGB(0x666666);
    [view addSubview:label];
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    LRSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.sectionHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LRSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    LRSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (itemModel.executeCode) {
        itemModel.executeCode();
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    
    LRSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    if (indexPath.row == (sectionModel.itemArray.count-1)) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, SCREEN_WIDTH);
    }
    
}

#pragma mark - btnAction

- (IBAction)handleBtnQuitClicked:(id)sender {
    
    [ShareFun loginOut];
    
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


- (void)dealloc{
    NSLog(@"%@ - dealloc", [self class]);
}

@end
