//
//  PoliceReleaseRadioVC.m
//  移动采集
//
//  Created by hcat on 2018/11/21.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "PoliceReleaseRadioVC.h"
#import "FSTextView.h"
#import "PoliceDistributeAPI.h"

@interface PoliceReleaseRadioVC ()

@property (weak, nonatomic) IBOutlet FSTextView *tv_radio;
@property (weak, nonatomic) IBOutlet UIButton *btn_commit;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_text_top;



@end

@implementation PoliceReleaseRadioVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btn_commit.enabled = NO;
    [self.btn_commit setBackgroundColor:DefaultBtnNuableColor];
    
    self.title = @"广播内容";
    self.layout_text_top.constant = Height_NavBar;
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    @weakify(self);
    [[self.tv_radio rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (x.length == 0) {
            self.btn_commit.enabled = NO;
            [self.btn_commit setBackgroundColor:DefaultBtnNuableColor];
           
        }else{
            self.btn_commit.enabled = YES;
            [self.btn_commit setBackgroundColor:DefaultBtnColor];
            
        }
        
    }];
}

#pragma mark - button methods

- (IBAction)handleBtnReleaceClicked:(id)sender {
    
    @weakify(self);
    PoliceDistributeSendNoticeParam * param = [[PoliceDistributeSendNoticeParam alloc] init];
    param.userIds = self.userIds;
    param.content = self.tv_radio.text;
    PoliceDistributeSendNoticeManger * manger = [[PoliceDistributeSendNoticeManger alloc] init];
    manger.param = param;
    [manger configLoadingTitle:@"发布"];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        @strongify(self);
        if (manger.responseModel.code == CODE_SUCCESS) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}



#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"PoliceReleaseRadioVC dealloc");
}


@end
