//
//  AddressBookHomeVC.m
//  移动采集
//
//  Created by hcat on 2017/10/17.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AddressBookHomeVC.h"
#import "LGUIView.h"

@interface AddressBookHomeVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) LGUIView *v_index;

@end

@implementation AddressBookHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    [self creatLGIndexView];
    
}

#pragma mark - private

- (void)creatLGIndexView{
    
    NSMutableArray * arr = [NSMutableArray new];
    for (int i = 0; i < 26; i ++)
    {
        unichar ch = 65 + i;
        NSString * str = [NSString stringWithUTF8String:(char *)&ch];
        [arr addObject:str];
    }
    
    _v_index = [[LGUIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 40, 40, self.view.bounds.size.height - 80 - 50) indexArray:arr];
    _v_index.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_v_index];
    
    [_v_index selectIndexBlock:^(NSInteger section)
     {
         [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
                                 animated:NO
                           scrollPosition:UITableViewScrollPositionTop];
     }];
    
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    unichar ch = 65 + section;
    NSString * str = [NSString stringWithUTF8String:(char *)&ch];
    return str;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 26;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:35/255.0 green:94/255.0 blue:44/255.0 alpha:1.0];
    
    return cell;
}



#pragma mark - AKTabBar Method

- (NSString *)tabImageName{
    return @"tabbar_addressBook_n";
}

- (NSString *)tabSelectedImageName{
    return @"tabbar_addressBook_n";
}

- (NSString *)tabTitle{
    return nil;
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    LxPrintf(@"AddressBookHomeVC dealloc");

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
