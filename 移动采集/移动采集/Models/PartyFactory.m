//
//  PartyFactory.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/28.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "PartyFactory.h"


@interface PartyFactory()

@property(nonatomic,strong)PartyModel * partyA; //甲方
@property(nonatomic,strong)PartyModel * partyB; //乙方
@property(nonatomic,strong)PartyModel * partyC; //丙方

@property (nonatomic, strong) AccidentGetCodesResponse * codes;

@end


@implementation PartyFactory

-(instancetype)init{
    if (self = [super init]) {
        self.param = [[AccidentSaveParam alloc] init];
        self.arr_credentials = [NSMutableArray array];
    }
    return self;
}

#pragma mark - set && get 

- (AccidentGetCodesResponse *)codes{
    
    _codes = [ShareValue sharedDefault].accidentCodes;
    
    return _codes;
}


#pragma mark - 

-(void)setAccidentType:(AccidentType)accidentType{

    _accidentType = accidentType;
    
    if (self.partyA) {
        self.partyA.accidentType = _accidentType;
    }
    
    if (self.partyB) {
        self.partyB.accidentType = _accidentType;
    }
    
    if (self.partyC) {
        self.partyC.accidentType = _accidentType;
    }


}


-(void)setIndex:(NSInteger)index{

    _index = index;
    
    if (_index == 0) {
        
        if (self.partyA == nil) {
            self.partyA = [[PartyModel alloc] initWithIndex:0 withParam:self.param];
            self.partyA.accidentType = self.accidentType;
        }
        
        self.partModel = self.partyA;
        
    }else if (_index == 1){
        
        if (self.partyB == nil) {
            self.partyB = [[PartyModel alloc] initWithIndex:1 withParam:self.param];
            self.partyB.accidentType = self.accidentType;
        }
        
        self.partModel = self.partyB;
    
    }else{
        
        if (self.partyC == nil) {
            self.partyC = [[PartyModel alloc] initWithIndex:2 withParam:self.param];
            self.partyC.accidentType = self.accidentType;
        }
        
        self.partModel = self.partyC;

    }

}


#pragma mark - 判断输入的身份证或者手机号码是否正确
- (BOOL) validateNumber{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    if (self.param.ptaIdNo) {
        if([ShareFun validateIDCardNumber:self.param.ptaIdNo] == NO){
            [LRShowHUD showError:@"甲方身份证格式错误" duration:1.f inView:window config:nil];
            return NO;
        }
    }
    
    if (self.param.ptaPhone) {
        if ([ShareFun validatePhoneNumber:self.param.ptaPhone] == NO) {
            [LRShowHUD showError:@"甲方手机号码格式错误" duration:1.f inView:window config:nil];
            return NO;
        }
    }
    
    if (self.param.ptbIdNo) {
        if([ShareFun validateIDCardNumber:self.param.ptbIdNo] == NO){
            [LRShowHUD showError:@"乙方身份证格式错误" duration:1.f inView:window config:nil];
            return NO;
        }
    }
    
    if (self.param.ptbPhone) {
        if ([ShareFun validatePhoneNumber:self.param.ptbPhone] == NO) {
            [LRShowHUD showError:@"甲方手机号码格式错误" duration:1.0f inView:window config:nil];
            return NO;
        }
    }
    
    if (self.param.ptcIdNo) {
        if([ShareFun validateIDCardNumber:self.param.ptcIdNo] == NO){
            [LRShowHUD showError:@"丙方身份证格式错误" duration:1.0f inView:window config:nil];
            return NO;
        }
    }
    
    if (self.param.ptcPhone) {
        if ([ShareFun validatePhoneNumber:self.param.ptcPhone] == NO) {
            [LRShowHUD showError:@"丙方手机号码格式错误" duration:1.0f inView:window config:nil];
            return NO;
        }
    }
    
    return YES;
};


#pragma mark - 通过道路名称获取得到道路ID
- (void)setRoadId:(NSString *)roadName{
    if (roadName) {
        NSInteger IdNo = [self.codes searchNameWithModelName:roadName WithArray:self.codes.road];
        _param.roadId = @(IdNo);
    }else{
        _param.roadId = nil;
    }
   
    
}

#pragma mark - 添加到证件图片到数组中用于上传用的


- (void)addCredentialItemsByImageInfo:(ImageFileInfo *)imageInfo withType:(NSString *)type{

    if ([type isEqualToString:@"身份证"]) {
        if (self.index == 0) {
            [self addCredentialItemsByImageInfo:imageInfo withTitle:@"甲方身份证"];
        }else if (self.index == 1){
            [self addCredentialItemsByImageInfo:imageInfo withTitle:@"乙方身份证"];
        }else{
            [self addCredentialItemsByImageInfo:imageInfo withTitle:@"丙方身份证"];
        }
    }else if ([type isEqualToString:@"驾驶证"]){
        if (self.index == 0) {
            [self addCredentialItemsByImageInfo:imageInfo withTitle:@"甲方驾驶证"];
        }else if (self.index == 1){
            [self addCredentialItemsByImageInfo:imageInfo withTitle:@"乙方驾驶证"];
        }else{
            [self addCredentialItemsByImageInfo:imageInfo withTitle:@"丙方驾驶证"];
        }
    
    
    }else if ([type isEqualToString:@"行驶证"]){
        if (self.index == 0) {
            [self addCredentialItemsByImageInfo:imageInfo withTitle:@"甲方行驶证"];
        }else if (self.index == 1){
            [self addCredentialItemsByImageInfo:imageInfo withTitle:@"乙方行驶证"];
        }else{
            [self addCredentialItemsByImageInfo:imageInfo withTitle:@"丙方行驶证"];
        }
        
        
    }
    


}

- (void)addCredentialItemsByImageInfo:(ImageFileInfo *)imageInfo withTitle:(NSString *)title{
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    [t_dic setObject:imageInfo forKey:@"certFiles"];
    [t_dic setObject:title forKey:@"certRemarks"];
    
    [self.arr_credentials addObject:t_dic];
}

- (void)configParamInCertFilesAndCertRemarks{
    
    if (self.arr_credentials && self.arr_credentials.count > 0) {
        NSMutableArray *t_arr_certFiles = [NSMutableArray array];
        NSMutableArray *t_arr_certRemarks = [NSMutableArray array];
        for (int i = 0; i < self.arr_credentials.count; i++) {
            NSMutableDictionary *t_dic = self.arr_credentials[i];
            ImageFileInfo *imageInfo = [t_dic objectForKey:@"certFiles"];
            NSString *t_title = [t_dic objectForKey:@"certRemarks"];
            [t_arr_certFiles addObject:imageInfo];
            [t_arr_certRemarks addObject:t_title];
            
        }
        
        self.param.certFiles = t_arr_certFiles;
        self.param.certRemarks = t_arr_certRemarks;
    }
    
}


#pragma mark - 判断是否可以提交

-(BOOL)juegeCanCommit{
    LxDBObjectAsJson(self.param);
    if (self.param.happenTimeStr.length >0 && self.param.roadId && self.param.address.length > 0 && self.param.ptaName.length > 0 && self.param.ptaIdNo.length > 0 && self.param.ptaVehicleId && self.param.ptaPhone.length > 0) {
         return YES;
    }else{
         return NO;
    }
}

- (void)dealloc{

    LxPrintf(@"PartyFactory dealloc");
}

@end
