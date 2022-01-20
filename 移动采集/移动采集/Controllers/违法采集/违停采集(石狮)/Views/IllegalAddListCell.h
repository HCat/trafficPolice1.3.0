//
//  IllegalAddListCell.h
//  移动采集
//
//  Created by hcat-89 on 2020/2/19.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IllegalAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface IllegalAddListCell : UITableViewCell

@property(nonatomic,strong)IllegalParkListModel * model;
@property (nonatomic,strong) NSNumber * permission;               //确认异常权限 true有 false没有
@property (nonatomic,assign) BOOL isStreet;


@end

NS_ASSUME_NONNULL_END
