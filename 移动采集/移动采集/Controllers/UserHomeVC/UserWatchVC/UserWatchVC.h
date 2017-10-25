//
//  UserWatchVC.h
//  移动采集
//
//  Created by hcat on 2017/10/24.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "BaseViewController.h"


@class MonthModel;



@interface UserWatchVC : BaseViewController

@end

//CollectionViewHeader
@interface CalendarHeaderView : UICollectionReusableView
@end


//UICollectionViewCell
@interface CalendarCell : UICollectionViewCell

@property (weak, nonatomic) UILabel *dayLabel;
@property (strong, nonatomic) UIView *v_today;
@property (strong, nonatomic) MonthModel *monthModel;

@end


//存储模型
@interface MonthModel : NSObject

@property (assign, nonatomic) NSInteger dayValue;
@property (strong, nonatomic) NSDate *dateValue;
@property (assign, nonatomic) BOOL isSelectedDay;

@end
