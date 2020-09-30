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
#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"
#import "SRAlertView.h"
#import "IllegalCarView.h"
#import "BottomView.h"

@interface IllegalOperatCarVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV_type;
@property (weak, nonatomic) IBOutlet UILabel *lb_deviceNumber;
@property (weak, nonatomic) IBOutlet UILabel *lb_carNumber;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_car;

@property (weak, nonatomic) IBOutlet UIView *v_message;

@property (weak, nonatomic) IBOutlet UIButton *btn_handle;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_image_height;

@property (nonatomic,strong)  IllOperationCarDetail *illCarDetail;


@end

@implementation IllegalOperatCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"非法运营车辆";
    [_imgV_type setImage:[UIImage imageNamed:@"img_message_illegalCar"]];
    
    _btn_handle.hidden = YES;
    _v_message.layer.cornerRadius = 5.f;
    _v_message.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    _v_message.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    _v_message.layer.shadowOpacity = 0.3;//不透明度
    _v_message.layer.shadowRadius = 5.0;//半径
    
    [self makeSureRequest];
    [self illegalCarDetailRequest:_model.msgId];
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
               
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MAKESURENOTIFICATION_SUCCESS object:strongSelf.model.source];
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            
        }];
    }
    
}

#pragma mark - 请求处理结果

- (IBAction)handleBtnManageClicked:(id)sender {
    
    
    WS(weakSelf);
    //调用身份证和驾驶证模态视图
    IllegalCarView *t_view = [IllegalCarView initCustomView];
    [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 103)];
    t_view.superviseBlock = ^(){
        LxPrintf(@"待监管点击");
        SW(strongSelf, weakSelf);
        [strongSelf handleBtnSuperviseClicked:nil];
       
        
        [BottomView dismissWindow];
        
    };
    t_view.exemptCarBlock = ^(){
        
        LxPrintf(@"豁免该人");
        SW(strongSelf, weakSelf);
        [strongSelf handleBtnExemptCarClicked:nil];
        
        [BottomView dismissWindow];
        
    };
    [BottomView showWindowWithBottomView:t_view];
    
}



#pragma mark - 请求非法营运车辆详情

- (void)illegalCarDetailRequest:(NSNumber *)messageId{
    
    WS(weakSelf);
    IllOperationDetailManger * manger = [[IllOperationDetailManger alloc] init];
    manger.messageId= messageId;
    [manger configLoadingTitle:@"请求"];
    manger.isNeedShowHud = NO;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        
        if (manger.responseModel.code  == CODE_SUCCESS) {
            strongSelf.illCarDetail = manger.illCarDetail;
            
            strongSelf.lb_carNumber.text = strongSelf.illCarDetail.carno ;
            strongSelf.lb_deviceNumber.text = strongSelf.illCarDetail.devno;
            strongSelf.lb_time.text =strongSelf.illCarDetail.createTime;
            strongSelf.lb_address.text = strongSelf.illCarDetail.address;
            
            strongSelf.illCarDetail.originalPic = [strongSelf.illCarDetail.originalPic stringByReplacingOccurrencesOfString:@" "withString:@""];
            
            NSURL *url = [NSURL URLWithString:[strongSelf.illCarDetail.originalPic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [SDWebImageDownloader.sharedDownloader setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
                                         forHTTPHeaderField:@"Accept"];
            [strongSelf.imageV_car sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                strongSelf.layout_image_height.constant = image.size.height/2;
                strongSelf.imageV_car.contentMode = UIViewContentModeScaleToFill;
                [strongSelf.view layoutIfNeeded];
                
                
                
            }];
            
            strongSelf.btn_handle.hidden = [strongSelf.illCarDetail.isExempt isEqualToNumber:@1] ? YES : NO;
            
        }
    
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];

}




#pragma mark - buttonMethods

//待监管
- (IBAction)handleBtnSuperviseClicked:(id)sender {
    
    WS(weakSelf);
    
    SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"以后摄像头捕捉到该车牌号会继续上报,确定设成待监管车辆？"
                                                leftActionTitle:@"取消"
                                               rightActionTitle:@"确认"
                                                 animationStyle:AlertViewAnimationNone
                                                   selectAction:^(AlertViewActionType actionType) {
                                                       if(actionType == AlertViewActionTypeRight) {
                                                           
                                                           SW(strongSelf, weakSelf);
                                                           
                                                           IllOperationBeSupervisedManger *manger = [[IllOperationBeSupervisedManger alloc] init];
                                                           manger.carno = strongSelf.illCarDetail.carno;
                                                           [manger configLoadingTitle:@"请求中..."];
                                                           manger.successMessage = @"监管成功";
                                                           [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                                                               
                                                               if (manger.responseModel.code == CODE_SUCCESS) {
                                                                   strongSelf.btn_handle.hidden = YES;
                                                                   
                                                                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COMPLETEOPERATCAR_SUCCESS object:strongSelf.model.source];
                                                                   
                                                                   [strongSelf.navigationController popViewControllerAnimated:YES];
                                                               }
                                                               
                                                           } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                                                               
                                                           }];
                                                       }
                                                   }];
    alertView.blurCurrentBackgroundView = NO;
    [alertView show];
    
    
    
}

//豁免该车
- (IBAction)handleBtnExemptCarClicked:(id)sender {
    
    WS(weakSelf);
    
    SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"设成豁免后该摄像头将不再上报该车辆信息"
                                                leftActionTitle:@"取消"
                                               rightActionTitle:@"确认"
                                                 animationStyle:AlertViewAnimationNone
                                                   selectAction:^(AlertViewActionType actionType) {
                                                       if(actionType == AlertViewActionTypeRight) {
                                                           
                                                           SW(strongSelf, weakSelf);
                                                           
                                                           IllOperationExemptCarnoManger *manger = [[IllOperationExemptCarnoManger alloc] init];
                                                           
                                                           manger.carno = strongSelf.illCarDetail.carno;
                                                           [manger configLoadingTitle:@"请求中..."];
                                                           manger.successMessage = @"豁免成功";
                                                           [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                                                            
                                                               if (manger.responseModel.code == CODE_SUCCESS) {
                                                                   strongSelf.btn_handle.hidden = YES;
                                                                   
                                                                   [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_COMPLETEOPERATCAR_SUCCESS object:strongSelf.model.source];
                                                                   
                                                                   [strongSelf.navigationController popViewControllerAnimated:YES];
                                                               }
                                                               
                                                           } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                                                               
                                                           }];
                                                       }
                                                   }];
    alertView.blurCurrentBackgroundView = NO;
    [alertView show];
    
    
   
    
}

- (IBAction)handleBtnImageShowClicked:(id)sender {
    
    NSMutableArray *t_arr = [NSMutableArray array];
    
     NSURL *url = [NSURL URLWithString:[self.illCarDetail.originalPic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:self.imageV_car imageUrl:url];
    [t_arr addObject:item];

    KSPhotoBrowser *browser     = [KSPhotoBrowser browserWithPhotoItems:t_arr selectedIndex:0];
    [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
    [browser setDelegate:(id<KSPhotoBrowserDelegate> _Nullable)self];
    browser.dismissalStyle      = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle     = KSPhotoBrowserBackgroundStyleBlur;
    browser.loadingStyle        = KSPhotoBrowserImageLoadingStyleIndeterminate;
    browser.pageindicatorStyle  = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces             = NO;
    browser.isShowDeleteBtn     = NO;
    [browser showFromViewController:self];
    
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
