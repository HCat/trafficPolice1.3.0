//
//  AttendancePoliceCell.h
//  移动采集
//
//  Created by hcat on 2019/4/3.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoliceDistributeAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface AttendancePoliceCell : UITableViewCell

@property (nonatomic, strong) PoliceAnalyzeModel * viewModel;

@end

NS_ASSUME_NONNULL_END
