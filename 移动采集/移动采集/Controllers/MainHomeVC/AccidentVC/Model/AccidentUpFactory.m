//
//  AccidentUpFactory.m
//  移动采集
//
//  Created by hcat on 2018/7/18.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "AccidentUpFactory.h"
#import "UserModel.h"

@implementation AccidentPeopleMapModel

- (NSMutableArray *)certMarray{
    
    if (_certMarray == nil) {
        _certMarray = [NSMutableArray array];
    }
    
    return _certMarray;
}


- (NSString *)vehicle{
    
    if (self.vehicleId) {
        self.vehicle = [self.codes searchNameWithModelId:[self.vehicleId integerValue] WithArray:self.codes.vehicle];
        return _vehicle;
        
    }else{
        
        return nil;
        
    }
    
    
}

- (NSString *)direct{
    
    if (self.directId) {
        self.direct = [self.codes searchNameWithModelType:[self.directId integerValue] WithArray:self.codes.driverDirect];
        
        return _direct;
        
    }else{
        
        return nil;
        
    }
    
}

- (NSString *)behaviour{
    
    if (self.behaviourId) {
        
        self.behaviour = [self.codes searchNameWithModelId:[self.behaviourId integerValue] WithArray:self.codes.behaviour];
        
        return _behaviour;
        
    }else{
        
        return nil;
        
    }
    
}

- (NSString *)insuranceCompany{
    
    if (self.insuranceCompanyId) {
        
        self.insuranceCompany = [self.codes searchNameWithModelId:[self.insuranceCompanyId integerValue] WithArray:self.codes.insuranceCompany];
        return _insuranceCompany;
        
    }else{
        
        return nil;
        
    }
    
}

- (NSString *)responsibility{
    
    if (self.responsibilityId) {
        
        self.responsibility = [self.codes searchNameWithModelId:[self.responsibilityId integerValue] WithArray:self.codes.responsibility];
        
        return _responsibility;
        
    }else{
        
        return nil;
        
    }
    
}

- (AccidentGetCodesResponse *)codes{
    
    _codes = [ShareValue sharedDefault].accidentCodes;
    return _codes;
}

- (void)addCertInArrayWithImageInfo:(ImageFileInfo *)imageInfo withType:(NSString *)type{
    
    NSString *title = [NSString stringWithFormat:@"%ld号%@",self.sorting.integerValue,type];
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    [t_dic setObject:imageInfo forKey:@"certFiles"];
    [t_dic setObject:title forKey:@"certRemarks"];
    
    [self.certMarray addObject:t_dic];
    
}


@end

#pragma mark - AccidentUpFactory

@interface AccidentUpFactory()

@property (nonatomic, strong) AccidentGetCodesResponse * codes;

@end

@implementation AccidentUpFactory

-(instancetype)init{
    if (self = [super init]) {
        self.param = [[AccidentUpParam alloc] init];
        [self setUpPeopleMarray];
    }
    return self;
}

#pragma mark - set && get

- (AccidentGetCodesResponse *)codes{
    
    _codes = [ShareValue sharedDefault].accidentCodes;
    
    return _codes;
}


#pragma mark - 配置当事人信息列表(最初阶段拥有两个当事人信息)
- (void)setUpPeopleMarray{
    
    self.peopleMarray = [NSMutableArray array];
    
    for (int i = 0; i < 2; i++) {
        AccidentPeopleMapModel *model = [[AccidentPeopleMapModel alloc] init];
        model.sorting = @(i+1);
        [self.peopleMarray addObject:model];
    }
    
}

#pragma mark - 通过道路名称获取得到道路ID
- (void)setRoadId:(NSString *)roadName{
    if (roadName) {
        NSInteger IdNo = [self.codes searchNameWithModelName:roadName WithArray:self.codes.road];
        _param.roadId = @(IdNo);
    }else{
        _param.roadId = nil;
    }
    
}

#pragma mark - 判断当事人输入的身份证或者手机号是否正确

