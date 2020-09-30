//
//  IllegalMessageCell.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/6/10.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IllegalCollectModel.h"
#import "ExposureCollectAPI.h"

@interface IllegalMessageCell : UITableViewCell

@property (nonatomic,strong) IllegalCollectModel *illegalCollect;
//如果是违停的状况，则又分为3种状态，选填，默认1:违停，1001:朝向错误，1002:锁车，2001:信息录入
@property (nonatomic,strong) ExposureCollectModel * exposureCollectModel;
@property (nonatomic,assign) ParkType subType;

- (float)heightWithIllegal;

@end
