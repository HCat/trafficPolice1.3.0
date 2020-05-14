//
//  UserSetVC.m
//  移动采集
//
//  Created by hcat on 2017/7/20.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "UserSetVC.h"

#import "LRSettingCell.h"
#import "LRSettingItemModel.h"
#import "LRSettingSectionModel.h"

#import "UserModel.h"

#import "FeedbackVC.h"
#import "SuperLogger.h"


@interface UserSetVC ()

@property (nonatomic,strong) NSArray  *sectionArray;

@property (weak, nonatomic) IBOutlet UITableView *tb_content;

@end

@implementation UserSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [_tb_content setSeparatorInset:UIEdgeInsetsZero];
    [_tb_content setLayoutMargins:UIEdgeInsetsZero];
    [self setupSections];
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showLog)];
    tapGesture.numberOfTapsRequired = 10;
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - setUp

- (void)setupSections
{
    
    WS(weakSelf);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    LRSettingItemModel *item1 = [[LRSettingItemModel alloc]init];
    item1.funcName = @"用户名";
    item1.detailText = [UserModel getUserModel].realName;
    item1.accessoryType = LRSettingAccessoryTypeNone;
    
    LRSettingItemModel *item2 = [[LRSettingItemModel alloc]init];
    item2.funcName = @"手机号码";
    item2.detailText = [UserModel getUserModel].phone;
    item2.accessoryType = LRSettingAccessoryTypeNone;
    
    
    LRSettingItemModel *item3 = [[LRSettingItemModel alloc]init];
    item3.accessoryType = LRSettingAccessoryTypeDisclosureIndicator;
    item3.funcName = @"版本更新";
    item3.detailText = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    item3.executeCode = ^{
        LxPrintf(@"版本更新");
        [ShareFun checkForVersionUpdates];
    };
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    float folderSize = [ShareFun folderSizeAtPath:documentPath];
    
    LRSettingItemModel *item4 = [[LRSettingItemModel alloc]init];
    item4.accessoryType = LRSettingAccessoryTypeDisclosureIndicator;
    item4.funcName = @"清除缓存";
    item4.detailText = [NSString stringWithFormat:@"%.2fM", folderSize];
    
    item4.executeCode = ^{
        LxPrintf(@"清除缓存");
        SW(strongSelf, weakSelf);
        [strongSelf clearCache];
        
    };
    
    LRSettingItemModel *item5 = [[LRSettingItemModel alloc]init];
    item5.accessoryType = LRSettingAccessoryTypeDisclosureIndicator;
    item5.funcName = @"意见反馈";
    item5.executeCode = ^{
        LxPrintf(@"意见反馈");
        SW(strongSelf, weakSelf);
        FeedbackVC *t_vc = [FeedbackVC new];
        [strongSelf.navigationController pushViewController:t_vc animated:YES];
    };
    
    
    LRSettingSectionModel *section1 = [[LRSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 10;
    
    section1.sectionHeaderBgColor = [UIColor clearColor];
    section1.itemArray = @[item1,item2];
    
    LRSettingSectionModel *section2 = [[LRSettingSectionModel alloc]init];
    section2.sectionHeaderHeight = 10;
    
    section2.sectionHeaderBgColor = [UIColor clearColor];
    section2.itemArray = @[item3,item4];
    
    LRSettingSectionModel *section3 = [[LRSettingSectionModel alloc]init];
    section3.sectionHeaderHeight = 10;
    
    section3.sectionHeaderBgColor = [UIColor clearColor];
    section3.itemArray = @[item5];
    
    self.sectionArray = @[section1,section2,section3];
}

#pragma mark - 清除缓存

- (void)clearCache{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        LxPrintf(@"%@", cachPath);
        
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
            [_tb_content reloadData];
            
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
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.item = itemModel;
    return cell;
    
}

#pragma - mark UITableViewDelegate

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
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}


#pragma mark - btnAction

- (IBAction)handleBtnQuitClicked:(id)sender {
    
    [ShareFun loginOut];
    
}

#pragma mark - 显示日志重定向列表

- (void)showLog{
    [self.navigationController presentViewController:[[SuperLogger sharedInstance] getListView] animated:YES completion:nil];
}

#pragma mark -dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    LxPrintf(@"UserSetVC dealloc");
    
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
