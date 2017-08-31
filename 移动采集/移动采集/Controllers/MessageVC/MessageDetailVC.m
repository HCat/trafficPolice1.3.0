//
//  MessageDetailVC.m
//  移动采集
//
//  Created by hcat on 2017/8/31.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "MessageDetailVC.h"
#import "IdentifyAPI.h"

@interface MessageDetailVC ()

@property (weak, nonatomic) IBOutlet UIView *v_content;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_content;

@property (weak, nonatomic) IBOutlet UIButton *btn_makesure;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_btnAndVContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_btnBottom;


@end

@implementation MessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lb_time.text = [ShareFun timeWithTimeInterval:_model.createTime];
    _lb_content.text = _model.content;
    
    if ([_model.type isEqualToNumber:@1]) {
        self.title = @"特殊车辆通知";
        _layout_btnAndVContent.priority = UILayoutPriorityDefaultLow;
        [self.view layoutIfNeeded];
    }else if ([_model.type isEqualToNumber:@2]){
        self.title = @"出警任务";
        _layout_btnBottom.priority = UILayoutPriorityDefaultLow;
        [self.view layoutIfNeeded];
    }else{
        self.title = @"警务消息";
        _layout_btnBottom.priority = UILayoutPriorityDefaultLow;
        [self.view layoutIfNeeded];
    }
    
    if ([_model.flag isEqualToNumber:@1]) {
        _btn_makesure.hidden = YES;
    }
    
}

#pragma mark - 确定按钮事件

- (IBAction)handleBtnMakeSureClicked:(id)sender {
    
    if ([_model.flag isEqualToNumber:@0]) {
        
    
        IdentifySetMsgReadManger *manger = [[IdentifySetMsgReadManger alloc] init];
        manger.msgId = _model.msgId;
        manger.isNeedShowHud = NO;
        [manger configLoadingTitle:@"确认"];
       
        WS(weakSelf);
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            SW(strongSelf, weakSelf);
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                strongSelf.model.flag = @1;
                _btn_makesure.hidden = YES;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_MAKESURENOTIFICATION_SUCCESS object:nil];
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        
        }];
    }
    
    
    
    
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    LxPrintf(@"MessageDetailVC dealloc");
}


@end
