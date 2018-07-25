//
//  AccidentPeopleView.h
//  移动采集
//
//  Created by hcat on 2018/7/18.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccidentUpFactory.h"

typedef void(^AccidentPeopleChangeBlock)(NSInteger index);


@interface AccidentPeopleView : UIView

@property (nonatomic,assign) AccidentType accidentType;
@property (nonatomic,strong) AccidentPeopleMapModel *model;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy)   AccidentPeopleChangeBlock block;
@property (nonatomic,assign,readonly) CGFloat height;

+ (AccidentPeopleView *)initCustomView;

@end
