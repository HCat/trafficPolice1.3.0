//
//  ParkingForensicsHeadView.m
//  移动采集
//
//  Created by hcat on 2019/7/29.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingForensicsHeadView.h"
#import "FSTextView.h"
#import "SearchLocationVC.h"
#import "PersonLocationVC.h"
#import "ParkingForensicsVC.h"
//#import "LRCameraVC.h"
#import "ParkCameraVC.h"


@interface ParkingForensicsHeadView()

@property (weak, nonatomic) IBOutlet UITextField * tf_carNumber;            //车牌号

@property (weak, nonatomic) IBOutlet UIButton *btn_shibie;         //车牌号识别

@end


@implementation ParkingForensicsHeadView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //添加对定位的监听
    
        
    }
    return self;
}


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    
    _tf_carNumber.attributedPlaceholder   = [ShareFun highlightInString:@"请输入车牌号(必填)" withSubString:@"(必填)"] ;
    [self setUpCommonUITextField:_tf_carNumber];
    @weakify(self);
    
    [self.tf_carNumber.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
           @strongify(self);
           self.param.carNo = x;
       }];
    
}

#pragma mark - 添加违章类型事件

- (IBAction)handleBtnCarNumberClicked:(id)sender {
    
    @weakify(self);
    
    ParkingForensicsVC * t_vc = (ParkingForensicsVC *)[ShareFun findViewController:self withClass:[ParkingForensicsVC class]];
    
    ParkCameraVC *home = [[ParkCameraVC alloc] init];
    home.type = 1;
    home.park_string = self.placenum;
    home.fininshCaptureBlock = ^(ImageFileInfo * imageInfo) {
        
        @strongify(self);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(recognitionCarNumber:)]) {
            [self.delegate recognitionCarNumber:imageInfo];
        }
    };
    
    [t_vc presentViewController:home
                       animated:NO
                     completion:^{
                     }];
   
}



#pragma mark - 配置UITextField

- (void)setUpCommonUITextField:(UITextField *)textField{
    
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    
}


- (void)setParam:(ParkingForensicsParam *)param{
    
    _param = param;
    
    @weakify(self);
    
    [RACObserve(self.param, carNo) subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (x && x.length > 0) {
            self.tf_carNumber.text = x;
            
            
            
            
        }
        
    }];
    
}

@end