- (BOOL) validateNumber{
    
    if (_peopleMarray && _peopleMarray.count > 0) {
        
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        
        for (AccidentPeopleMapModel *model in _peopleMarray) {
            if (model.idNo) {
                if([ShareFun validateIDCardNumber:model.idNo] == NO){
                    [LRShowHUD showError:[NSString stringWithFormat:@"%ld号身份证格式错误",[model.sorting integerValue]] duration:1.f inView:window config:nil];
                    return NO;
                }
            }
            
//            if (model.phone) {
//                if ([ShareFun validatePhoneNumber:model.phone] == NO) {
//                    [LRShowHUD showError:[NSString stringWithFormat:@"%ld号手机号码格式错误",[model.sorting integerValue]] duration:1.f inView:window config:nil];
//                    return NO;
//                }
//            }
            
            
        }
    }

    return YES;
}

#pragma mark - 配置当事人信息

- (void)configParamInPeopleInfo{
    
    NSMutableArray *modelMarray = [NSMutableArray array];
    for (int i = 0; i < _peopleMarray.count; i++) {
        AccidentPeopleMapModel *model = _peopleMarray[i];
        
        AccidentPeopleModel * newModel = [AccidentPeopleModel new];
        
        newModel.name = model.name;
        newModel.idNo = model.idNo;
        newModel.carNo = model.carNo;
        newModel.phone = model.phone;
        newModel.policyNo = model.policyNo;
        newModel.insuranceCompanyId = model.insuranceCompanyId;
        newModel.vehicleId = model.vehicleId;
        newModel.responsibilityId = model.responsibilityId;
        newModel.directId = model.directId;
        newModel.behaviourId = model.behaviourId;
        newModel.isZkCl = [model.isZkCl intValue] == 1 ? @([model.isZkCl intValue]) : nil;
        newModel.isZkXsz = [model.isZkXsz intValue] == 1 ? @([model.isZkXsz intValue]) : nil;
        newModel.isZkJsz = [model.isZkJsz intValue] == 1 ? @([model.isZkJsz intValue]) : nil;
        newModel.isZkSfz = [model.isZkSfz intValue] == 1 ? @([model.isZkSfz intValue]) : nil;
        newModel.resume = model.resume;
        newModel.sorting = model.sorting;
    
        [modelMarray addObject:newModel];
        
    }
    
    self.param.accidentInfoStr = [modelMarray modelToJSONString];
    
}


#pragma mark - 配置即将上传的证件照片
- (void)configParamInCertFilesAndCertRemarks{
    
    NSMutableArray *t_arr_certFiles = [NSMutableArray array];
    NSMutableArray *t_arr_certRemarks = [NSMutableArray array];
    
    for (int i = 0; i < _peopleMarray.count; i++) {
        AccidentPeopleMapModel *model = _peopleMarray[i];
        if (model.certMarray && model.certMarray.count > 0) {
            for (int j = 0; j < model.certMarray.count; j++) {
                NSMutableDictionary *t_dic = model.certMarray[i];
                ImageFileInfo *imageInfo = [t_dic objectForKey:@"certFiles"];
                NSString *t_title = [t_dic objectForKey:@"certRemarks"];
                [t_arr_certFiles addObject:imageInfo];
                [t_arr_certRemarks addObject:t_title];
            }
        }
       
    }
    
    if (t_arr_certFiles.count > 0 && t_arr_certRemarks.count > 0) {
        self.param.certFiles = t_arr_certFiles;
        self.param.certRemarks = t_arr_certRemarks;
    }
   
}

#pragma mark - 配置事故图片

- (void)configParamInImageArray:(NSArray *)array{
    
    if (array && array.count > 0) {
        NSMutableArray *t_arr = [NSMutableArray array];
        for (UIImage *t_image in array) {
            ImageFileInfo *t_imageFileInfo = [[ImageFileInfo alloc] initWithImage:t_image withName:key_files];
            [t_arr addObject:t_imageFileInfo];
        }
        self.param.files = t_arr;
    }
   
}

#pragma mark - 判断是否可以提交

-(void)juegeCanCommit{
    LxDBObjectAsJson(self.param);
    
    if ([UserModel getUserModel].isInsurance) {
        
        if (self.param.happenTimeStr.length >0 && self.param.roadId && self.param.address.length > 0 ) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotification_juegeCommit" object:@1];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotification_juegeCommit" object:@0];
        }
    }else{
        if (self.param.causesType && self.param.happenTimeStr.length >0 && self.param.roadId && self.param.address.length > 0) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotification_juegeCommit" object:@1];
        }else{
             [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotification_juegeCommit" object:@0];
        }
        
    }
    
    
}


@end
