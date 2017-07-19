//
//  PartyFactory.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/28.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PartyModel.h"
#import "ImageFileInfo.h"

@interface PartyFactory : NSObject

@property(nonatomic,strong) AccidentSaveParam * param;              //需求方
@property(nonatomic,assign) NSInteger           index;              //设置index
@property(nonatomic,strong) PartyModel        * partModel;          //当前的partModel;
@property(nonatomic,strong) NSMutableArray    * arr_credentials;    //用于存储证件照片，以及证件对应名称值
@property(nonatomic,assign) AccidentType        accidentType;       //用于判断是快处还是事故录入

#pragma mark - 初始化

-(instancetype)init;


#pragma mark - 判断输入的身份证或者手机号码是否正确

- (BOOL)validateNumber;

#pragma mark - 通过道路名称获取得到道路ID

- (void)setRoadId:(NSString *)roadName;

#pragma mark - 用于上传证件照片用的

- (void)addCredentialItemsByImageInfo:(ImageFileInfo *)imageInfo withType:(NSString *)type;

- (void)addCredentialItemsByImageInfo:(ImageFileInfo *)imageInfo withTitle:(NSString *)title;

- (void)configParamInCertFilesAndCertRemarks;

#pragma mark - 判断是否可以提交

-(BOOL)juegeCanCommit;

//- (PartyModel *)getPartyModelWithIndex:(NSInteger)index; //通过index获取partymodel对象

@end
