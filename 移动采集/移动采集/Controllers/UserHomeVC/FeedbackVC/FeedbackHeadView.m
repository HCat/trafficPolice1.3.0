//
//  FeedbackHeadView.m
//  移动采集
//
//  Created by hcat on 2017/7/25.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "FeedbackHeadView.h"
#import "CALayer+Additions.h"

@interface FeedbackHeadView ()


@property (nonatomic,assign,readwrite) BOOL isCanCommit;

@end


@implementation FeedbackHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    [_textView setDelegate:(id<UITextViewDelegate> _Nullable)self];
    _textView.placeholder = @"请输入反馈或建议";
    _textView.maxLength = 300;
    [_textView addTextDidChangeHandler:^(FSTextView *textView) {
    
    }];
    // 添加到达最大限制Block回调.
    [_textView addTextLengthDidMaxHandler:^(FSTextView *textView) {
        // 达到最大限制数后的相应操作.
    }];
    
    
}

#pragma mark - 实时监听UITextView内容的变化
//只能监听键盘输入时的变化(setText: 方式无法监听),如果想修复可以参考http://www.jianshu.com/p/75355acdd058
- (void)textViewDidChange:(FSTextView *)textView{
    
    if(textView.formatText.length == 0){
        self.isCanCommit = NO;
    }else{
        
        self.isCanCommit = YES;
    }
    
}


@end
