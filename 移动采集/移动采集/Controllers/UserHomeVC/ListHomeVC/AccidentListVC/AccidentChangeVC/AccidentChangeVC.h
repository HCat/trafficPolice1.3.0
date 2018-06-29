//
//  AccidentChangeVC.h
//  移动采集
//
//  Created by hcat on 2017/8/16.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "AccidentAPI.h"
#import "FastAccidentAPI.h"

@interface AccidentChangeVC : HideTabSuperVC

@property (nonatomic,assign) AccidentType accidentType;                 //辨别是事故类型还是快处类型
@property (nonatomic,strong) AccidentSaveParam *param;                  //处理参数
@property (nonatomic,copy) NSArray <AccidentPicListModel *> * picList;  //已经上传的图片


@end
