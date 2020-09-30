//
//  DutyPoliceCell.h
//  移动采集
//
//  Created by hcat on 2018/6/13.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DutyPoliceCell : UITableViewCell

@property (strong,nonatomic) NSArray * arr_group; //分组
@property (assign,nonatomic) NSInteger type; //是辅警还是民警 0代表民警 1代表辅警


- (CGFloat)getHeightWithArr:(NSArray *)arr_group;

@end
