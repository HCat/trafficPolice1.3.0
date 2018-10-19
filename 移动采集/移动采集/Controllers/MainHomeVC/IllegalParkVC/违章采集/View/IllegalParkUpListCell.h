//
//  IllegalParkUpListCell.h
//  移动采集
//
//  Created by hcat on 2018/9/29.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYSideslipCell.h"
#import "IllegalParkUpListViewModel.h"
#import "AccidentUpListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IllegalParkUpListCell : LYSideslipCell

@property (nonatomic,strong) IllegalUpListCellViewModel * viewModel;
@property (nonatomic,strong) AccidentUpListCellViewModel * accidentViewModel;

@end

NS_ASSUME_NONNULL_END
