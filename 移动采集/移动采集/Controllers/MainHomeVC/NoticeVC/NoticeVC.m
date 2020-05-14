//
//  NoticeVC.m
//  移动采集
//
//  Created by hcat on 2018/6/29.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "NoticeVC.h"

@interface NoticeVC ()

@property (weak, nonatomic) IBOutlet UILabel *lb_content;



@end

@implementation NoticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公告";
    _lb_content.text = self.content;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"NoticeVC dealloc");
    
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
