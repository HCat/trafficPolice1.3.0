//
//  URLMacro.h
//  trafficPolice
//
//  Created by hcat on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#ifndef URLMacro_h
#define URLMacro_h

#pragma mark - 基地址

#define ISONLINE  NO

#define DEBUG_DACAO_URL @"http://192.168.10.201:8280/police-admin/"
#define WEBSOCKET_DEBUGDACAO_URL @"ws://192.168.10.123:8080/police-admin/websocket"

#define DEBUG_URL @"http://proda.degal.cn/police-admin" //  外网 http://192.168.10.123:8080 @"http://proda.degal.cn/police-admin"
#define RELEASE_URL @"http://jj.police.degal.cn"


#define PARK_DEBUG_URL @"http://preman.degal.cn/api" //停车取证测试环境 //http://192.168.10.88/api
#define PARK_RELEASE_URL @"http://topark.host/api"   //停车取证正式环境


#define WEBSOCKET_DEBUG_URL @"ws://192.168.10.201:8280//police-admin/websocket"
//ws://192.168.10.201:8280//police-admin/websocket

#define WEBSOCKET_RELEASE_URL @"ws://jj.police.degal.cn/websocket"

#define KBase_URL ISONLINE ? RELEASE_URL : DEBUG_URL
#define KwebSocket_URL ISONLINE ? WEBSOCKET_RELEASE_URL : WEBSOCKET_DEBUG_URL

#define Base_URL ([ShareValue sharedDefault].server_url == nil) ? (KBase_URL) : [ShareValue sharedDefault].server_url
#define WEBSOCKETURL ([ShareValue sharedDefault].webSocket_url == nil) ? (KwebSocket_URL) : [ShareValue sharedDefault].webSocket_url
#define PARK_Base_URL ISONLINE ? PARK_RELEASE_URL : PARK_DEBUG_URL

#define JPUSH_PRODUCTION ISONLINE ? YES : NO


//上传用的key
#define key_file @"file" 
#define key_files @"files"
#define key_certFiles @"certfiles"

#pragma mark - 登录相关API

#define URL_LOGIN_LOGIN @"app/login.json"                                       //登录
#define URL_LOGIN_LOGINTAKECODE @"app/loginTakeCode.json"                       //登录发送验证码
#define URL_LOGIN_LOGINCHECK @"app/loginCheck.json"                             //验证码登录
#define URL_LOGIN_VISITOR @"app/loginVisitor.json"                              //游客登录
#define URL_LOGIN_LOGINMOBILE @"app/mobileLogin.json"                           //手机登录


#pragma mark - 通用相关API

#define URL_COMMON_GETWEATHER @"app/common/getWeather.json"                     //获取当前天气
#define URL_COMMON_IDENTIFY @"app/common/identify.json"                         //证件识别
#define URL_COMMON_GETROAD @"app/common/getRoad.json"                           //获取路名
#define URL_COMMON_GETGROUPLIST @"app/common/getGroupList.json"                 //获取警员分组列表
#define URL_COMMON_GETIMGPLAY @"app/common/getImgPlay.json"                     //获取图片轮播图片
#define URL_COMMON_VERSIONUPDATE @"app/common/versionUpdate.json"               //版本更新
#define URL_COMMON_ADVICE @"app/common/advice.json"                             //投诉建议
#define URL_COMMON_VALIDVISITOR @"app/common/validVisitor.json"                 //查询是否需要游客登录
#define URL_COMMON_POLICEANOUNCE @"app2/policeAnounce/getAnounce.json"          //警务详情
#define URL_COMMON_POLICEORG @"app/common/getPoliceOrg.json"                    //获取机构列表
#define URL_COMMON_GETDEPARTMENT @"app/common/getDepartment.json"               //获取部门列表
#define URL_COMMON_GETGROUPBYDEPARTMENTID @"app/common/getGroupByDepartmentId.json"     //根据部门获取勤务组
#define URL_COMMON_GETMENU @"app/common/getMenu.json"                           //APP菜单折叠接口


#pragma mark - 事故相关API

