//
//  AccidentPeopleCell.h
//  移动采集
//
//  Created by hcat on 2018/7/12.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccidentPeopleCell : UITableViewCell

@property (nonatomic,assign) AccidentType accidentType;     //事故纠纷类型
@property(nonatomic,strong) NSMutableArray *peopleArray;

- (CGFloat)heightOfCell;


@end
