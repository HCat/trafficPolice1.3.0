//
//  IllegalOperatCarVC.m
//  移动采集
//
//  Created by hcat on 2017/12/11.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "IllegalOperatCarVC.h"
#import "IdentifyAPI.h"
#import "IllOperationAPI.h"
#import <UIImageView+WebCache.h>

@interface IllegalOperatCarVC ()

@property (weak, nonatomic) IBOutlet UILabel *lb_deviceNumber;
@property (weak, nonatomic) IBOutlet UILabel *lb_carNumber;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_service;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_car;
@property (weak, nonatomic) IBOutlet UIView *v_bottom;

@property (nonatomic,strong)  IllOperationCarDetail *illCarDetail;


@end

@implementation IllegalOperatCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeSureRequest];
}

#pragma mark - 确认查看消息请求

- (void)makeSureRequest {
    
    if ([_model.flag isEqualToNumber:@0]) {
        
        IdentifySetMsgReadManger *manger = [[IdentifySetMsgReadManger alloc] init];
        manger.msgId = _model.msgId;
        
        WS(weakSelf);
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            SW(strongSelf, weakSelf);
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                strongSelf.model.flag = @1;
               
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MAKESURENOTIFICATION_SUCCESS object:_model.source];
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            
        }];
    }
    
}

#pragma mark - 请求非法营运车辆详情

- (void)illegalCarDetailRequest:(NSNumber *)messageId{
    
    WS(weakSelf);
    IllOperationDetailManger * manger = [[IllOperationDetailManger alloc] init];
    manger.messageId= messageId;
    manger.isNeedLoadHud = YES;
    [manger configLoadingTitle:@"请求中..."];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        
        if (manger.responseModel.code  == CODE_SUCCESS) {
            strongSelf.illCarDetail = manger.illCarDetail;
            strongSelf.lb_carNumber.text = [strongSelf.illCarDetail.carno stringValue];
            strongSelf.lb_deviceNumber.text = [strongSelf.illCarDetail.devno stringValue];
            strongSelf.lb_time.text =[ShareFun timeWithTimeInterval:strongSelf.illCarDetail.createTime];
            strongSelf.lb_address.text = strongSelf.illCarDetail.address;
            [strongSelf.imageV_car sd_setImageWithURL:[NSURL URLWithString:strongSelf.illCarDetail.originalPic] placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
            strongSelf.v_bottom.hidden = [strongSelf.illCarDetail.isExempt isEqualToNumber:@1] ? YES : NO;
            
        }
    
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];

}

#pragma mark - buttonMethods

//待监管
- (IBAction)handleBtnSuperviseClicked:(id)sender {
    
    WS(weakSelf);
    
    IllOperationBeSupervisedManger *manger = [[IllOperationBeSupervisedManger alloc] init];
    manger.carno = _illCarDetail.carno;
    [manger configLoadingTitle:@"请求中..."];
    manger.successMessage = @"监管成功";
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.v_bottom.hidden = YES;
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}

//豁免该车
- (IBAction)handleBtnExemptCarClicked:(id)sender {
    
    WS(weakSelf);
    
    IllOperationExemptCarnoManger *manger = [[IllOperationExemptCarnoManger alloc] init];
    
    manger.carno = _illCarDetail.carno;
    [manger configLoadingTitle:@"请求中..."];
    manger.successMessage = @"豁免成功";
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.v_bottom.hidden = YES;
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)dealloc{
    LxPrintf(@"IllegalOperatCarVC dealloc");
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
