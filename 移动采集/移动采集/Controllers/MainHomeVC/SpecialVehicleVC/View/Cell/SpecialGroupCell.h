//
//  SpecialGroupCell.h
//  移动采集
//
//  Created by hcat on 2018/9/10.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SpecialCarAPI.h"

@interface SpecialGroupCell : UITableViewCell

@property (nonatomic,strong) NSNumber * groupId;
@property (nonatomic,strong) SpecialCarModel * model;


@end
