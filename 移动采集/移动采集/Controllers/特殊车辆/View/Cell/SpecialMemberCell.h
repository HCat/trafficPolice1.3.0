//
//  SpecialMemberCell.h
//  移动采集
//
//  Created by hcat on 2018/9/11.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialCarAPI.h"

typedef void(^MemberEditBlock)(SpecialCarModel * model);
typedef void(^MemberDeleteBlock)(SpecialCarModel * model);

@interface SpecialMemberCell : UITableViewCell

@property (nonatomic,strong) SpecialCarModel * model;
@property (nonatomic,copy) MemberEditBlock editBlock;
@property (nonatomic,copy) MemberDeleteBlock deleteBlock;


@end
