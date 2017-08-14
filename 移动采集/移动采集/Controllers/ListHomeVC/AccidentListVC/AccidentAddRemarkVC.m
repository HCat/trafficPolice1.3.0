//
//  AccidentAddRemarkVC.m
//  移动采集
//
//  Created by hcat on 2017/8/14.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AccidentAddRemarkVC.h"
#import "FSTextView.h"
#import "RemarkModel.h"
#import "UserModel.h"
#import "AccidentAPI.h"

@interface AccidentAddRemarkVC ()

@property (weak, nonatomic) IBOutlet FSTextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *btn_commit;
@property (nonatomic,assign) BOOL isCanCommit;


@end

@implementation AccidentAddRemarkVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"添加备注";
    
    [_textView setDelegate:(id<UITextViewDelegate> _Nullable)self];
    _textView.placeholder = @"点击输入备注";
    
}


#pragma mark - set && get

-(void)setIsCanCommit:(BOOL)isCanCommit{
    _isCanCommit = isCanCommit;
    if (_isCanCommit == NO) {
        _btn_commit.enabled = NO;
        [_btn_commit setBackgroundColor:DefaultBtnNuableColor];
    }else{
        _btn_commit.enabled = YES;
        [_btn_commit setBackgroundColor:DefaultBtnColor];
    }
    
}

#pragma mark - 实时监听UITextView内容的变化

- (void)textViewDidChange:(FSTextView *)textView{
    
    if(textView.formatText.length == 0){
        self.isCanCommit = NO;
    }else{
        
        self.isCanCommit = YES;
    }
    
}


- (IBAction)handleBtnRemarkCommitClicked:(id)sender {
    
    AccidentAddRemarkManger * manger = [AccidentAddRemarkManger new];
    manger.accidentId = _accidentId;
    manger.remark = _textView.text;
    [manger configLoadingTitle:@"提交"];
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        RemarkModel * t_model = [[RemarkModel alloc] init];
        t_model.createName = [UserModel getUserModel].realName;
        NSDate* date = [NSDate date];
        NSTimeInterval createTime =[date timeIntervalSince1970] * 1000;
        t_model.createTime = @(createTime);
        t_model.contents = manger.remark;

        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ADDREMARK_SUCCESS object:t_model];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];

}




#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    LxPrintf(@"accidentAddRemarkVC dealloc");

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
