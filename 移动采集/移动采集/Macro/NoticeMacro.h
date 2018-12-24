//
//  NoticeMacro.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/16.
//  Copyright © 2017年 Degal. All rights reserved.
//

#ifndef NoticeMacro_h
#define NoticeMacro_h

#define NOTIFICATION_WX_LOGIN_SUCCESS @"NOTIFICATION_WX_LOGIN_SUCCESS"                          //微信发送成功
#define NOTIFICATION_CHANGELOCATION_SUCCESS @"NOTIFICATION_CHANGELOCATION_SUCCESS"              //定位地址成功

#define NOTIFICATION_NONETWORK_SUCCESS @"NOTIFICATION_NONETWORK_SUCCESS"                        //无网络
#define NOTIFICATION_HAVENETWORK_SUCCESS @"NOTIFICATION_HAVENETWORK_SUCCESS"                    //无网络到有网络的通知

#define NOTIFICATION_RECEIVENOTIFICATION_DUTY @"NOTIFICATION_RECEIVENOTIFICATION_DUTY"          //接收到值班通知
#define NOTIFICATION_RECEIVENOTIFICATION_ACTION @"NOTIFICATION_RECEIVENOTIFICATION_ACTION"      //接收到行动通知

#define NOTIFICATION_WILLPRESENTNOTIFICATION @"NOTIFICATION_WILLPRESENTNOTIFICATION"            //即将展现消息通知
#define NOTIFICATION_RECEIVENOTIFICATION_SUCCESS @"NOTIFICATION_RECEIVENOTIFICATION_SUCCESS"    //接收到通知
#define NOTIFICATION_MAKESURENOTIFICATION_SUCCESS @"NOTIFICATION_MAKESURENOTIFICATION_SUCCESS"  //确认通知
#define NOTIFICATION_COMPLETENOTIFICATION_SUCCESS @"NOTIFICATION_COMPLETENOTIFICATION_SUCCESS"  //完成出警任务
#define NOTIFICATION_COMPLETEOPERATCAR_SUCCESS @"NOTIFICATION_COMPLETEOPERATCAR_SUCCESS"        //非法车辆豁免通知


#define NOTIFICATION_ADDREMARK_SUCCESS @"NOTIFICATION_ADDREMARK_SUCCESS"                        //添加备注成功通知

#define NOTIFICATION_ACCIDENT_SUCCESS @"NOTIFICATION_ACCIDENT_SUCCESS"                          //事故采集提交成功
#define NOTIFICATION_FASTACCIDENT_SUCCESS @"NOTIFICATION_FASTACCIDENT_SUCCESS"                  //快处事故采集提交成功
#define NOTIFICATION_ILLEGALPARK_SUCCESS @"NOTIFICATION_ILLEGALPARK_SUCCESS"                    //违停采集提交成功
#define NOTIFICATION_ILLEGALTHROUGH_SUCCESS @"NOTIFICATION_ILLEGALTHROUGH_SUCCESS"              //闯禁令采集提交成功
#define NOTIFICATION_VIDEO_SUCCESS @"NOTIFICATION_VIDEO_SUCCESS"                                //视频采集提交成功

#define NOTIFICATION_RELOADWATCH_SUCCESS @"NOTIFICATION_RELOADWATCH_SUCCESS"                    //重新刷新值班

#define NOTIFICATION_RELOADJOINTLAWIMAGE @"NOTIFICATION_RELOADJOINTLAWIMAGE"                    //选中联合执法图片之后的操作
#define NOTIFICATION_RELOADJOINTLAWVIDEO @"NOTIFICATION_RELOADJOINTLAWVIDEO"                    //选中联合执法视频之后的操作

#define NOTIFICATION_JUDEGECOMMIT @"NOTIFICATION_JUDEGECOMMIT" //判断是否可以提交

#define NOTIFICATION_ACCIDENTPEOPLE_MAKESURE @"NOTIFICATION_ACCIDENTPEOPLE_MAKESURE"  //事故当事人信息修改确实之后
#define NOTIFICATION_ACCIDENTPEOPLE_DELETE @"NOTIFICATION_ACCIDENTPEOPLE_DELETE"    //事故当事人信息删除

#define NOTIFICATION_ACTION_UP @"NOTIFICATION_ACTION_UP"    //行动发布

#define NOTIFICATION_SPECIAL_EDITCAR @"NOTIFICATION_SPECIAL_EDITCAR"      //特殊车辆管理编辑车辆成功
#define NOTIFICATION_SPECIAL_ADDCAR @"NOTIFICATION_SPECIAL_ADDCAR"      //特殊车辆管理添加车辆成功
#define NOTIFICATION_SPECIAL_EDITGROUP @"NOTIFICATION_SPECIAL_EDITGROUP"      //特殊车辆管理编辑组成功
#define NOTIFICATION_SPECIAL_ADDGROUP @"NOTIFICATION_SPECIAL_EDITGROUP"      //特殊车辆管理添加组成功
#define NOTIFICATION_SPECIAL_DELETECAR @"NOTIFICATION_SPECIAL_DELETECAR"     //特殊车辆管理删除车成功

#define NOTIFICATION_ILLEGALPARK_ADDCACHE_SUCCESS @"NOTIFICATION_ILLEGALPARK_ADDCACHE_SUCCESS" //违章采集成功
#define NOTIFICATION_ILLEGALPARK_UPCACHE_SUCCESS @"NOTIFICATION_ILLEGALPARK_UPCACHE_SUCCESS" //违章采集缓存上报成功
#define NOTIFICATION_ILLEGALPARK_UPCACHE_ERROR @"NOTIFICATION_ILLEGALPARK_UPCACHE_ERROR" //违章采集缓存上报失败


#define NOTIFICATION_ACCIDENT_ADDCACHE_SUCCESS @"NOTIFICATION_ACCIDENT_ADDCACHE_SUCCESS" //事故采集成功
#define NOTIFICATION_ACCIDENT_UPCACHE_SUCCESS @"NOTIFICATION_ACCIDENT_UPCACHE_SUCCESS" //事故采集缓存上报成功
#define NOTIFICATION_ACCIDENT_UPCACHE_ERROR @"NOTIFICATION_ACCIDENT_UPCACHE_ERROR" //事故采集缓存上报失败

#define NOTIFICATION_POLICE_SHOWDETAIL @"NOTIFICATION_POLICE_SHOWDETAIL"    //警力分布显示详情
#define NOTIFICATION_POLICE_SEARCH @"NOTIFICATION_POLICE_SEARCH"    //警力搜索

#endif /* NoticeMacro_h */
