//
//  PartyModel.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/28.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "PartyModel.h"

@interface PartyModel()

@property(nonatomic,assign) NSInteger type;
@property(nonatomic,strong) AccidentSaveParam * param;

@end

@implementation PartyModel

@synthesize partyName = _partyName;
@synthesize partyIdNummber = _partyIdNummber;
@synthesize partyCarNummber = _partyCarNummber;
@synthesize partyPhone = _partyPhone;

@synthesize partyVehicleId = _partyVehicleId;
@synthesize partyInsuranceCompanyId = _partyInsuranceCompanyId;
@synthesize partyPolicyNo = _partyPolicyNo;
@synthesize partyResponsibilityId = _partyResponsibilityId;
@synthesize partyDirectId = _partyDirectId;
@synthesize partyBehaviourId = _partyBehaviourId;
@synthesize partyIsZkCl = _partyIsZkCl;
@synthesize partyIsZkXsz = _partyIsZkXsz;
@synthesize partyIsZkJsz = _partyIsZkJsz;
@synthesize partyIsZkSfz = _partyIsZkSfz;
@synthesize partyDescribe = _partyDescribe;

-(instancetype)initWithIndex:(NSInteger)type withParam:(AccidentSaveParam *)param{

    if (self = [super init]) {
        self.type = type;
        self.param = param;
    }
    
    return self;
    
}

#pragma mark - set

- (void)setPartyName:(NSString *)partyName{
    _partyName = partyName;
    
    if (self.type == 0) {
        self.param.ptaName = _partyName;
    }else if (self.type == 1){
        self.param.ptbName = _partyName;
    }else{
        self.param.ptcName = _partyName;
    }

}


- (void)setPartyIdNummber:(NSString *)partyIdNummber{
    
    
    partyIdNummber = [partyIdNummber uppercaseString];
    _partyIdNummber = partyIdNummber;
    
    if (self.type == 0) {
        self.param.ptaIdNo = _partyIdNummber;
    }else if (self.type == 1){
        self.param.ptbIdNo = _partyIdNummber;
    }else{
        self.param.ptcIdNo = _partyIdNummber;
    }
    
}


- (void)setPartyCarNummber:(NSString *)partyCarNummber{
    
    _partyCarNummber = partyCarNummber;
    
    if (self.type == 0) {
        self.param.ptaCarNo = _partyCarNummber;
    }else if (self.type == 1){
        self.param.ptbCarNo = _partyCarNummber;
    }else{
        self.param.ptcCarNo = _partyCarNummber;
    }
    
}


- (void)setPartyPhone:(NSString *)partyPhone{
    
    _partyPhone = partyPhone;
    
    if (self.type == 0) {
        self.param.ptaPhone = _partyPhone;
    }else if (self.type == 1){
        self.param.ptbPhone = _partyPhone;
    }else{
        self.param.ptcPhone = _partyPhone;
    }
    
}

- (void)setPartyPolicyNo:(NSString *)partyPolicyNo{
    
    _partyPolicyNo = partyPolicyNo;
    
    if (self.type == 0) {
        self.param.ptaPolicyNo = _partyPolicyNo;
    }else if (self.type == 1){
        self.param.ptbPolicyNo = _partyPolicyNo;
    }else{
        self.param.ptcPolicyNo = _partyPolicyNo;
    }
    
}


- (void)setPartyVehicleId:(NSNumber *)partyVehicleId{
    
    _partyVehicleId = partyVehicleId;
    
    if (self.type == 0) {
        self.param.ptaVehicleId = _partyVehicleId;
    }else if (self.type == 1){
        self.param.ptbVehicleId = _partyVehicleId;
    }else{
        self.param.ptcVehicleId = _partyVehicleId;
    }

}


- (void)setPartyInsuranceCompanyId:(NSNumber *)partyInsuranceCompanyId{
    
    _partyInsuranceCompanyId = partyInsuranceCompanyId;
    
    if (self.type == 0) {
        self.param.ptaInsuranceCompanyId = _partyInsuranceCompanyId;
    }else if (self.type == 1){
        self.param.ptbInsuranceCompanyId = _partyInsuranceCompanyId;
    }else{
        self.param.ptcInsuranceCompanyId = _partyInsuranceCompanyId;
    }
    
    
    
}


- (void)setPartyResponsibilityId:(NSNumber *)partyResponsibilityId{
    _partyResponsibilityId = partyResponsibilityId;
    
    if (self.type == 0) {
        self.param.ptaResponsibilityId = _partyResponsibilityId;
    }else if (self.type == 1){
        self.param.ptbResponsibilityId = _partyResponsibilityId;
    }else{
        self.param.ptcResponsibilityId = _partyResponsibilityId;
    }

    
}


- (void)setPartyDirectId:(NSNumber *)partyDirectId{
    
    _partyDirectId = partyDirectId;
    
    if (self.type == 0) {
        self.param.ptaDirect = _partyDirectId;
    }else if (self.type == 1){
        self.param.ptbDirect = _partyDirectId;
    }else{
        self.param.ptcDirect = _partyDirectId;
    }

}

