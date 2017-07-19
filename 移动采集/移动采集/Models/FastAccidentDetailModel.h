//
//  FastAccidentDetailModel.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/19.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccidentModel.h"
#import "AccidentPicListModel.h"

@interface FastAccidentDetailModel : NSObject

@property (nonatomic,strong) AccidentModel * accident; //事故对象
@property (nonatomic,copy) NSArray<AccidentPicListModel *> *picList;


@end
