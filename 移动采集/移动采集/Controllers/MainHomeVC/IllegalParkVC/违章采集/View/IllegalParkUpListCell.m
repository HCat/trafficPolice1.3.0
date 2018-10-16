//
//  IllegalParkUpListCell.m
//  移动采集
//
//  Created by hcat on 2018/9/29.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalParkUpListCell.h"

@interface IllegalParkUpListCell()

@property (weak, nonatomic) IBOutlet UIButton *btn_abnormal;

@property (weak, nonatomic) IBOutlet UILabel *lb_carNumber;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_width;


@end


@implementation IllegalParkUpListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setViewModel:(IllegalUpListCellViewModel *)viewModel{
    
    _viewModel = viewModel;
    
    if (_viewModel) {
        self.lb_carNumber.text = [ShareFun takeStringNoNull:_viewModel.carNumber];
        self.lb_time.text = [ShareFun timeWithTimeInterval:_viewModel.time];
        self.lb_address.text = [ShareFun takeStringNoNull:_viewModel.address];
        self.btn_abnormal.hidden = !_viewModel.isAbnormal;
        
        WS(weakSelf);
        
        [RACObserve(_viewModel, progress) subscribeNext:^(id  _Nullable x) {
            SW(strongSelf, weakSelf);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([x floatValue] == 0.0f) {
                    strongSelf.layout_width.constant = 0;
                    [strongSelf layoutIfNeeded];
                }else{
                    [UIView animateWithDuration:1.0 animations:^{
                        strongSelf.layout_width.constant = [x floatValue] * SCREEN_WIDTH;
                        [strongSelf layoutIfNeeded];
                    }];
                }
                
            });
            
           
        }];
        
        
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    LxPrintf(@"IllegalParkUpListCell dealloc");
}

@end
