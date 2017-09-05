//
//  MemberInfoModel.h
//  移动采集
//
//  Created by hcat on 2017/9/5.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberInfoModel : NSObject

@property (nonatomic,copy) NSString * name;                 //运输主体名称
@property (nonatomic,strong) NSNumber * memtype;            //运输主体性质:1土方车 2水泥砼车 3砂石子车
@property (nonatomic,copy) NSString * memFormNo;            //自编号前缀
@property (nonatomic,strong) NSNumber * licenseTimeStart;   //营业执照有效期,开始时间
@property (nonatomic,strong) NSNumber * licenseTimeEnd;     //营业执照有效期,结束时间
@property (nonatomic,copy) NSString * address;              //详细地址
@property (nonatomic,copy) NSString * licenseno;            //组织机构代码
@property (nonatomic,copy) NSString * contact;              //法人代表
@property (nonatomic,strong) NSNumber * contactphone;       //法人电话
@property (nonatomic,copy) NSString * manager;              //车队管理员
@property (nonatomic,strong) NSNumber * managePhone;        //车队管理员电话
@property (nonatomic,strong) NSString * safer;              //安全管理员
@property (nonatomic,copy) NSNumber * safePhone;            //安全管理员电话

@end
