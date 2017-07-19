//
//  UserHomeVC.m
//  移动采集
//
//  Created by hcat on 2017/7/18.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "UserHomeVC.h"

@interface UserHomeVC ()

@property (nonatomic,strong) NSArray  *sectionArray; /**< section模型数组*/
@property (weak, nonatomic) IBOutlet UITableView *tb_content;

@end

@implementation UserHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    [self setupSections];
}

#pragma mark - setUp

- (void)setupSections
{
    //************************************section1
    WS(weakSelf);
    XBSettingItemModel *item1 = [[XBSettingItemModel alloc]init];
    item1.funcName = @"用户名";
    item1.executeCode = ^{
        LxPrintf(@"用户名");
        
    };
    item1.detailText = self.userName;
    item1.accessoryType = XBSettingAccessoryTypeNone;
    
    XBSettingItemModel *item2 = [[XBSettingItemModel alloc]init];
    item2.funcName = @"手机号码";
    item2.detailText = self.phoneNummer;
    item2.accessoryType = XBSettingAccessoryTypeNone;
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    float folderSize = [ShareFun folderSizeAtPath:documentPath];
    
    XBSettingItemModel *item3 = [[XBSettingItemModel alloc]init];
    item3.funcName = @"清除缓存";
    item3.detailText = [NSString stringWithFormat:@"%.2fM", folderSize];
    
    item3.executeCode = ^{
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
    
    item3.accessoryType = XBSettingAccessoryTypeNone;
    
    XBSettingItemModel *item4 = [[XBSettingItemModel alloc]init];
    item4.funcName = @"意见反馈";
    item4.executeCode = ^{
        LxPrintf(@"意见反馈");
        SW(strongSelf, weakSelf);
        FeedbackVC *t_vc = [[FeedbackVC alloc] init];
        [strongSelf.navigationController pushViewController:t_vc animated:YES];
    };
    item4.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item5 = [[XBSettingItemModel alloc]init];
    item5.funcName = @"关于";
    item5.executeCode = ^{
        LxPrintf(@"关于");
        SW(strongSelf, weakSelf);
        AboutAppVC *t_vc = [[AboutAppVC alloc] init];
        [strongSelf.navigationController pushViewController:t_vc animated:YES];
        
    };
    item5.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 18;
    section1.sectionHeaderBgColor = [UIColor clearColor];
    section1.itemArray = @[item1,item2,item3,item4,item5];
    
    self.sectionArray = @[section1];
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
