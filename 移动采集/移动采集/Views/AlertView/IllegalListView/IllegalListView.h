//
//  IllegalListView.h
//  移动采集
//
//  Created by hcat on 2018/8/15.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IllegalParkAlertView.h"
#import "IllegalParkAPI.h"


typedef void(^IllegalListSelectAcion)(NSNumber *illegalId);
typedef void(^ParkDidSelectAction)(ParkAlertActionType actionType);

@interface IllegalListView : UIView

@property (nonatomic, copy) NSString * btnTitleString;
@property (nonatomic, copy) NSString * deckCarNo;
@property (nonatomic, strong) NSArray <IllegalListModel *> * illegalList;

@property (nonatomic,copy) ParkDidSelectAction block;
@property (nonatomic,copy) IllegalListSelectAcion selectedBlock;

+ (IllegalListView *)initCustomView;

@end
