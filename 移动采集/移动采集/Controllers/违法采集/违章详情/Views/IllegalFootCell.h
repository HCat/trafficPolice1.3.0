//
//  IllegalFootCell.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/6/10.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IllegalFootCellBlock)();

@interface IllegalFootCell : UITableViewCell

@property(nonatomic,copy)IllegalFootCellBlock illegalUpAbnormalBlock;

@end
