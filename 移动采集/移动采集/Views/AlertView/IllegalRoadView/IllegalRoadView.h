//
//  IllegalRoadView.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/5/29.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonAPI.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^IllegalRoadViewSelectAcion)(CommonGetRoadModel * model);

@interface IllegalRoadView : UIView

@property (nonatomic, copy) NSString * roadName;

@property (nonatomic,strong) NSArray < CommonGetRoadModel *> * arr_content;
@property (nonatomic,copy) IllegalRoadViewSelectAcion block;


+ (IllegalRoadView *)initCustomView;

@end

NS_ASSUME_NONNULL_END
