//
//  AccidentProcessVC.m
//  移动采集
//
//  Created by hcat on 2017/8/15.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AccidentProcessVC.h"
#import "FSTextView.h"
#import "CALayer+Additions.h"
#import "ListHomeVC.h"
#import "SRAlertView.h"
#import "UserModel.h"

@interface AccidentProcessVC ()


@property (weak, nonatomic) IBOutlet FSTextView *tf_damage;             //伤亡情况textView
@property (weak, nonatomic) IBOutlet FSTextView *tf_accidentCauses;     //事故成因textView
@property (weak, nonatomic) IBOutlet FSTextView *tf_mediationRecord;    //中队调解记录textView
@property (weak, nonatomic) IBOutlet FSTextView *tf_memo;               //备注记录与领导记录textView

@property (weak, nonatomic) IBOutlet UIButton *btn_handle;              //完成按钮,用于显示是否可以点击
@property (weak, nonatomic) IBOutlet UIButton *btn_end;                 //结案按钮，用于显示是否可以点击



@property (nonatomic,assign,readwrite) BOOL isCanCommit;                //用于判断是否可以提交
@property (nonatomic,assign) BOOL isChange;                             //用于判断是否编辑过


@end

@implementation AccidentProcessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"事故认定";
    
    _tf_damage.placeholderLabel.attributedText  = [ShareFun highlightInString:@"请输入简述(必填)" withSubString:@"(必填)"];
    _tf_accidentCauses.placeholderLabel.attributedText  = [ShareFun highlightInString:@"请输入简述(必填)" withSubString:@"(必填)"];
    _tf_mediationRecord.placeholder = @"请输入简述";
    _tf_memo.placeholder            = @"请输入简述";
    
    if (_param) {
        _tf_damage.text          = _param.casualties;
        _tf_accidentCauses.text  = _param.causes;
        _tf_mediationRecord.text = _param.mediationRecord;
        _tf_memo.text            = _param.memo;
    }
    
    if ([_tf_damage.text length] == 0 && [_tf_accidentCauses.text length] == 0) {
        self.isCanCommit = NO;
    }else{
        self.isCanCommit = YES;
    }
    
    self.isChange = NO;
    
}

#pragma mark - 返回处理

-(void)handleBtnBackClicked{
    
    if (self.isChange) {
        
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
        _btn_handle.enabled = NO;
        _btn_end.enabled = NO;
        [_btn_handle setBackgroundColor:DefaultBtnNuableColor];
        [_btn_end setBackgroundColor:DefaultBtnNuableColor];
    }else{
        _btn_handle.enabled = YES;
        _btn_end.enabled = YES;
        [_btn_handle setBackgroundColor:DefaultBtnColor];
        [_btn_end setBackgroundColor:UIColorFromRGB(0xff4e4e)];
    }
    
    if (![UserModel isPermissionForAccidentCase]) {
        [_btn_end setBackgroundColor:DefaultBtnNuableColor];
    }
    
}


#pragma mark - 完成按钮事件

- (IBAction)handlebtnCommitClicked:(id)sender {
    
    WS(weakSelf);
    
    AccidentSaveManger *manger = [[AccidentSaveManger alloc] init];
    manger.param = _param;
    [manger configLoadingTitle:@"保存"];
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            /************* 发送修改成功通知去刷新事故列表 ****************/
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ACCIDENT_SUCCESS object:nil];
            
            [strongSelf.navigationController popViewControllerAnimated:YES];
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}

#pragma mark - 结案按钮事件

- (IBAction)handleBtnEndClicked:(id)sender {
    
    if (![UserModel isPermissionForAccidentCase]) {
        
        [ShareFun showNoPermissionsTip];
        
        return;
    }
    
    WS(weakSelf);

    AccidentSaveManger *manger = [[AccidentSaveManger alloc] init];
    _param.state = @1;
    manger.param = _param;
    [manger configLoadingTitle:@"保存"];
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            /************* 发送修改成功通知去刷新事故列表 ****************/
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ACCIDENT_SUCCESS object:nil];
            
            [strongSelf.navigationController popViewControllerAnimated:YES];
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}


#pragma mark - 实时监听UITextView内容的变化

- (void)textViewDidChange:(FSTextView *)textView{
    
    LxDBAnyVar(textView.text);
    NSInteger length =  textView.text.length;
    
    if (textView == _tf_damage) {
        _param.casualties = length > 0 ? _tf_damage.formatText : nil;
    }
    
    if (textView == _tf_accidentCauses) {
        _param.causes = length > 0 ? _tf_accidentCauses.formatText : nil;
    }

    if (textView == _tf_mediationRecord) {
        _param.mediationRecord = length > 0 ? _tf_mediationRecord.text : @"";
    }
    
    if (textView == _tf_memo) {
        _param.memo = length > 0 ? _tf_memo.text : @"";
    }
    
    self.isChange = YES;
    [self judgeIsCommit];
    
}

#pragma mark - 判断事故认定是否可以提交

- (void)judgeIsCommit{

    if (_tf_damage.formatText.length > 0 && _tf_accidentCauses.formatText.length > 0) {
        
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

    LxPrintf(@"AccidentProcessVC dealloc");

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
