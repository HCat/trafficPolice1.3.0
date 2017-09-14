//
//  FastAccidentProcessVC.m
//  移动采集
//
//  Created by hcat on 2017/8/24.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "FastAccidentProcessVC.h"
#import "FSTextView.h"
#import "CALayer+Additions.h"
#import "ListHomeVC.h"
#import "SRAlertView.h"
#import "SearchListVC.h"

@interface FastAccidentProcessVC ()

@property (weak, nonatomic) IBOutlet UIButton *btn_makesure;

@property (weak, nonatomic) IBOutlet FSTextView *tf_responsibility;         //事故责任认定建议textView

@property (weak, nonatomic) IBOutlet FSTextView *tf_memo;                   //备注textView

@property (nonatomic,assign,readwrite) BOOL isCanCommit;                    //用于判断是否可以提交


@end

@implementation FastAccidentProcessVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"快处认定";
    
    self.isCanCommit = NO;
    
     _tf_responsibility.placeholderLabel.attributedText  = [ShareFun highlightInString:@"请输入简述(必填)" withSubString:@"(必填)"];
    _tf_memo.placeholder            = @"请输入简述";
    
}

#pragma mark - 返回处理

-(void)handleBtnBackClicked{
    
    if (self.param.responsibility || self.param.memo) {
        
        WS(weakSelf);
        
        SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"当前已编辑，是否退出编辑"
                                                    leftActionTitle:@"取消"
                                                   rightActionTitle:@"退出"
                                                     animationStyle:AlertViewAnimationNone
                                                       selectAction:^(AlertViewActionType actionType) {
                                                           if(actionType == AlertViewActionTypeRight) {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                           }
                                                       }];
        alertView.blurCurrentBackgroundView = NO;
        [alertView show];
        
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}


#pragma mark - set && get

-(void)setIsCanCommit:(BOOL)isCanCommit{
    
    _isCanCommit = isCanCommit;
    if (_isCanCommit == NO) {
        _btn_makesure.enabled = NO;
        [_btn_makesure setBackgroundColor:DefaultBtnNuableColor];
    }else{
        _btn_makesure.enabled = YES;
        [_btn_makesure setBackgroundColor:DefaultBtnColor];
    }
    
}

#pragma mark - 认定按钮事件

- (IBAction)handleBtnMakeSureClicked:(id)sender {
    
    WS(weakSelf);
    
    FastAccidentSaveManger *manger = [[FastAccidentSaveManger alloc] init];
    _param.state = @9;
    manger.param = _param;
    [manger configLoadingTitle:@"认定"];
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            /************* 发送修改成功通知去刷新快处列表 ****************/
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FASTACCIDENT_SUCCESS object:nil];
            
            /************* 回退到ListHomeVC 列表首页 ****************/
            for(UIViewController *controller in self.navigationController.viewControllers) {
                if([controller isKindOfClass:[ListHomeVC class]]) {
                    [strongSelf.navigationController popToViewController:controller animated:YES];
                }
                if([controller isKindOfClass:[SearchListVC class]]) {
                    [strongSelf.navigationController popToViewController:controller animated:YES];
                }
                
            }
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}

#pragma mark - 实时监听UITextView内容的变化

- (void)textViewDidChange:(FSTextView *)textView{
    
    LxDBAnyVar(textView.text);
    NSInteger length =  textView.text.length;
    
    if (textView == _tf_responsibility) {
        _param.responsibility = length > 0 ? _tf_responsibility.formatText : nil;
    }
    

    if (textView == _tf_memo) {
        _param.memo = length > 0 ? _tf_memo.text : @"";
    }
    
    [self judgeIsCommit];
    
}

#pragma mark - 判断事故认定是否可以提交

- (void)judgeIsCommit{
    
    if (_tf_responsibility.formatText.length > 0) {
        
        self.isCanCommit = YES;
    }else{
        
        self.isCanCommit = NO;
    }
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    LxPrintf(@"FastAccidentProcessVC dealloc");

}

@end
