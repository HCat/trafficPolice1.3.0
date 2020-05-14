//
//  IllegalParkAlertView.h
//  移动采集
//
//  Created by hcat on 2018/3/13.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ParkAlertActionType) {
    ParkAlertActionTypeLeft,
    ParkAlertActionTypeRight,
};

typedef void(^ParkDidSelectAction)(ParkAlertActionType actionType);


@interface IllegalParkAlertView : UIView

@property (nonatomic,copy) ParkDidSelectAction block;

+ (IllegalParkAlertView *)initCustomView;

@end