#define URL_ACCIDENT_GETCODES @"app/accident/getCodes.json"                     //获取事故通用值
#define URL_ACCIDENT_SAVE @"app/accident/save.json"                             //事故增加
#define URL_ACCIDENT_UP @"app/accident/saveApp.json"                            //事故增加
#define URL_ACCIDENT_LISTPAGING @"app/accident/listPaging.json"                 //事故列表
#define URL_ACCIDENT_DETAILS @"app/accident/detailApp.json"                     //事故详情
#define URL_ACCIDENT_COUNTBYCARNO @"app/accident/countAccidentByCarno.json"     //通过车牌号统计事故数量
#define URL_ACCIDENT_COUNTBYTELNUM @"app/accident/countAccidentByTelNum.json"   //通过手机号统计事故数量
#define URL_ACCIDENT_COUNTBYIDNO @"app/accident/countAccidentByIdNo.json"       //通过身份证号统计事故数量
#define URL_ACCIDENT_ADDREMARK @"app/accident/addRemark.json"                   //事故/快处添加备注
#define URL_ACCIDENT_REMARKLIST @"app/accident/remarkList.json"                 //事故/快处备注列表


#pragma mark - 快处事故相关API

#define URL_FASTACCIDENT_GETCODES @"app/fastAccident/getCodes.json"             //获取快处事故通用值
#define URL_FASTACCIDENT_SAVE @"app/fastAccident/save.json"                     //快处事故增加
#define URL_FASTACCIDENT_UP @"app/fastAccident/saveApp.json"                    //快处事故增加
#define URL_FASTACCIDENT_LISTPAGING @"app/fastAccident/listPaging.json"         //快处事故列表
#define URL_FASTACCIDENT_DETAILS @"app/fastAccident/detailApp.json"             //快处事故详情
#define URL_FASTACCIDENT_PEOPLE @"app/fastAccident/accidentDetail.json"         //用户提交的快处信息
#define URL_FASTACCIDENT_DEALACCIDENT @"app/fastAccident/dealAccident.json"     //处理用户提交的快处信息
#define URL_FASTACCIDENT_CHECKPERMISS @"app/fastAccident/checkPermiss.json"     //是否有权限处理用户提交的快处信息
#define URL_FASTACCIDENT_AUDIT @"app/fastAccident/audit.json"                   //快处认定接口

#pragma mark - 违停相关API

#define URL_ILLEGALPARK_SAVE @"app/illegalPark/save.json"                       //违停采集增加
#define URL_CARINFOADD @"app/illegalPark/saveCarNo.json"                        //车辆录入增加
#define URL_ILLEGALPARK_LISTPAGING @"app/illegalPark/list.json"                 //违停采集列表
#define URL_ILLEGALPARK_DETAIL @"app/illegalPark/detail.json"                   //违停采集详情
#define URL_ILLEGALPARK_REPORTABNORMAL @"app/illegalPark/reportAbnormal.json"   //违停、违法禁令上报异常
#define URL_ILLEGALPARK_QUERYRECORD @"app/illegalPark/queryRecord.json"         //查询是否已有违停记录(旧)
#define URL_ILLEGALPARK_CARNORECORD @"app/illegalPark/queryCarNoRecord.json"    //查询是否已有违章记录(新)
#define URL_ILLEGALPARK_ILLEGALDETAIL @"app/illegalPark/illegalDetail.json"     //查看违章详细信息
#define URL_ILLEGAL_REPORTABNORMAL @"app/illegalPark/reportAbnormal.json"       //违停、违法禁令上报异常(新)
#define URL_ILLEGALPARK_CHECKROADCOLLECT @"app/illegalPark/checkRoadCollect.json"   //采集根据道路ID是否可以采集（设备重复采集问题）


#pragma mark - 违章采集

#define URL_ILLEGAL_SAVE @"app/parkIllegal/info/save.json"      //违章采集增加
#define URL_ILLEGAL_QUERYSEC @"app/parkIllegal/info/queryCarNoSec.json" //查询违章采集是否需要二次采集
#define URL_ILLEGAL_LISTPAGING @"app/parkIllegal/info/list.json" //违章采集列表
#define URL_ILLEGAL_DETAIL @"app/parkIllegal/info/detail.json"   //违章详情
#define URL_ILLEGAL_SECLOAD @"app/parkIllegal/info/secAdd.json" //二次采集加载一次采集数据
#define URL_ILLEGAL_SECADD @"app/parkIllegal/info/secSave.json" //二次采集增加数据
#define URL_ILLEGAL_CONFIRMABNORMAL @"app/parkIllegal/info/confirmAbnormal.json"    //违章采集确认异常

#pragma mark - 违反禁令相关API

#define URL_ILLEGALTHROUGH_QUERYSEC @"app/illegalThrough/querySec.json"         //违反禁令查询是否需要二次采集(旧)
#define URL_ILLEGALTHROUGH_CARNOSEC @"app/illegalThrough/queryCarNoSec.json"    //违反禁令查询是否需要二次采集(新)

