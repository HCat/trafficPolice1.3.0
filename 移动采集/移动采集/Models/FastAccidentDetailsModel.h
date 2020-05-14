//
//  FastAccidentDetailsModel.h
//  移动采集
//
//  Created by hcat on 2018/7/25.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccidentPicListModel.h"
#import "AccidentDetailsModel.h"
#import "AccidentPeopleModel.h"

@interface FastAccidentDetailsModel : NSObject

@property (nonatomic,strong) AccidentInfoModel * accident; //事故对象
@property (nonatomic,copy) NSArray<AccidentPicListModel *> *picList;
@property (nonatomic,copy) NSArray<AccidentPeopleModel *> *accidentList;

@end
