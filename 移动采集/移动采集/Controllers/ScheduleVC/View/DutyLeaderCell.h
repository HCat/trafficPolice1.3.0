//
//  DutyLeaderCell.h
//  移动采集
//
//  Created by hcat on 2018/6/13.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DutyLeaderCell : UITableViewCell

@property (strong, nonatomic) NSArray *arr_leader;


- (CGFloat)getHeightWithArray:(NSArray *)array;

@end
