//
//  DataStatisticsListVC.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/12/16.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "BaseViewController.h"

#import "LRBaseTableView.h"
#import "AccidentCell.h"
#import "AccidentCompleteVC.h"
#import "DataStatisticsListViewModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface DataStatisticsListVC : BaseViewController


- (instancetype)initWithViewModel:(DataStatisticsListViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
