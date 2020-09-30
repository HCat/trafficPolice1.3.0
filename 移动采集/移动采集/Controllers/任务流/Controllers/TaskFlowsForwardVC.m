//
//  TaskFlowsForwardVC.m
//  移动采集
//
//  Created by hcat-89 on 2020/3/10.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "TaskFlowsForwardVC.h"
#import "FSTextView.h"

#import "TaskFlowsUserListVC.h"


@interface TaskFlowsForwardVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf_user;
@property (weak, nonatomic) IBOutlet UIButton *btn_user;
@property (weak, nonatomic) IBOutlet FSTextView *tv_taskContent;
@property (weak, nonatomic) IBOutlet UIButton *btn_commit;
@property (weak, nonatomic) IBOutlet UIButton *btn_voice;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_view_top;





@property (nonatomic,strong) TaskFlowsForwardViewModel * viewModel;

@end

@implementation TaskFlowsForwardVC

- (instancetype)initWithViewModel:(TaskFlowsForwardViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.layout_view_top.constant = self.layout_view_top.constant + 40;
    
    [self configUI];
    [self bindViewModel];
}

- (void)configUI{
    
    @weakify(self);
    self.title = @"转发";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tv_taskContent.rac_textSignal subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self);
        
        self.viewModel.content = x;
    }];
    
    [RACObserve(self.viewModel, isCanCommit) subscribeNext:^(id  _Nullable x) {
        
        @strongify(self);
        
        if ([x boolValue]) {
            self.btn_commit.enabled = YES;
            [self.btn_commit setBackgroundColor:DefaultBtnColor];
        }else{
            self.btn_commit.enabled = NO;
            [self.btn_commit setBackgroundColor:DefaultBtnNuableColor];
        }
        
    }];
    
    self.tv_taskContent.layer.borderColor = UIColorFromRGB(0xDCDCDC).CGColor;
    self.tv_taskContent.layer.borderWidth = 0.5f;
    self.tv_taskContent.layer.cornerRadius = 5.f;
    self.tv_taskContent.layer.masksToBounds = YES;
    
}


- (void)bindViewModel{
    
    @weakify(self);
    
    [[self.btn_user rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self handlebtnChoiceUserClicked:nil];
        
    }];
    
    
    [[self.btn_commit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.viewModel.command_commint execute:nil];
        
    }];
    
    [[self.btn_voice rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
           @strongify(self);
           self.viewModel.sendNotice = @(![self.viewModel.sendNotice boolValue]);
           
       }];
       
       
       [RACObserve(self.viewModel, sendNotice) subscribeNext:^(NSNumber * _Nullable x) {
           
           @strongify(self);
           
           if ([x isEqualToNumber:@0]) {
               [self.btn_voice setImage:[UIImage imageNamed:@"taskFlows_voice_n"] forState:UIControlStateNormal];
           }else{
               [self.btn_voice setImage:[UIImage imageNamed:@"taskFlows_voice_y"] forState:UIControlStateNormal];
           }
           
       }];
    
    
    [self.viewModel.command_commint.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        if ([x isEqualToString:@"转发成功"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"任务流处理成功" object:nil userInfo:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    }];
    
}

#pragma mark - buttonAction

- (void)handlebtnChoiceUserClicked:(id)sender{
    
    TaskFlowsUserListVC * listVC = [[TaskFlowsUserListVC alloc] init];
    @weakify(self);
    listVC.block = ^(AddressBookModel * _Nonnull model) {
        @strongify(self);
        self.viewModel.userId = model.userId;
        self.tf_user.text = model.realName;
    };
    [self.navigationController pushViewController:listVC animated:YES];
    
}


#pragma mark - 添加监听Textfield的变化，用于给参数实时赋值

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == _tf_user) {
        [self handlebtnChoiceUserClicked:nil];
        return NO;
    }

    return YES;
}


- (void)dealloc{
    LxPrintf(@"TaskFlowsForwardVC dealloc");
}

@end
