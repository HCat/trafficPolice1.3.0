//
//  MainAPI.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/10.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "MainAPI.h"

@implementation PoliceMenuListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"menuListId" : @"id",
             @"t_template" : @"template"
             };
}

@end

@implementation MainPoliceMenuListManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_MAIN_POLICEMENULIST;
}

//请求参数
- (nullable id)requestArgument
{
    return nil;
}

//返回参数
- (NSArray <PoliceMenuListModel * > *)mainResponse{
    
    if (self.responseModel) {
        _mainResponse = [NSArray modelArrayWithClass:[PoliceMenuListModel class] json:self.responseJSONObject[@"data"]];
        return _mainResponse;
    }
    
    return nil;
}

@end


#pragma mark - app个人信息头像

@implementation MainLoginCheckManger


//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_MAIN_LOGINCHECK;
}

//请求参数
- (nullable id)requestArgument
{
    return nil;
}

//返回参数
- (NSString *)photoUrl{
    
    if (self.responseModel) {
        _photoUrl = self.responseModel.data[@"photoUrl"];
        return _photoUrl;
    }
    
    return nil;
}


@end


#pragma mark - 机构全部菜单

@implementation MenuInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"t_template" : @"template",
             };
}

@end

@implementation MainGetMenuInfoManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_MAIN_GETMENUINFO;
}

//请求参数
- (nullable id)requestArgument{
    
    if (_menuType) {
        return @{@"menuType":_menuType
                 };
        
    }else{
        return nil;
    }

}

//返回参数
- (NSArray <MenuInfoModel * > *)mainResponse{
    
    if (self.responseModel) {
        _mainResponse = [NSArray modelArrayWithClass:[MenuInfoModel class] json:self.responseJSONObject[@"data"][@"menuList"]];
        return _mainResponse;
    }
    
    return nil;
    
}


@end

#pragma mark - 保存个人常用菜单

@implementation MainGetMenuInfoSaveManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_MAIN_MENUINFOSAVE;
}

//请求参数
- (nullable id)requestArgument{
    
    if (_menuListArr) {
        return @{@"menuListArr":_menuListArr
                 };
        
    }else{
        return nil;
    }

}


@end


#pragma mark - 菜单类型列表

@implementation MenuTypeModel



@end

@implementation MainMenuTypeManger

//请求的url，不包括域名`域名通过YTKNetworkConfig配置`
- (NSString *)requestUrl
{
    return URL_MAIN_GETMENUTYPE;
}

//请求参数
- (nullable id)requestArgument{
    
    return nil;

}

//返回参数
- (NSArray <MenuTypeModel * > *)mainResponse{
    
    if (self.responseModel) {
        _mainResponse = [NSArray modelArrayWithClass:[MenuTypeModel class] json:self.responseJSONObject[@"data"]];
        return _mainResponse;
    }
    
    return nil;
    
}


@end

