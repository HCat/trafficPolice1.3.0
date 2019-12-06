//
//  UserModel.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

#define kPersonInfoPath [KDocumentPath stringByAppendingPathComponent:@"userModel.archiver"]


@interface UserModel : BaseModel

@property (nonatomic,copy) NSString *token;             //token
@property (nonatomic,copy) NSString * userId;           //用户Id
@property (nonatomic,copy) NSString * phone;            //用户手机
@property (nonatomic,copy) NSString * name;             //用户名
@property (nonatomic,copy) NSString * nickName;         //昵称
@property (nonatomic,copy) NSString * realName;         //真实姓名
@property (nonatomic,assign) BOOL isInsurance;          //是否保险人员 0否 1是
@property (nonatomic,copy) NSString * departmentName;   //所属中队
@property (nonatomic,strong) NSNumber * departmentId;   //所属中队ID
@property (nonatomic,copy) NSString * dutyCode;         //职位编码         只有为BIG_LEADER才可以选择中队
@property (nonatomic,copy) NSString * systemCode;       //所属系统
@property (nonatomic,assign) BOOL workstate;            //签到状态 1签到0签退
@property (nonatomic,copy) NSArray *userPrivileges;     //权限列表

@property (nonatomic,copy) NSArray *menus;          //可操作的菜单列表


/******** 权限列表： ********

事故结案  accident-list-06

*/


/******** menus ********
 有权限的菜单编码值，参考下面的编码值，数组类型
 菜单编码：
 
    事故添加        NORMAL_ACCIDENT_ADD
	事故列表        ACCIDENT_LIST
	快处事故添加     FAST_ACCIDENT_ADD
	快处列表        FASTACC_LIST
	违停采集        ILLEGAL_PARKING
	违停列表        ILLEGAL_LIST
    不按朝向采集     ILLEGAL_REVERSE_PARKING
	不按朝向列表     ILLEGAL_REVERSE_LIST
	违停锁车采集     ILLEGAL_LOCK_PARKING
	违停锁车列表     ILLEGAL_LOCK_LIST
	车辆录入        CAR_INFO_ADD
	车辆列表        CAR_INFO_LIST
    闯禁令采集      ILLEGAL_THROUGH
	闯禁令列表      THROUGH_LIST
	视频采集        VIDEO_COLLECT
	视频采集列表     VIDEO_COLLECT_LIST
	重点车辆        IMPORTANT_CAR
	勤务指挥        POLICE_COMMAND
    路面实况        ROAD_INFO
    资料共享        DATA_SHARE
    联合执法        JOINT_LAW_ENFORCEMENT
    特殊车辆        SPECAIL_CAR_MANAGE
    事故结案权限     accident-list-06
    行动管理        ACTION_MANAGE
    行动管理-发布    ACTIONMANAGE06
    行动管理-结束    ACTIONMANAGE08
    摩托车采集       MOTOR_INFO_ADD
    摩托车采集列表    MOTOR_INFO_LIST
    违反禁止线       ILLEGAL_INHIBIT_LINE
    违反禁止线列表    ILLEGAL_INHIBIT_LINE_LIST
    勤务管理         POLICE_MANAGE
 
    车场出入库管理    CAR_YARD_COLLECT
    快递员监管       DELVIERY_MANAGE
    停车取证         PARKING_COLLECT
    违法曝光         ILLEGAL_EXPOSURE
    违法曝光列表      EXPOSURE_LIST
 
*/


//归档
+ (void)setUserModel:(UserModel *)model;

//解档
+ (UserModel *)getUserModel;

//获取录入权限
+ (BOOL)isPermissionForAccident;                //事故录入权限
+ (BOOL)isPermissionForFastAccident;            //快处录入权限
+ (BOOL)isPermissionForIllegal;                 //违章录入权限
+ (BOOL)isPermissionForThrough;                 //闯禁令录入权限
+ (BOOL)isPermissionForVideoCollect;            //视频录入权限

+ (BOOL)isPermissionForIllegalReverseParking;   //获取不按朝向采集权限
+ (BOOL)isPermissionForLockParking;             //获取违停锁车采集权限
+ (BOOL)isPermissionForInhibitLine;             //获取违反禁止线权限

+ (BOOL)isPermissionForCarInfoAdd;              //获取车辆录入权限
+ (BOOL)isPermissionForMotorBikeAdd;            //获取摩托车违章录入权限

+ (BOOL)isPermissionForImportantCar;            //获取重点车辆权限
+ (BOOL)isPermissionForPoliceCommand;           //获取勤务指挥权限

+ (BOOL)isPermissionForRoadInfo;                //路面实况权限
+ (BOOL)isPermissionForJointEnforcement;        //联合执法权限
+ (BOOL)isPermissionForSpecialCar;              //特殊车辆权限
+ (BOOL)isPermissionForAttendance;              //勤务管理

//获取列表权限
+ (BOOL)isPermissionForAccidentList;            //事故权限列表
+ (BOOL)isPermissionForFastAccidentList;        //快处权限列表
+ (BOOL)isPermissionForIllegalList;             //违章权限列表
+ (BOOL)isPermissionForThroughList;             //闯禁令权限列表
+ (BOOL)isPermissionForVideoCollectList;        //视频录入权限列表

+ (BOOL)isPermissionForIllegalReverseList;      //不按朝向列表权限
+ (BOOL)isPermissionForIllegalLockList;         //违停锁车列表权限
+ (BOOL)isPermissionForInhibitLineList;         //获取违反禁止线列表权限
+ (BOOL)isPermissionForCarInfoList;             //车辆列表
+ (BOOL)isPermissionForMotorBikeList;           //摩托车采集列表
+ (BOOL)isPermissionForExposureList;            //违法曝光列表

//获取一些功能性权限
+ (BOOL)isPermissionForAccidentCase;            //事故结案权限
//获取一些功能性权限
+ (BOOL)isPermissionForAcitonManage;            //行动管理权限
//获取一些功能性权限
+ (BOOL)isPermissionForAcitonPublish;           //行动管理发布
//获取一些功能性权限
+ (BOOL)isPermissionForAcitonEnd;               //行动管理结束



 
@end
