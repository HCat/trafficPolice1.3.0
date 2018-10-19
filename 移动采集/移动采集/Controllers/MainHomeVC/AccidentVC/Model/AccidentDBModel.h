//
//  AccidentDBModel.h
//  移动采集
//
//  Created by hcat on 2018/10/19.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccidentAPI.h"


NS_ASSUME_NONNULL_BEGIN

@interface AccidentDBModel : NSObject

@property (nonatomic,copy)   NSString * ownId;                //属于谁未上传的违章记录
@property (nonatomic,strong) NSNumber * commitTime;           //提交时间
@property (nonatomic,copy)   NSString * commitTimeString;     //提交时间 YYYY-mm-dd
@property (nonatomic,strong) NSNumber * type;                 //事故 3001 快处 3002
@property (nonatomic,strong)  NSNumber * accidentId;         //有id为修改功能，无id则是新增
@property (nonatomic,copy)    NSString * happenTimeStr;     //事故时间 必填，格式：yyyy-MM-dd HH:mm:ss
@property (nonatomic,strong)  NSNumber * roadId;            //道路ID 必填，从通用值【道路】获取ID
@property (nonatomic,strong)  NSString * roadName;          //道路名称
@property (nonatomic,copy)    NSString * address;           //事故地点
@property (nonatomic,strong)  NSNumber * causesType;        //事故成因ID 从通用值【事故成因】获取ID
@property (nonatomic,copy)    NSString * weather;           //天气 默认值从天气接口获取，可编辑
@property (nonatomic,copy)    NSString * injuredNum;        //受伤人数
@property (nonatomic,strong)  NSNumber * roadType;          //事故地点类型 从通用值【事故地点类型】获取ID
@property (nonatomic,copy)    NSString * accidentInfoStr;   //事故人员信息
@property (nonatomic,copy)    NSArray  * files;             //事故图片 列表，最多可上传30张
@property (nonatomic,copy)    NSArray  * certFiles;         //证件图片 识别的图片，文件格式列表。识别后图片不需要显示出来
@property (nonatomic,copy)    NSArray  * certRemarks;       //证件图片名称 识别的图片名称，字符串列表。和证件图片一对一，名称统一命名，命名规则如下
@property (nonatomic,strong)  NSNumber * offtime;           //缓存时间


- (instancetype)initWithAccidentUpParam:(AccidentUpParam *) param;
- (AccidentUpParam *)mapAccidentUpParam;
- (AccidentDetailsModel *)mapAccidentDetailModel;

- (void)save;
- (void)deleteDB;
+(NSArray *)localArrayFormType:(NSNumber *)type;

@end

NS_ASSUME_NONNULL_END
