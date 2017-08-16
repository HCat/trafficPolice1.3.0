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

@interface AccidentProcessVC ()


@property (weak, nonatomic) IBOutlet UIView *v_damage;
@property (weak, nonatomic) IBOutlet UIView *v_accidentCauses;

@property (weak, nonatomic) IBOutlet UIView *v_resultConciliation;


@property (weak, nonatomic) IBOutlet FSTextView *tf_damage;
@property (weak, nonatomic) IBOutlet FSTextView *tf_accidentCauses;
@property (weak, nonatomic) IBOutlet FSTextView *tf_mediationRecord;
@property (weak, nonatomic) IBOutlet FSTextView *tf_memo;

@property (weak, nonatomic) IBOutlet FSTextView *tf_responsibility;


@property (weak, nonatomic) IBOutlet UIButton *btn_handle;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_top;

@end

@implementation AccidentProcessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"事故认定";
    
    if (_accidentType == AccidentTypeAccident) {
        self.title = @"事故认定";
        _v_resultConciliation.hidden = YES;
        _layout_top.constant = 295.f;
        [self.view layoutIfNeeded];
        
        _tf_damage.placeholderLabel.attributedText  = [ShareFun highlightInString:@"请输入简述(必填)" withSubString:@"(必填)"];
        _tf_accidentCauses.placeholderLabel.attributedText  = [ShareFun highlightInString:@"请输入简述(必填)" withSubString:@"(必填)"];
        
        
    }else if (_accidentType == AccidentTypeFastAccident){
        self.title = @"快处认定";
        _v_damage.hidden = YES;
        _v_accidentCauses.hidden = YES;
        _layout_top.constant = 155.f;
        [self.view layoutIfNeeded];
        _tf_responsibility.placeholder  = [[ShareFun highlightInString:@"请输入简述(必填)" withSubString:@"(必填)"] string];
        
    }

}


#pragma mark - 完成按钮事件

- (IBAction)handlebtnCommitClicked:(id)sender {
    
    
    
    
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
