//
//  VehicleUpMoreCell.m
//  移动采集
//
//  Created by hcat on 2018/5/18.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleUpMoreCell.h"
#import "TTGTextTagCollectionView.h"
#import "FSTextView.h"


@interface VehicleUpMoreCell()

@property (weak, nonatomic) IBOutlet UIView *v_tip;

@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *v_tag;

@property (weak, nonatomic) IBOutlet FSTextView *tv_describe;           //简述

@property (weak, nonatomic) IBOutlet UILabel *lb_textCount;             //用于显示简述输入多少文字

@property (weak, nonatomic) IBOutlet UIButton *btn_commit;

@end


@implementation VehicleUpMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _v_tag.alignment = TTGTagCollectionAlignmentLeft;
    _v_tag.manualCalculateHeight = YES;
    [_v_tag setDelegate:(id<TTGTextTagCollectionViewDelegate>)self];
    TTGTextTagConfig *config = [TTGTextTagConfig new];
    config.tagTextFont = [UIFont systemFontOfSize:13];
    
    config.tagTextColor = UIColorFromRGB(0x999999);
    config.tagBackgroundColor = UIColorFromRGB(0xFFFFFF);
    config.tagSelectedTextColor = UIColorFromRGB(0xFFFFFF);
    config.tagSelectedBackgroundColor = UIColorFromRGB(0x4281E8);
    config.tagCornerRadius = 3.f;
    config.tagSelectedCornerRadius = 3.f;
    config.tagBorderWidth = 0.0f;
    config.tagSelectedBorderWidth = 0.0f;

    config.tagShadowColor = [UIColor clearColor];

    _v_tag.defaultConfig = config;
    
    //配置FSTextView
    [self.tv_describe setDelegate:(id<UITextViewDelegate> _Nullable)self];
    self.tv_describe.placeholder = @"请输入备注";
    //self.tv_describe.maxLength = 150;   //最大输入字数
    WS(weakSelf);
    [self.tv_describe addTextDidChangeHandler:^(FSTextView *textView) {
        // 文本改变后的相应操作.
        weakSelf.lb_textCount.text =
        [NSString stringWithFormat:@"%ld/%ld",textView.text.length,textView.maxLength];
        
    }];
    // 添加到达最大限制Block回调.
    [self.tv_describe addTextLengthDidMaxHandler:^(FSTextView *textView) {
        // 达到最大限制数后的相应操作.
    }];
}




#pragma mark - set&&get

- (void)setTags:(NSMutableArray<NSString *> *)tags{
    _tags = tags;
    
    [_v_tag removeAllTags];
    [_v_tag addTags:_tags];
   
    
    _v_tag.preferredMaxLayoutWidth = SCREEN_WIDTH - 45;
    
}

- (void)setTagIndexs:(NSMutableArray<NSNumber *> *)tagIndexs{
    _tagIndexs = tagIndexs;
    
    if (_tagIndexs) {
        for (NSNumber *number in _tagIndexs) {
            [_v_tag setTagAtIndex:number.integerValue selected:YES];
        }
    }
    
    
}


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

- (void)setRemark:(NSString *)remark{
    _remark = remark;
    if (_remark) {
        self.tv_describe.text = _remark;
    }
    
}

#pragma mark - buttonAction

- (IBAction)handleBtnUpClicked:(id)sender {
    
    if (self.upBlock) {
        self.upBlock();
    }
    
    
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected{
    if (selected) {
         [_tagIndexs addObject:@(index)];
    }else{
        
        [_tagIndexs removeObject:@(index)];
    }
   
    NSString *t_str = [_v_tag.allSelectedTags componentsJoinedByString:@","];
    _param.illegalType = t_str;
    
    
}

#pragma mark - 实时监听UITextView内容的变化
//只能监听键盘输入时的变化(setText: 方式无法监听),如果想修复可以参考http://www.jianshu.com/p/75355acdd058

- (void)textViewDidChange:(FSTextView *)textView{
    
    _param.remark = textView.formatText;
    
}


#pragma mark - dealloc

- (void)dealloc{
    LxPrintf(@"VehicleUpMoreCell dealloc");
    
}

@end
