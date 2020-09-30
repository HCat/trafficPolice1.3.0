//
//  IllegalSearchView.m
//  移动采集
//
//  Created by hcat-89 on 2020/2/20.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "IllegalSearchView.h"
#import "AlertView.h"

@interface IllegalSearchView ()

@property (nonatomic,copy) NSString * carNo;
@property (nonatomic,strong) NSNumber * status;

@property (weak, nonatomic) IBOutlet UITextField *tf_search;

@property (weak, nonatomic) IBOutlet UIButton *btn_upAbnormal;

@property (weak, nonatomic) IBOutlet UIButton *btn_makesureAbnormal;

@end


@implementation IllegalSearchView

+ (IllegalSearchView *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"IllegalSearchView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    @weakify(self);
    [self.tf_search.rac_textSignal subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self);
        self.carNo = x;
    }];
    
    [RACObserve(self, status) subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if ([x isEqualToNumber:@8]) {
            [self.btn_upAbnormal setBackgroundColor:UIColorFromRGB(0xE4F0FC)];
             self.btn_upAbnormal.layer.borderWidth = 1.0f;
             self.btn_upAbnormal.layer.borderColor = UIColorFromRGB(0x3396FC).CGColor;
            
            [self.btn_makesureAbnormal setBackgroundColor:UIColorFromRGB(0xE6E6E6)];
            self.btn_makesureAbnormal.layer.borderWidth = 1.0f;
            self.btn_makesureAbnormal.layer.borderColor = [UIColor clearColor].CGColor;
             
        }else if ([x isEqualToNumber:@9]) {
            [self.btn_makesureAbnormal setBackgroundColor:UIColorFromRGB(0xE4F0FC)];
             self.btn_makesureAbnormal.layer.borderWidth = 1.0f;
             self.btn_makesureAbnormal.layer.borderColor = UIColorFromRGB(0x3396FC).CGColor;
            
            [self.btn_upAbnormal setBackgroundColor:UIColorFromRGB(0xE6E6E6)];
            self.btn_upAbnormal.layer.borderWidth = 1.0f;
            self.btn_upAbnormal.layer.borderColor = [UIColor clearColor].CGColor;
            
        }else{
            [self.btn_makesureAbnormal setBackgroundColor:UIColorFromRGB(0xE6E6E6)];
            self.btn_makesureAbnormal.layer.borderWidth = 1.0f;
            self.btn_makesureAbnormal.layer.borderColor = [UIColor clearColor].CGColor;
            
            [self.btn_upAbnormal setBackgroundColor:UIColorFromRGB(0xE6E6E6)];
            self.btn_upAbnormal.layer.borderWidth = 1.0f;
            self.btn_upAbnormal.layer.borderColor = [UIColor clearColor].CGColor;
            
        }
        
    }];
    
}

- (IBAction)handleBtnUpAblumClicked:(id)sender {
    self.status = @8;
    
}

- (IBAction)handleBtnMakesureAblumClicked:(id)sender {
    self.status = @9;
    
}

- (IBAction)handleBtnQuitClicked:(id)sender {
    

    AlertView * alertView = (AlertView *)self.superview;
    [alertView handleBtnDismissClick:nil];
    
}

- (IBAction)handleBtnCollectClicked:(id)sender {
    
    if (self.carNo.length == 0 && self.status == nil) {
        [LRShowHUD showError:@"请选择查询条件" duration:1.5f];
        return;
    }
    
//    if ([ShareFun validateCarNumber:self.carNo]) {
//        [LRShowHUD showError:@"请输入正确的车牌号" duration:1.5f];
//        return;
//    }
    
    if (self.selectedBlock) {
        self.selectedBlock(self.carNo,self.status);
    }
    
    AlertView * alertView = (AlertView *)self.superview;
    
    [alertView handleBtnDismissClick:nil];
    
}



@end
