//
//  AccidentPeopleChangeCell.h
//  移动采集
//
//  Created by hcat on 2018/7/20.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccidentUpFactory.h"

typedef void(^ChangMoreInfoBlock)(BOOL isShowMoreInfo);


@interface AccidentPeopleChangeCell : UITableViewCell

@property (nonatomic,assign) AccidentType accidentType;

@property (nonatomic,strong) AccidentPeopleMapModel * model;

@property (nonatomic,assign) BOOL isShowMoreInfo;

@property (nonatomic,copy) ChangMoreInfoBlock block;




@end