- (void)setPartyBehaviourId:(NSNumber *)partyBehaviourId{
    _partyBehaviourId = partyBehaviourId;
    
    if (self.type == 0) {
        self.param.ptaBehaviourId = _partyBehaviourId;
    }else if (self.type == 1){
        self.param.ptbBehaviourId = _partyBehaviourId;
    }else{
        self.param.ptcBehaviourId = _partyBehaviourId;
    }
    
}


- (void)setPartyIsZkCl:(NSNumber *)partyIsZkCl{
    
    _partyIsZkCl = partyIsZkCl;
    
    if (self.type == 0) {
        self.param.ptaIsZkCl = _partyIsZkCl;
    }else if (self.type == 1){
        self.param.ptbIsZkCl = _partyIsZkCl;
    }else{
        self.param.ptcIsZkCl = _partyIsZkCl;
    }
    
}


- (void)setPartyIsZkXsz:(NSNumber *)partyIsZkXsz{
    _partyIsZkXsz = partyIsZkXsz;
    
    if (self.type == 0) {
        self.param.ptaIsZkXsz = _partyIsZkXsz;
    }else if (self.type == 1){
        self.param.ptbIsZkXsz = _partyIsZkXsz;
    }else{
        self.param.ptcIsZkXsz = _partyIsZkXsz;
    }
    
}


- (void)setPartyIsZkJsz:(NSNumber *)partyIsZkJsz{
    _partyIsZkJsz = partyIsZkJsz;
    
    if (self.type == 0) {
        self.param.ptaIsZkJsz = _partyIsZkJsz;
    }else if (self.type == 1){
        self.param.ptbIsZkJsz = _partyIsZkJsz;
    }else{
        self.param.ptcIsZkJsz = _partyIsZkJsz;
    }

}


- (void)setPartyIsZkSfz:(NSNumber *)partyIsZkSfz{
    _partyIsZkSfz = partyIsZkSfz;
    
    if (self.type == 0) {
        self.param.ptaIsZkSfz = _partyIsZkSfz;
    }else if (self.type == 1){
        self.param.ptbIsZkSfz = _partyIsZkSfz;
    }else{
        self.param.ptcIsZkSfz = _partyIsZkSfz;
    }

    
}


- (void)setPartyDescribe:(NSString *)partyDescribe{
    
    _partyDescribe = partyDescribe;
    
    if (self.type == 0) {
        self.param.ptaDescribe = _partyDescribe;
    }else if (self.type == 1){
        self.param.ptbDescribe = _partyDescribe;
    }else{
        self.param.ptcDescribe = _partyDescribe;
    }
    
}

- (NSString *)partyName{
    
    if (self.type == 0) {
        _partyName = self.param.ptaName;
    }else if (self.type == 1){
        _partyName = self.param.ptbName;
    }else{
        _partyName = self.param.ptcName;
    }
    
    return _partyName;
    
}

- (NSString *)partyIdNummber{
    
    if (self.type == 0) {
        _partyIdNummber = self.param.ptaIdNo;
    }else if (self.type == 1){
        _partyIdNummber = self.param.ptbIdNo;
    }else{
        _partyIdNummber = self.param.ptcIdNo;
    }
    
    return _partyIdNummber;
}

- (NSString *)partyCarNummber{
    
    if (self.type == 0) {
        _partyCarNummber = self.param.ptaCarNo;
    }else if (self.type == 1){
        _partyCarNummber = self.param.ptbCarNo;
    }else{
        _partyCarNummber = self.param.ptcCarNo;
    }
    
    return _partyCarNummber;
    
}

- (NSString *)partyPhone{
    
    if (self.type == 0) {
        _partyPhone = self.param.ptaPhone;
    }else if (self.type == 1){
        _partyPhone = self.param.ptbPhone;
    }else{
        _partyPhone = self.param.ptcPhone;
    }

    return _partyPhone;
    
}

- (NSString *)partyPolicyNo{
    
    if (self.type == 0) {
        _partyPolicyNo = self.param.ptaPolicyNo;
    }else if (self.type == 1){
        _partyPolicyNo = self.param.ptbPolicyNo;
    }else{
        _partyPolicyNo = self.param.ptcPolicyNo;
    }
    
    return _partyPolicyNo;
    
}


- (NSNumber *)partyVehicleId{
    
    if (self.type == 0) {
        _partyVehicleId = self.param.ptaVehicleId;
    }else if (self.type == 1){
        _partyVehicleId = self.param.ptbVehicleId;
    }else{
        _partyVehicleId = self.param.ptcVehicleId;
    }
    
    return _partyVehicleId;
}

- (NSNumber *)partyInsuranceCompanyId{
    if (self.type == 0) {
        _partyInsuranceCompanyId = self.param.ptaInsuranceCompanyId;
    }else if (self.type == 1){
        _partyInsuranceCompanyId = self.param.ptbInsuranceCompanyId;
    }else{
        _partyInsuranceCompanyId = self.param.ptcInsuranceCompanyId ;
    }
    
    return _partyInsuranceCompanyId;
}

