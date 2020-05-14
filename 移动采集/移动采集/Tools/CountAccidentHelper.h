//
//  CountAccidentHelper.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/28.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountAccidentHelper : NSObject
LRSingletonH(Default)


@property(nonatomic,strong) NSNumber *state;
@property(nonatomic,strong) NSString *carNo;  //通过车牌号查询是否有违法行为
@property(nonatomic,strong) NSString *telNum; //通过手机号查询是否有违法行为
@property(nonatomic,strong) NSString *idNo;   //通过手机号查询是否有违法行为


@end
