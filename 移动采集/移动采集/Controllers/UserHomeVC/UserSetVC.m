//
//  UserSetVC.m
//  移动采集
//
//  Created by hcat on 2017/7/20.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "UserSetVC.h"
#import "XBConst.h"
#import "XBSettingCell.h"
#import "XBSettingItemModel.h"
#import "XBSettingSectionModel.h"

#import "UserModel.h"
#import "HSUpdateApp.h"
#import "SRAlertView.h"

@interface UserSetVC ()

@property (nonatomic,strong) NSArray  *sectionArray; /**< section模型数组*/
@property (weak, nonatomic) IBOutlet UITableView *tb_content;

@property (nonatomic,copy) NSString *storeVersion;
@property (nonatomic,copy) NSString *openUrl;

@end

@implementation UserSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self setupSections];
}

#pragma mark - setUp

- (void)setupSections
{
    //************************************section1
    WS(weakSelf);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    XBSettingItemModel *item1 = [[XBSettingItemModel alloc]init];
    item1.funcName = @"用户名";
    item1.detailText = [UserModel getUserModel].name;
    item1.accessoryType = XBSettingAccessoryTypeNone;
    
    
    XBSettingItemModel *item2 = [[XBSettingItemModel alloc]init];
    item2.funcName = @"手机号码";
    item2.detailText = [UserModel getUserModel].phone;
    item2.accessoryType = XBSettingAccessoryTypeNone;
    
    
    XBSettingItemModel *item3 = [[XBSettingItemModel alloc]init];
    item3.funcName = @"版本更新";
    item3.detailText = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    item3.executeCode = ^{
        LxPrintf(@"版本更新");
        
    };
    item3.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    float folderSize = [ShareFun folderSizeAtPath:documentPath];
    
    XBSettingItemModel *item4 = [[XBSettingItemModel alloc]init];
    item4.funcName = @"清除缓存";
    item4.detailText = [NSString stringWithFormat:@"%.2fM", folderSize];
    
    item4.executeCode = ^{
        LxPrintf(@"清除缓存");
        SW(strongSelf, weakSelf);
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
            
            [strongSelf performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
        });
        
    };
    item4.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    
    
    XBSettingItemModel *item5 = [[XBSettingItemModel alloc]init];
    item5.funcName = @"意见反馈";
    item5.executeCode = ^{
        LxPrintf(@"意见反馈");
        
        
    };
    item5.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 10;
    
    section1.sectionHeaderBgColor = [UIColor clearColor];
    section1.itemArray = @[item1,item2];
    
    XBSettingSectionModel *section2 = [[XBSettingSectionModel alloc]init];
    section2.sectionHeaderHeight = 10;
    
    section2.sectionHeaderBgColor = [UIColor clearColor];
    section2.itemArray = @[item3,item4];
    
    XBSettingSectionModel *section3 = [[XBSettingSectionModel alloc]init];
    section3.sectionHeaderHeight = 10;
    
    section3.sectionHeaderBgColor = [UIColor clearColor];
    section3.itemArray = @[item5];
    
    self.sectionArray = @[section1,section2,section3];
}

-(void)clearCacheSuccess
{
    LxPrintf(@"清理成功");
    XBSettingSectionModel *sectionModel = self.sectionArray[1];
    XBSettingItemModel *itemModel = sectionModel.itemArray[1];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    float t_folderSize = [ShareFun folderSizeAtPath:documentPath];
    itemModel.detailText = [NSString stringWithFormat:@"%.2fM", t_folderSize];
    [_tb_content reloadData];
    
    [LRShowHUD showSuccess:@"缓存清理成功" duration:1.5f inView:self.view config:nil];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    XBSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"setting";
    
    XBSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    
    XBSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[XBSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    XBSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.sectionHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XBSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (itemModel.executeCode) {
        itemModel.executeCode();
    }
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
