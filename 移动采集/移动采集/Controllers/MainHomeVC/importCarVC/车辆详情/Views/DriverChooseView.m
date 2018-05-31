//
//  DriverChooseView.m
//  移动采集
//
//  Created by hcat on 2018/5/28.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "DriverChooseView.h"
#import <PureLayout.h>
#import "AlertView.h"

@interface DriverChooseView()

@property (strong, nonatomic) UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *img_top;


@end


@implementation DriverChooseView


+ (DriverChooseView *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"DriverChooseView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.tableView setDelegate:(id<UITableViewDelegate> _Nullable)self];
    [self.tableView setDataSource:(id<UITableViewDataSource> _Nullable)self];
    [self addSubview:self.tableView];
    [self.tableView configureForAutoLayout];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 30, 0, 30) excludingEdge:ALEdgeTop];
    [self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.img_top];
    
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setArr_driver:(NSArray *)arr_driver{
    _arr_driver = arr_driver;
    
    if (_arr_driver) {
        [self.tableView reloadData];
    }
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_arr_driver) {
        return _arr_driver.count + 1;
    }else{
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 49;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DriverChooseCellId"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DriverChooseCellId"] ;
        UILabel *t_lb = [[UILabel alloc] init];
        t_lb.textColor = UIColorFromRGB(0x444444);
        t_lb.font = [UIFont systemFontOfSize:14];
        t_lb.tag = 13;
        [cell.contentView addSubview:t_lb];
        [t_lb configureForAutoLayout];
        [t_lb autoCenterInSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *t_lable = [cell.contentView viewWithTag:13];
    [t_lable setHighlighted:NO];
    if (indexPath.row != _arr_driver.count) {
        VehicleDriverModel *t_model = _arr_driver[indexPath.row];
        t_lable.text = t_model.driverName;
    }else{
        t_lable.text = @"其他";
    }
   
   
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
     UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    UILabel *t_lable = [cell.contentView viewWithTag:13];
    [t_lable setHighlighted:YES];
    [t_lable setHighlightedTextColor:UIColorFromRGB(0x659FFE)];
    
    if (indexPath.row == _arr_driver.count) {
        if (self.block) {
            self.block(nil);
        }
        
    }else{
        
        if (self.block) {
            VehicleDriverModel *t_model = _arr_driver[indexPath.row];
            self.block(t_model);
        }
    }
    
    AlertView * alertView = (AlertView *)self.superview;
    [alertView handleBtnDismissClick:nil];
    
}



#pragma mark - buttonAction

- (IBAction)handleBtnCloseClicked:(id)sender {
    
    AlertView * alertView = (AlertView *)self.superview;
    
    [alertView handleBtnDismissClick:nil];
    
    
    
}

- (void)dealloc{
    LxPrintf(@"DriverChooseView dealloc");
    
}



@end
