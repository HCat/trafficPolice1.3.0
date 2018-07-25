//
//  AccidentUpFactory.h
//  移动采集
//
//  Created by hcat on 2018/7/18.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccidentPeopleModel.h"


@interface AccidentPeopleMapModel : AccidentPeopleModel

@property(nonatomic,copy)    NSString * vehicle;    //车辆类型
@property(nonatomic,copy)    NSString * direct;     //行驶状态
@property(nonatomic,copy)    NSString * behaviour;  //违法行为
@property(nonatomic,copy)    NSString * insuranceCompany;   //保险公司
@property(nonatomic,copy)    NSString * responsibility;     //责任
@property(nonatomic,strong)  NSMutableArray *certMarray; //证件照片数据

@property (nonatomic,strong) AccidentGetCodesResponse * codes;

- (void)addCertInArrayWithImageInfo:(ImageFileInfo *)imageInfo withType:(NSString *)type;


@end

@interface AccidentUpFactory : NSObject

@property(nonatomic,strong) AccidentUpParam * param;

@property(nonatomic,strong) NSMutableArray <AccidentPeopleMapModel *> * peopleMarray;

#pragma mark - 初始化

-(instancetype)init;

#pragma mark - 通过道路名称获取得到道路ID

- (void)setRoadId:(NSString *)roadName;

#pragma mark - 判断当事人输入的身份证或者手机号是否正确

- (BOOL) validateNumber;

#pragma mark - 配置事故图片

- (void)configParamInImageArray:(NSArray *)array;

#pragma mark - 配置当事人信息

- (void)configParamInPeopleInfo;

#pragma mark - 配置即将上传的证件照片

- (void)configParamInCertFilesAndCertRemarks;

#pragma mark - 判断是否可以提交

- (void)juegeCanCommit;

@end
