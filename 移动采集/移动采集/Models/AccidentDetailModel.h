//
//  AccidentDetailModel.h
//  trafficPolice
//
//  Created by hcat on 2017/5/19.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccidentModel.h"
#import "AccidentPicListModel.h"

@interface AccidentVoModel : NSObject

@property (nonatomic,strong) NSNumber * ptaIsZkCl;        //甲方是否暂扣车辆 0否1是
@property (nonatomic,strong) NSNumber * ptaIsZkXsz;       //甲方是否暂扣行驶证 0否1是
@property (nonatomic,strong) NSNumber * ptaIsZkJsz;       //甲方是否暂扣驾驶证 0否1是
@property (nonatomic,strong) NSNumber * ptaIsZkSfz;       //甲方是否暂扣身份证 0否1是
@property (nonatomic,strong) NSNumber * ptbIsZkCl;        //乙方是否暂扣车辆 0否1是
@property (nonatomic,strong) NSNumber * ptbIsZkXsz;       //乙方是否暂扣行驶证 0否1是
@property (nonatomic,strong) NSNumber * ptbIsZkJsz;       //乙方是否暂扣驾驶证 0否1是
@property (nonatomic,strong) NSNumber * ptbIsZkSfz;       //乙方是否暂扣身份证 0否1是
@property (nonatomic,strong) NSNumber * ptcIsZkCl;        //丙方是否暂扣车辆 0否1是
@property (nonatomic,strong) NSNumber * ptcIsZkXsz;       //丙方是否暂扣行驶证 0否1是
@property (nonatomic,strong) NSNumber * ptcIsZkJsz;       //丙方是否暂扣驾驶证 0否1是
@property (nonatomic,strong) NSNumber * ptcIsZkSfz;       //丙方是否暂扣身份证 0否1是

@end


@interface AccidentDetailModel : NSObject

@property (nonatomic,strong) AccidentModel *accident;      //事故对象
@property (nonatomic,copy) NSArray<AccidentPicListModel *> *picList;    //图片列表
@property (nonatomic,strong) AccidentVoModel *accidentVo;  //是否扣留对象 是否扣留车辆、驾驶证、行驶证、身份证放此对象中


@end
