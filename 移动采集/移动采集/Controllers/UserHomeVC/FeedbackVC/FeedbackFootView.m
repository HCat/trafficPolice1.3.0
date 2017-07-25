//
//  FeedbackFootView.m
//  移动采集
//
//  Created by hcat on 2017/7/25.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "FeedbackFootView.h"

@interface FeedbackFootView ()

@property (weak, nonatomic) IBOutlet UIButton *btn_commit;

@end

@implementation FeedbackFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isCanCommit = NO;
    
}

#pragma mark - set && get

-(void)setIsCanCommit:(BOOL)isCanCommit{
    _isCanCommit = isCanCommit;
    if (_isCanCommit == NO) {
        _btn_commit.enabled = NO;
        [_btn_commit setBackgroundColor:UIColorFromRGB(0xe6e6e6)];
    }else{
        _btn_commit.enabled = YES;
        [_btn_commit setBackgroundColor:DefaultNavColor];
    }
    
}



#pragma mark - btnAction

- (IBAction)handlebtnCommitClicked:(id)sender {
    
    if (self.handleCommitBlock) {
        self.handleCommitBlock();
    }
    
}

@end
