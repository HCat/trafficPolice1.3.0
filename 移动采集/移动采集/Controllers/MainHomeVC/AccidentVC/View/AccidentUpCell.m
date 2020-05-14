//
//  AccidentUpCell.m
//  移动采集
//
//  Created by hcat on 2018/7/10.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "AccidentUpCell.h"

@interface AccidentUpCell()

@property (weak, nonatomic) IBOutlet UIButton *btn_commit;

@end

@implementation AccidentUpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgeCommitForNotification:) name:@"NSNotification_juegeCommit" object:nil];
}


- (IBAction)handleBtnUpClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleUpAction)]) {
        [self.delegate handleUpAction];
    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - notification

-(void)judgeCommitForNotification:(NSNotification *)sender{
    
    NSNumber *number = sender.object;
    
    if ([number isEqualToNumber:@1]) {
        _btn_commit.enabled = YES;
        [_btn_commit setBackgroundColor:DefaultBtnColor];
    }else{
        
        _btn_commit.enabled = NO;
        [_btn_commit setBackgroundColor:DefaultBtnNuableColor];
    }

}


#pragma mark - dealloc

- (void)dealloc{
    LxPrintf(@"AccidentUpCell dealloc");
    
}

@end
