//
//  TaskFlowsHandleVC.m
//  移动采集
//
//  Created by hcat-89 on 2020/3/10.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "TaskFlowsHandleVC.h"
#import "FSTextView.h"
#import "TaskFlowsAPI.h"

@interface TaskFlowsHandleVC ()

@property (weak, nonatomic) IBOutlet FSTextView *tv_taskContent;
@property (weak, nonatomic) IBOutlet UIButton * btn_handle;
@property (weak, nonatomic) IBOutlet UIButton * btn_nopass;
@property (weak, nonatomic) IBOutlet UIButton * btn_pass;

@property (strong, nonatomic) NSNumber * replyType;  //转发类型    是    0转发回复  1 完成回复
@property (strong, nonatomic) NSNumber * replyStatus;  //审核状态        1待审核 2审核不通过  3审核通过


@end

@implementation TaskFlowsHandleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"处理";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.replyType = @1;
    self.replyStatus = @1;
    @weakify(self);
    
    [RACObserve(self, type) subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        
        //0你是我的眼 1警务任务 2疫情复工 3.车辆通行证
        if ([x isEqualToNumber:@3]) {
            self.btn_pass.hidden = NO;
            self.btn_nopass.hidden = NO;
            self.btn_handle.hidden = YES;
        }else{
            self.btn_pass.hidden = YES;
            self.btn_nopass.hidden = YES;
            self.btn_handle.hidden = NO;
        }
        
    }];
    
    
    [[self.btn_handle rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        [self handleCommit];
        
    }];
    
    [[self.btn_nopass rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.replyStatus = @2;
        [self handleCommit];
        
    }];
    
    
    [[self.btn_pass rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.replyStatus = @3;
        [self handleCommit];
        
    }];
    
    [self.tv_taskContent.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
    
        if (x.length == 0) {
            self.btn_handle.enabled = NO;
            [self.btn_handle setBackgroundColor:DefaultBtnNuableColor];
        }else{
            self.btn_handle.enabled = YES;
            [self.btn_handle setBackgroundColor:DefaultBtnColor];
        }
    }];
    
    self.tv_taskContent.layer.borderColor = UIColorFromRGB(0xDCDCDC).CGColor;
    self.tv_taskContent.layer.borderWidth = 0.5f;
    self.tv_taskContent.layer.cornerRadius = 5.f;
    self.tv_taskContent.layer.masksToBounds = YES;
    
    
}


- (void)handleCommit{
    
    if (self.tv_taskContent.text.length == 0) {
        [ShareFun showTipLable:@"请输入回复内容"];
        return;
    }
    
    TaskFlowReplyTaskParam * param = [[TaskFlowReplyTaskParam alloc] init];
    param.taskId = self.taskId;
    param.replyContent = self.tv_taskContent.text;
    param.replyType = self.replyType;
    param.replyStatus = self.replyStatus;
    TaskFlowReplyTaskManger * manger = [[TaskFlowReplyTaskManger alloc] init];
    manger.param = param;
    [manger configLoadingTitle:@"处理"];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
       
        if (manger.responseModel.code == CODE_SUCCESS) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"任务流处理成功" object:@1 userInfo:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
       
    }];
        
}

- (void)dealloc{
    LxPrintf(@"TaskFlowsHandleVC dealloc");
}

@end
