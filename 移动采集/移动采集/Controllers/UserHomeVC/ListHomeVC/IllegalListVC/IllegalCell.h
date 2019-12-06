//
//  IllegalCell.h
//  trafficPolice
//
//  Created by hcat on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IllegalParkListModel.h"
#import "ExposureCollectAPI.h"

@interface IllegalCell : UITableViewCell

@property (nonatomic,strong) IllegalParkListModel *model;
@property (nonatomic,strong) ExposureCollectListModel * model_exposure;
@end
