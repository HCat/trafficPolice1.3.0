//
//  JointVideoVC.m
//  移动采集
//
//  Created by hcat on 2018/1/19.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "JointVideoVC.h"

#import "LRVideoVC.h"
#import "LRPlayVC.h"
#import "JointLawAPI.h"

#import "ArtVideoModel.h"
#import "ArtVideoUtil.h"

#import "SRAlertView.h"


@interface JointVideoVC ()

@property (weak, nonatomic) IBOutlet UIView * v_bottom;
@property (weak, nonatomic) IBOutlet UIButton * btn_bottom;

@property (weak, nonatomic) IBOutlet UIView *v_video;
@property (weak, nonatomic) IBOutlet UIButton *btn_videoPlay;


@property (weak, nonatomic) IBOutlet UIButton *btn_videoAdd;

@property (nonatomic,assign) BOOL isCanCommit;
@property (nonatomic,strong) ArtVideoModel *currentRecord;

@end

@implementation JointVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加视频";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.v_video.hidden = YES;
    self.isCanCommit = NO;
    
    _v_bottom.layer.shadowColor = UIColorFromRGB(0x444444).CGColor;//shadowColor阴影颜色
    _v_bottom.layer.shadowOffset = CGSizeMake(0,-2);
    _v_bottom.layer.shadowOpacity = 0.1;
    _v_bottom.layer.shadowRadius = 2;
    
}

#pragma mark - 返回按钮事件

-(void)handleBtnBackClicked{
    
    if (self.currentRecord) {
        
        WS(weakSelf);
        SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"当前已编辑，是否退出编辑"
                                                    leftActionTitle:@"取消"
                                                   rightActionTitle:@"退出"
                                                     animationStyle:AlertViewAnimationNone
                                                       selectAction:^(AlertViewActionType actionType) {
                                                           if (actionType == AlertViewActionTypeLeft) {
                                                               
                                                               
                                                           } else if(actionType == AlertViewActionTypeRight) {
                                                               if (weakSelf.currentRecord) {
                                                                   [ArtVideoUtil deleteVideo:weakSelf.currentRecord.videoAbsolutePath];
                                                               }
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                               
                                                           }
                                                       }];
        alertView.blurCurrentBackgroundView = NO;
        [alertView show];
        
        
    }else{
        if (self.currentRecord) {
            [ArtVideoUtil deleteVideo:self.currentRecord.videoAbsolutePath];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

#pragma mark - set && get

- (void)setIsCanCommit:(BOOL)isCanCommit{
    
    _isCanCommit = isCanCommit;
    
    if (_isCanCommit) {
        _btn_bottom.enabled = YES;
        [_btn_bottom setBackgroundColor:DefaultBtnColor];
    } else {
        _btn_bottom.enabled = NO;
        [_btn_bottom setBackgroundColor:DefaultBtnNuableColor];
    }
}

#pragma mark - 视频点击播放事件
- (IBAction)handleBtnVideoPlayClicked:(id)sender {
    
    LRPlayVC *t_vc = [[LRPlayVC alloc] init];
    t_vc.videoUrl = self.currentRecord.videoAbsolutePath;
    WS(weakSelf);
    t_vc.deleteBlock = ^{
        SW(strongSelf, weakSelf);
        strongSelf.v_video.hidden =YES;
        strongSelf.currentRecord = nil;
        strongSelf.isCanCommit = NO;
    };
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

#pragma mark - 视频点击录入事件
- (IBAction)handlebtnInputVideoClicked:(id)sender {
    
    WS(weakSelf);
    LRVideoVC *t_videoVC = [[LRVideoVC alloc] init];
    t_videoVC.recordComplete = ^(ArtVideoModel *currentRecord) {
        SW(strongSelf, weakSelf);
        strongSelf.currentRecord = currentRecord;
        strongSelf.v_video.hidden = NO;
        UIImage *image = [UIImage imageWithContentsOfFile:strongSelf.currentRecord.thumAbsolutePath];
        [strongSelf.btn_videoPlay setImage:image forState:UIControlStateNormal];
        strongSelf.isCanCommit = YES;
    };
    [self presentViewController:t_videoVC
                       animated:YES
                     completion:^{
                     }];
}

#pragma mark - 提交按钮

- (IBAction)handleBtnCommit:(id)sender{
    
    WS(weakSelf);
    
    [NetworkStatusMonitor StartWithBlock:^(NSInteger NetworkStatus) {
        
        //大类 : 0没有网络 1为WIFI网络 2/6/7为2G网络  3/4/5/8/9/11/12为3G网络
        //10为4G网络
        [NetworkStatusMonitor StopMonitor];
        if (NetworkStatus != 10 && NetworkStatus != 1) {
            [ShareFun showTipLable:@"当前非4G网络,传输速度受影响"];
            return;
        }
    }];
    
    JointLawVideoUploadManger *manager = [[JointLawVideoUploadManger alloc] init];
    
    if (self.currentRecord && self.currentRecord.videoAbsolutePath.length > 0) {
        if ([ArtVideoUtil existVideo]) {
            self.currentRecord.fileData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:self.currentRecord.videoAbsolutePath]];
            self.currentRecord.fileName = self.currentRecord.videoRelativePath;
            self.currentRecord.name  = @"file";
            self.currentRecord.mimeType = @"video/mpeg";
            manager.file = self.currentRecord;
        }
    }else{
        return;
    }
    
    if (_oldVideoId) {
        manager.oldVideoId = _oldVideoId;
    }else{
        manager.oldVideoId = @"";
    }
    
    [manager configLoadingTitle:@"提交"];
    
    [manager startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        
        if (manager.responseModel.code == CODE_SUCCESS) {
            
            JointLawVideoModel *model = manager.jointLawVideoModel;
            model.videoImg = strongSelf.currentRecord.thumAbsolutePath;
            model.videoPath = strongSelf.currentRecord.videoAbsolutePath;
            
            strongSelf.block(model);
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        
    }];
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"JointVideoVC dealloc");
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
