//
//  AccidentCallPoliceCell.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/11/9.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "AccidentCallPoliceCell.h"
#import "AccidentMoreAPIs.h"
#import "AccidentManageVC.h"
#import "AccidentHistoryListVC.h"


@interface AccidentCallPoliceCell ()

@property (weak, nonatomic) IBOutlet UITextField *tf_callPoliceName;
@property (weak, nonatomic) IBOutlet UITextField *tf_callPolicePhone;

@property (weak, nonatomic) IBOutlet UIButton *btn_userNumber;
@property (weak, nonatomic) IBOutlet UIImageView *image_userNumber;
@property (nonatomic, copy) RACCommand * command_identNoCount;

@end



@implementation AccidentCallPoliceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    @weakify(self);
    
    
    [self setUpCommonUITextField:self.tf_callPoliceName];
    [self setUpCommonUITextField:self.tf_callPolicePhone];
    
    [[self.btn_userNumber rac_signalForControlEvents:UIControlEventTouchUpInside ] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.partyFactory.param.callpoliceManPhone && self.partyFactory.param.callpoliceManPhone.length > 10) {
            
            AccidentHistoricalListViewmodel * viewModel = [[AccidentHistoricalListViewmodel alloc] init];
            if (self.accidentType == AccidentTypeAccident) {
                viewModel.param.accidentType = @"1";
                viewModel.param.queryType = @"3";
                viewModel.param.callpoliceMan = self.partyFactory.param.callpoliceManPhone;
            }else if (self.accidentType == AccidentTypeFastAccident){
                viewModel.param.accidentType = @"2";
                viewModel.param.queryType = @"3";
                viewModel.param.callpoliceMan = self.partyFactory.param.callpoliceManPhone;
            }
            
            AccidentHistoryListVC * vc = [[AccidentHistoryListVC alloc] initWithViewModel:viewModel];
            
            AccidentManageVC * t_vc = (AccidentManageVC *)[ShareFun findViewController:self withClass:[AccidentManageVC class]];
            
            [t_vc.navigationController pushViewController:vc animated:YES];
            
        }
        
    }];
    
    
}

- (void)setPartyFactory:(AccidentUpFactory *)partyFactory{
    
    _partyFactory = partyFactory;
    
    @weakify(self);
    RAC(self.partyFactory.param, callpoliceMan) = [self.tf_callPoliceName.rac_textSignal skip:1];
    RAC(self.partyFactory.param, callpoliceManPhone) = [self.tf_callPolicePhone.rac_textSignal skip:1];
    
    [RACObserve(self.partyFactory.param, callpoliceManPhone) subscribeNext:^(NSString  * _Nullable x) {
        @strongify(self);
        if (x && x.length > 10) {
            [self.command_identNoCount execute:x];
        }
    
    }];
    
    
    [self.btn_userNumber setTitle:@"历史0" forState:UIControlStateNormal];
    
    
    [self.command_identNoCount.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        if ([x isKindOfClass:[NSNumber class]]) {
            NSNumber * t_x = (NSNumber *)x;
            self.btn_userNumber.hidden = NO;
            self.image_userNumber.hidden = NO;
            [self.btn_userNumber setTitle:[NSString stringWithFormat:@"历史%d",[t_x intValue]] forState:UIControlStateNormal];
        }
    
    }];
    
}






- (RACCommand *)command_identNoCount{
    
    if (_command_identNoCount == nil) {
        
        @weakify(self);
        _command_identNoCount = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
                
                AccidentMoreCountParam * param = [[AccidentMoreCountParam alloc] init];
                param.queryType = @"3";
                param.callpoliceMan = input;
                if (self.accidentType == AccidentTypeAccident) {
                    param.accidentType = @"1";
                }else if (self.accidentType == AccidentTypeFastAccident){
                    param.accidentType = @"2";
                }
                
                
                AccidentMoreCountManger * manger = [[AccidentMoreCountManger alloc] init];
                manger.param = param;
                manger.isNoShowFail = YES;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        [subscriber sendNext:manger.carNoNumber];
                    }else{
                        [subscriber sendNext:@"加载失败"];
                    }
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@"加载失败"];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
        
    }
    
    return _command_identNoCount;
    
}



- (void)setUpCommonUITextField:(UITextField *)textField{
    
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    
}


@end