#define URL_ILLEGALTHROUGH_SAVE @"app/illegalThrough/save.json"                 //违反禁令采集增加
#define URL_ILLEGALTHROUGH_SECADD @"app/illegalThrough/secAdd.json"             //违反禁令采集增加违反禁令二次采集加载数据
#define URL_ILLEGALTHROUGH_SECSAVE @"app/illegalThrough/secSave.json"           //违反禁令二次采集保存
#define URL_ILLEGALTHROUGH_LISTPAGING @"app/illegalThrough/listPaging.json"     //违反禁令采集列表
#define URL_ILLEGALTHROUGH_DETAIL @"app/illegalThrough/detail.json"             //违反禁令采集详情


#pragma mark - 警情反馈相关API

#define URL_VIDEOCOLECT_SAVE @"app/videoColect/save.json"                       //警情反馈采集增加
#define URL_VIDEOCOLECT_LISTPAGING @"app/videoColect/listPaging.json"           //警情反馈采集列表
#define URL_VIDEOCOLECT_DETAIL @"app/videoColect/detail.json"                   //警情反馈详情


#pragma mark - 消息相关API

#define URL_IDENTIFY_LIST @"identify/identifyMsgList.json"                  //消息列表
#define URL_IDENTIFYWITHTYPE_LIST @"identify/identifyMsgList.json"          //根据TYPE请求相应的消息
#define URL_IDENTIFY_MSGREAD @"identify/setMsgRead.json"                    //确认接收消息
#define URL_IDENTIFY_NOTICE @"identify/notice.json"                         //消息通知
#define URL_IDENTIFY_MSGDETAIL @"identify/msgDetail.json"                   //消息详情
#define URL_IDENTIFY_FINISHPOLICECALL @"identify/finishPoliceCall.json"     //消息任务完成

#pragma mark - 签到相关API

#define URL_SIGN @"app/common/sign.json"                //签到
#define URL_SIGNOUT @"app/common/signOut.json"          //签退
#define URL_SIGN_LIST @"app/common/signList.json"       //签到列表


#pragma mark - 重点车辆相关API

#define URL_VEHICLE_GETDETAILINFOBYQRCODE @"app/vehicle/getDetailInfo.json"                 //二维码编号获取重点车辆
#define URL_VEHICLE_GETDETAILINFOBYPLATENO @"app/vehicle/getDetailInfoByPlateNo.json"       //车牌号获取重点车辆
#define URL_VEHICLE_GETVEHICLERANGELOCATION @"app/vehicle/getVehicleRangeLocation.json"     //获取一定范围内车辆信息
#define URL_VEHICLE_GETVEHICLELOCATION @"app/vehicle/getVehicleLocation.json"               //获取全部车辆信息
#define URL_VEHICLE_VEHICLELOCATIONBYPLATENO @"app/vehicle/getVehicleLocationByPlateNo.json"//通过车牌获取重点车位置

#define URL_VEHICLE_VEHICLEREPORTINFO @"app/vehicle/getVehicleReportInfo.json"              //根据车牌id获取车辆报备信息
#define URL_VEHICLE_UPREPORTINFO @"app/vehicle/updateVehicleReportInfo.json"                //更新车辆报备信息
#define URL_VEHICLE_VEHICLEGETVEHICLELIST @"app/vehicle/getVehicleList.json"                //获取车辆列表
#define URL_VEHICLE_VEHICLEALARMRECORD @"app/vehicle/getVehicleAlarmRecordByVehicleId.json" //获取车辆相关报警信息

#define URL_VEHICLE_VEHICLESPEEDALARMLIST @"app/vehicle/getVehicleSpeedAlarmListPage.json"  //获取超速报警列表
#define URL_VEHICLE_VEHICLETIREDIMAGELIST @"app/vehicle/getFatigueAlarmImageList.json"      //获取疲劳驾驶报警图片列表
#define URL_VEHICLE_CARUP @"app/illegalController/saveIllegalEntry.json"                    //违法录入增加
#define URL_VEHICLE_VEHICLEGETCODETYPE @"app/illegalController/getCodeType.json"            //违法类型获取
#define URL_VEHICLE_VEHICLEUPCARLIST @"app/illegalController/getIllegalEntry.json"          //违法录入列表
#define URL_VEHICLE_VEHICLEUPCARDETAILE @"app/illegalController/getDetail.json"             //违法录入详细信息
#define URL_VEHICLE_VEHICLEGETROUTEAPPROVAL @"app/vehicle/getRouteApproval.json"            //获取有效路线接口


#pragma mark - 警员勤务

#define URL_LOCATION_GETLIST @"app/location/getList.json"               //获取警员位置信息

