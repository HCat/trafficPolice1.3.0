//
//  PoliceDistributeVC.m
//  移动采集
//
//  Created by hcat on 2018/11/5.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "PoliceDistributeVC.h"
#import "PoliceDistributeViewModel.h"

@interface PoliceDistributeVC ()

@property (nonatomic,strong) PoliceDistributeViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UIButton *btn_search;
@property (weak, nonatomic) IBOutlet UIButton *btn_usrLocation;
@property (weak, nonatomic) IBOutlet UIButton *btn_radio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_topView_height;

@end

@implementation PoliceDistributeVC

- (instancetype)initWithViewModel:(PoliceDistributeViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IPHONE_X_MORE) {
        _layout_topView_height.constant = _layout_topView_height.constant + 24;
    }
    
    [[_btn_radio rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        
    }];
    
    [[_btn_search rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
    
    [[_btn_usrLocation rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
    
    
}

#pragma mark - buttonAction

- (IBAction)handleBtnBackClickingAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"PoliceDistributeVC");
}

@end
