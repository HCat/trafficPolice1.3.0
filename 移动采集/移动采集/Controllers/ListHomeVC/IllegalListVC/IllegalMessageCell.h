//
//  IllegalMessageCell.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/6/10.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IllegalCollectModel.h"

@interface IllegalMessageCell : UITableViewCell

@property (nonatomic,strong) IllegalCollectModel *illegalCollect;


- (float)heightWithIllegal;

@end