#define URL_POLICE_GETLIST  @"app/location/getList.json"                //获取警员位置信息
#define URL_POLICE_SENDNOTICE @"app/location/sendNotice.json"           //区域广播
#define URL_POLICE_SEARCH @"app/location/search.json"                   //搜索
#define URL_POLICE_ANALYZELIST @"app/location/policeAnalyzeList.json"   //勤务管理列表
#define URL_POLICE_USERSIGNLIST @"app/common/getUserSignList.json"      //获取签到列表


#pragma mark - 通讯录相关API

#define URL_ADDRESSBOOK_GETLIST @"app/addressBook/getList.json"      //获取通讯录

#pragma mark - 排班相关API

#define URL_DUTY_GETDUTYBYMONTH @"app/workshift/getHolidayDutyByMonth.json" //获取月排班
#define URL_DUTY_GETDUTYBYDAY @"app/workshift/geHolidaytDutyByDay.json"     //按天获取排班详情
#define URL_DUTY_GETWORKBYDAY @"app/workshift/getWorkShiftDetailByDay.json" //按天获取排班详情（按分组显示

#pragma mark - 警员任务

#define URL_TASK_HISTORYLIST @"app/policeTask/getHistoryList.json"  //查询历史任务
#define URL_TASK_TYPELIST @"app2/policeTask/getTypeList.json"       //根据类型选择任务
#define URL_TASK_CURRENTLIST @"app/policeTask/getCurrentList.json"  //查询当前任务
#define URL_TASK_DETAIL @"app/policeTask/detail.json"               //任务详情

#pragma mark - 非法营运

#define URL_IllOPERATION_BESUPERVISED @"app/illOperation/toBeSupervisedCarno.json"   //待监管车辆
#define URL_IllOPERATION_EXEMPTCARNO @"app/illOperation/exemptCarno.json"            //待监管车辆
#define URL_IllOPERATION_DETAIL @"app/illOperation/detail.json"                      //待监管车辆

#pragma mark - 联合执法

#define URL_JOINTLAW_SAVE @"app/jointLaw/save.json"                                 //联合执法增加
#define URL_JOINTLAW_GETILLEGALCODELIST @"app/jointLaw/getIllegalCodeList.json"     //违法条例列表
#define URL_JOINTLAW_IMGUPLOAD @"app/jointLaw/imgUpload.json"                       //联合执法上传照片
#define URL_JOINTLAW_VIDEOUPLOAD @"app/jointLaw/videoUpload.json"                   //联合执法视频上传

#pragma mark - 行动

#define URL_ACTION_PAGELIST @"app/actionManage/getActionPageList.json"              //获取行动分页列表
#define URL_ACTION_DETAIL @"app/actionManage/getActionDetail.json"                  //获取行动详情
#define URL_ACTION_CHANGESTATUS @"app/actionManage/changeActionStatus.json"         //更改行动状态
#define URL_ACTION_TYPELIST @"app/actionManage/getActionTaskList.json"              //根据类型选择行动

#pragma mark - 特殊车辆管理

#define URL_SPECIAL_GETGROUPLIST @"app/group/getGroupList.json"                     //特殊传车辆管理组的获取和组的车牌获取
#define URL_SPECIAL_GETRECORDLIST @"app/group/getRecordList.json"                   //特殊传车辆管理获取识别记录列表
#define URL_SPECIAL_RECORDDETAIL @"app/group/recordDetail.json"                     //特殊传车辆管理获取识别记录详情
#define URL_SPECIAL_SAVEGROUP @"app/group/saveGroup.json"                           //特殊车辆管理保存组合保存车辆
#define URL_SPECIAL_DELETE @"app/group/delete.json"                                 //删除车辆
#define URL_SPECIAL_SETNOTICEGROUP @"app/group/setNoticeGroup.json"                 //获取设置通知人员列表
#define URL_SPECIAL_SAVENOTICEGROUP @"app/group/saveNoticeGroup.json"               //保存置通知人员


#pragma mark - 外卖小哥

#define URL_TAKEOUT_GETCOURIERLIST @"app/deliveryInfo/getCourierList.json"          //根据条件查询快递员列表
#define URL_TAKEOUT_GETCOURIERINFO @"app/deliveryInfo/getCourierInfo.json"          //查询快递员信息
#define URL_TAKEOUT_GETVEHICLEINFO @"app/deliveryInfo/getVehicleInfo.json"          //获取快递小哥车辆信息
#define URL_TAKEOUT_REPORTPAGE @"app/deliveryReport/reportPage.json"                //违章记录列表
#define URL_TAKEOUT_REPORTDETAIL @"app/deliveryReport/reportDetail.json"            //违章记录详情

