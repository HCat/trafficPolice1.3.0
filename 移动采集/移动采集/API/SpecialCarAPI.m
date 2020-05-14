//
//  SpecialCarAPI.m
//  移动采集
//
//  Created by hcat on 2018/9/11.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "SpecialCarAPI.h"

#pragma mark - 特殊传车辆管理组的获取和组的车牌获取API

@implementation SpecialCarModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"carId" : @"id",
             };
}

@end

@implementation SpecialGroupListParam

@end

@implementation SpecialGroupListReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [SpecialCarModel class]
             };
}

@end

@implementation SpecialGroupListManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_SPECIAL_GETGROUPLIST;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (SpecialGroupListReponse *)specialReponse{
    
    if (self.responseModel.data) {
        _specialReponse = [SpecialGroupListReponse modelWithDictionary:self.responseModel.data];
        return _specialReponse;
    }
    
    return nil;
}

@end

#pragma mark - 特殊传车辆管理获取识别记录列表API

@implementation SpecialRecordModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"recordId" : @"id",
             };
}

@end

@implementation SpecialRecordListParam

@end

@implementation SpecialRecordListReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [SpecialRecordModel class]
             };
}

@end

@implementation SpecialRecordListManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_SPECIAL_GETRECORDLIST;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (SpecialRecordListReponse *)specialReponse{
    
    if (self.responseModel.data) {
        _specialReponse = [SpecialRecordListReponse modelWithDictionary:self.responseModel.data];
        return _specialReponse;
    }
    
    return nil;
}

@end


#pragma mark - 特殊传车辆管理获取识别记录详情

@implementation SpecialRecordDetailModel

@end


@implementation SpecialRecordDetailManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_SPECIAL_RECORDDETAIL;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"id":_recordId};
}

//返回参数
- (SpecialRecordDetailModel *)specialReponse{
    
    if (self.responseModel.data) {
        _specialReponse =  [SpecialRecordDetailModel modelWithDictionary:self.responseModel.data[@"identifyRecord"]];
        return _specialReponse;
        
    }
    
    return nil;
}


@end


#pragma mark - 特殊车辆管理保存组合保存车辆

@implementation SpecialSaveGroupParam

@end

@implementation SpecialSaveGroupManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_SPECIAL_SAVEGROUP;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}


@end

#pragma mark - 删除车辆

@implementation SpecialDeleteManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_SPECIAL_DELETE;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"groupId":_groupId};
}

//返回参数

@end

#pragma mark - 获取设置通知人员列表

@implementation SpecialNoticeModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"noticeId" : @"id",
             };
}

@end

@implementation SpecialNoticeParam

@end

@implementation SpecialNoticeReponse

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [SpecialNoticeModel class]
             };
}

@end

@implementation SpecialNoticeManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_SPECIAL_SETNOTICEGROUP;
}

//请求参数
- (nullable id)requestArgument
{
    return self.param.modelToJSONObject;
}

//返回参数
- (SpecialNoticeReponse *)specialReponse{
    
    if (self.responseModel.data) {
        _specialReponse = [SpecialNoticeReponse modelWithDictionary:self.responseModel.data];
        return _specialReponse;
    }
    
    return nil;
}

@end


#pragma mark - 保存置通知人员

@implementation SpecialSaveNoticeManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_SPECIAL_SAVENOTICEGROUP;
}

//请求参数
- (nullable id)requestArgument
{
    return @{@"groupId":_groupId,
             @"ids":_ids
             };
}

//返回参数

@end


