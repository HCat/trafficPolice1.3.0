//
//  IllegalParkDetailModel.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/21.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccidentPicListModel.h"
#import "IllegalCollectModel.h"

@interface IllegalParkDetailModel : NSObject

@property (nonatomic,strong) IllegalCollectModel *illegalCollect; //事故对象
@property (nonatomic,copy) NSArray<AccidentPicListModel *> *picList;
@end
