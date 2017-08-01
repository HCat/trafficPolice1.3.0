//
//  LRPlayVC.m
//  trafficPolice
//
//  Created by hcat on 2017/6/6.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "LRPlayVC.h"
#import "UIButton+Block.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ArtVideoUtil.h"

@interface LRPlayVC ()

@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,assign) BOOL isPlaying;    //是否在播放

@end

@implementation LRPlayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:self.videoUrl]];
    _player = [AVPlayer playerWithPlayerItem:playerItem];
    if([[UIDevice currentDevice] systemVersion].intValue>=10){
        //      增加下面这行可以解决iOS10兼容性问题了
        self.player.automaticallyWaitsToMinimizeStalling = NO;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:playerLayer];
    
    [_player play];
    
}

- (void)createViews {
   
    self.title = @"视频播放";
    
    UIButton *trachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    trachBtn.frame = CGRectMake(0, 0, 18, 18);
    [trachBtn setImage:[UIImage imageNamed:@"btn_trash_photoBrowser"] forState:UIControlStateNormal];
    [trachBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [trachBtn addTarget:self action:@selector(trachBtn) forControlEvents:UIControlEventTouchUpInside];
    [trachBtn setEnlargeEdgeWithTop:25.f right:25.f bottom:25.f left:25.f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:trachBtn];
}

#pragma mark - 垃圾桶按钮

- (void)trachBtn{
    
    [ArtVideoUtil deleteVideo:self.videoUrl];
    
    if (self.deleteBlock) {
        self.deleteBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 

- (void)playEnd {
    
    [_player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [_player play];
    }];
}



#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    [_player.currentItem cancelPendingSeeks];
    [_player.currentItem.asset cancelLoading];
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
    LxPrintf(@"LRPlayVC dealloc");
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