#define URL_TAKEOUT_TWOILLEGALTYPE @"app/deliveryReport/illegalTypeList.json"       //违章类型列表(二级)
#define URL_TAKEOUT_ILLEGALTYPE @"app/deliveryReport/illegalType.json"              //违章类型列表(二级)
#define URL_TAKEOUT_TYPELIST @"app/deliveryReport/typeList.json"                    //违章类型列表(一级)
#define URL_TAKEOUT_SAVE @"app/deliveryReport/submitReport.json"                    //上报快递小哥违章
#define URL_TAKEOUT_SUBMITTEMPREPORT @"app/deliveryReport/submitTempReport.json"    //临时工违章采集
#define URL_TAKEOUT_COMPANYLIST @"app/deliveryReport/companyList.json"              //众包列表接口

#pragma mark - 停车取证

#define URL_PARKINGFORENSICS_LIST @"jwt/appParkingLot/processPark"                  //工单列表分页
#define URL_PARKINGOCCPERCENT_LIST @"jwt/appParkingLot/parkplaceList"               //车位列表信息
#define URL_PARKING_AREA @"jwt/appParkingLot/parkingLotList"                        //全部片区列表
#define URL_PARKINGAREA_DETAIL @"jwt/parkPlace/record"                              //车位详情
#define URL_PARKING_REMARKCARSTATUS @"app/parkingOrder/remarkCarStatus.json"        //标记无车
#define URL_PARKING_FORENSICS @"jwt/appParkProcess/saveProcess"                     //采集停车取证信息
#define URL_PARKING_IDENTIFY @"appCommon/identify"                                  //停车取证采集照片识别
#define URL_PARKINGAREA_ISFRIST @"appCommon/isFirstPark"                            //验证是否为第一次违停
#define URL_PARKINGAREA_ISREGIST @"app/sys/isRegister"                              //验证用户是否在系统有效注册


#pragma mark - 停车场管理

#define URL_PARKINGMANAGE_SEARCHLIST @"app/carYardCollect/carYardCollectList.json"  //在库车辆列表


#pragma mark - 违法曝光

#define URL_EXPOSURECOLLECT_REPORT @"app/exposureCollect/save.json"                 //保存曝光违章信息
#define URL_EXPOSURECOLLECT_TYPELIST @"app/exposureCollect/expTypeList.json"        //违章类型列表
#define URL_EXPOSURECOLLECT_LISTPAGING @"app/exposureCollect/exposurePage.json"//曝光列表分页
#define URL_EXPOSURECOLLECT_DETAIL @"app/exposureCollect/expDetail.json" //曝光详情


#pragma mark - 排班信息列表

#define URL_DAILYPATROL_LIST @"app/patrolInfo/PatrolShiftList.json"     //排班信息列表
#define URL_DAILYPATRO_DETAIL @"app/patrolInfo/patrolLocationDetail.json"   //巡逻路线详情
#define URL_DAILYPATRO_SENDSIGN @"app/patrolInfo/sendPatrolSign.json"   //巡逻打卡
#define URL_DAILYPATRO_LOCATIONREPORT @"app/patrolInfo/locationReport.json"   //实时上报位置
#define URL_DAILYPATRO_POINTLIST @"app/patrolInfo/pointReportList.json"   //实时上报位置列表
#define URL_DAILYPATRO_POINTSIGN @"app/patrolInfo/sendPointSign.json"     //到岗离岗功能

#define URL_TASKFLOWS_TASKLIST @"app/adviceTask/taskList.json"    //指派给我的任务流
#define URL_TASKFLOWS_SELFTASKLIST @"app/adviceTask/selftaskList.json"   //我创建的任务流
#define URL_TASKFLOWS_DETAIL @"app/adviceTask/taskDetail.json"    //任务流详情
#define URL_TASKFLOWS_SAVETASK @"app/adviceTask/saveTask.json"    //
#define URL_TASKFLOWS_REPLYTASK @"app/adviceTask/replyTask.json"


#define URL_ELECTRONIC_TYPE @"app/trafficManage/elecTypeList.json" //电子警察摄像头类型
#define URL_ELECTRONIC_LIST @"app/trafficManage/cameraPoliceList.json"  //电子警察摄像头列表
#define URL_ELECTRONIC_IMAGE @"app/trafficManage/picList.json"          //图片列表

#define URL_SCREEN_LIST @"app/bookReceive/bookinglist.json"         //领取证件列表分页
#define URL_SCREEN_ADD @"app/bookReceive/saveBookingReceive.json"         //领取证件添加
#define URL_SCREEN_DEL @"app/bookReceive/delBookReceive.json"         //领取证件删除


#endif /* URLMacro_h */
