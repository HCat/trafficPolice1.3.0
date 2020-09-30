//
//  IllegalCollectListCell.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/24.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IllegalParkListModel.h"
#import "ExposureCollectAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface IllegalCollectListCell : UITableViewCell

@property (nonatomic,strong) IllegalParkListModel *model;

@property (nonatomic,strong) ExposureCollectListModel * model_exposure;
@end

NS_ASSUME_NONNULL_END