- (NSNumber *)partyResponsibilityId{
    
    if (self.type == 0) {
        _partyResponsibilityId = self.param.ptaResponsibilityId;
    }else if (self.type == 1){
        _partyResponsibilityId = self.param.ptbResponsibilityId;
    }else{
        _partyResponsibilityId = self.param.ptcResponsibilityId;
    }
    
    return _partyResponsibilityId;
    
}

- (NSNumber *)partyDirectId{
    
    if (self.type == 0) {
        _partyDirectId = self.param.ptaDirect;
    }else if (self.type == 1){
        _partyDirectId = self.param.ptbDirect;
    }else{
        _partyDirectId = self.param.ptcDirect;
    }
    
    return _partyDirectId;
}

- (NSNumber *)partyBehaviourId{
    
    if (self.type == 0) {
        _partyBehaviourId = self.param.ptaBehaviourId;
    }else if (self.type == 1){
        _partyBehaviourId = self.param.ptbBehaviourId;
    }else{
        _partyBehaviourId = self.param.ptcBehaviourId;
    }
    
    return _partyBehaviourId;
}

- (NSNumber *)partyIsZkCl{
    
    if (self.type == 0) {
        _partyIsZkCl = self.param.ptaIsZkCl;
    }else if (self.type == 1){
        _partyIsZkCl = self.param.ptbIsZkCl;
    }else{
        _partyIsZkCl = self.param.ptcIsZkCl;
    }
    
    return _partyIsZkCl;
    
}

- (NSNumber *)partyIsZkXsz{
    if (self.type == 0) {
        _partyIsZkXsz = self.param.ptaIsZkXsz;
    }else if (self.type == 1){
        _partyIsZkXsz = self.param.ptbIsZkXsz;
    }else{
        _partyIsZkXsz = self.param.ptcIsZkXsz;
    }
    
    return _partyIsZkXsz;
    
}

- (NSNumber *)partyIsZkJsz{
    
    if (self.type == 0) {
        _partyIsZkJsz = self.param.ptaIsZkJsz;
    }else if (self.type == 1){
        _partyIsZkJsz = self.param.ptbIsZkJsz;
    }else{
        _partyIsZkJsz = self.param.ptcIsZkJsz;
    }
    
    return _partyIsZkJsz;
    
}

- (NSNumber *)partyIsZkSfz{
    
    if (self.type == 0) {
        _partyIsZkSfz = self.param.ptaIsZkSfz;
    }else if (self.type == 1){
        _partyIsZkSfz = self.param.ptbIsZkSfz;
    }else{
        _partyIsZkSfz = self.param.ptcIsZkSfz;
    }
    
    return _partyIsZkSfz;
    
}

- (NSString *)partyDescribe{
    
    if (self.type == 0) {
        _partyDescribe = self.param.ptaDescribe;
    }else if (self.type == 1){
        _partyDescribe = self.param.ptbDescribe;
    }else{
        _partyDescribe = self.param.ptcDescribe;
    }
    
    return _partyDescribe;
}

#pragma mark - 

- (NSString *)partycarType{
    
    if (self.partyVehicleId) {
        self.partycarType = [self.codes searchNameWithModelId:[self.partyVehicleId integerValue] WithArray:self.codes.vehicle];
        return _partycarType;
        
    }else{
        
        return nil;
        
    }


}

- (NSString *)partyDriverDirect{
    
    if (self.partyDirectId) {
        self.partyDriverDirect = [self.codes searchNameWithModelType:[self.partyDirectId integerValue] WithArray:self.codes.driverDirect];
        
        return _partyDriverDirect;
        
    }else{
        
        return nil;
        
    }
    
}

- (NSString *)partyBehaviour{
    
    if (self.partyBehaviourId) {
        
        self.partyBehaviour = [self.codes searchNameWithModelId:[self.partyBehaviourId integerValue] WithArray:self.codes.behaviour];
        
        return _partyBehaviour;
        
    }else{
        
        return nil;
        
    }
    
}

- (NSString *)partyInsuranceCompany{
    
    if (self.partyInsuranceCompanyId) {
        
        self.partyInsuranceCompany = [self.codes searchNameWithModelId:[self.partyInsuranceCompanyId integerValue] WithArray:self.codes.insuranceCompany];
        return _partyInsuranceCompany;
        
    }else{
        
        return nil;
        
    }
    
}

- (NSString *)partyResponsibility{
    
    if (self.partyResponsibilityId) {
        
        self.partyResponsibility = [self.codes searchNameWithModelId:[self.partyResponsibilityId integerValue] WithArray:self.codes.responsibility];

        return _partyResponsibility;
        
    }else{
        
        return nil;
        
    }
    
}


- (AccidentGetCodesResponse *)codes{

    _codes = [ShareValue sharedDefault].accidentCodes;
    return _codes;
}

- (void)dealloc{
    LxPrintf(@"PartyModel dealloc");

}


@end
