//
//  LRBaseCollectionView.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/12.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "LRBaseCollectionView.h"
#import <MJRefresh/MJRefresh.h>

@implementation LRBaseCollectionView

#pragma mark - init

- (instancetype)init{
    self = [super init];
    [self configCollectionView];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self configCollectionView];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    [self configCollectionView];
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self configCollectionView];
}

// 初始化基础配置
- (void)configCollectionView{
   
    self.enableRefresh = NO;       // 默认关闭下拉刷新
    self.enableLoadMore = NO;      // 默认关闭上拉加载
    self.autoNetworkNotice = NO;   // 默认关闭网络提示
    self.isNeedNoDataReload = YES;  // 默认开启空数据的时候有重新加载数据按钮
    self.isHavePlaceholder = YES;   // 默认开启背景图
    
}

- (void)setEnableRefresh:(BOOL)enableRefresh{
    if (!enableRefresh) self.mj_header = nil;
    else {
        __weak typeof(self) weakSelf = self;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (weakSelf.collectionViewHeaderRefresh) weakSelf.collectionViewHeaderRefresh();
        }];
        [header setTitle:@"下拉查询" forState:MJRefreshStateIdle];
        [header setTitle:@"松手开始查询" forState:MJRefreshStatePulling];
        [header setTitle:@"查询中..." forState:MJRefreshStateRefreshing];
        header.stateLabel.font = [UIFont systemFontOfSize:15];
        
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        self.mj_header = header;
        
    }
}

- (void)setEnableLoadMore:(BOOL)enableLoadMore{
    if (!enableLoadMore) self.mj_footer = nil;
    else{
        __weak typeof(self) weakSelf = self;
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weakSelf.collectionViewFooterLoadMore) weakSelf.collectionViewFooterLoadMore();
        }];
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        [footer setTitle:@"加载更多..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
        
        footer.stateLabel.font = [UIFont systemFontOfSize:15];
        footer.stateLabel.textColor = UIColorFromRGB(0xa6a6a6);
        self.mj_footer = footer;
        self.mj_footer.automaticallyChangeAlpha = YES;
        
    }
    
    
}

- (void)setIsHavePlaceholder:(BOOL)isHavePlaceholder{
    
    if (!isHavePlaceholder) {
        self.lr_handler = nil;
    }else{
        if (self.image_noData == nil) {
            self.image_noData = [UIImage imageNamed:@"img_no_data"];
        }
        if (self.string_noData == nil) {
            self.string_noData = @"暂无数据";
        }
        [self setupBlankSlate];
    }
    
}

- (void)setupBlankSlate {
    //设置空白状态配置
    LREmptyDataSetGeneralHandler *handler = [[LREmptyDataSetGeneralHandler alloc] init];
    //设置统一的背景色（加载中、无数据、加载错误）
    //handler.backgroundColor = [UIColor whiteColor];
    [handler setBackgroundColor:[UIColor clearColor] forState:LRDataLoadStateLoading | LRDataLoadStateEmpty | LRDataLoadStateFailed];
    
    handler.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    handler.titleColor = UIColorFromRGB(0x999999);
    handler.touchable = YES;
    handler.descriptionFont = [UIFont systemFontOfSize:14];
    handler.descriptionColor = [UIColor lightGrayColor];
    handler.buttonTitleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    handler.buttonTitleColor = UIColorFromRGB(0x3381FF);
    
    
    
    //加载状态配置
    [handler setTitle:@"加载中..." forState:LRDataLoadStateLoading];
    [handler setImage:[UIImage imageNamed:@"icon_loading"] forState:LRDataLoadStateLoading];
    [handler setImageAnimation:({
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform"];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0)];
        animation.duration = 0.35;
        animation.cumulative = YES;
        animation.repeatCount = MAXFLOAT;
        animation.removedOnCompletion = NO;
        animation;
    }) forState:LRDataLoadStateLoading];
    [handler setAnimate:YES forState:LRDataLoadStateLoading];
    [handler setScrollable:NO forState:LRDataLoadStateLoading];
    
    //无数据状态配置
    
    //[handler setDescription:@"糟糕！这里什么都没有~" forState:LRDataLoadStateEmpty];
    [handler setTitle:self.string_noData forState:LRDataLoadStateEmpty];
    [handler setImage:self.image_noData forState:LRDataLoadStateEmpty];
    
//    if (self.isNeedNoDataReload) {
//        [handler setButtonTitle:@"刷新数据" controlState:UIControlStateNormal forState:LRDataLoadStateEmpty];
//    }
    
//    UIEdgeInsets capInsets = UIEdgeInsetsMake(25.0, 25.0, 25.0, 25.0);
//    UIEdgeInsets rectInsets = UIEdgeInsetsZero;
//    UIImage *bgImage = [UIImage imageNamed:@"button_loadingError"];
//    bgImage = [[bgImage resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
//    [handler setImage:bgImage controlState:UIControlStateNormal forState:LRDataLoadStateEmpty];
//    [handler setImage:bgImage controlState:UIControlStateHighlighted forState:LRDataLoadStateFailed];
    [handler setSpaceHeight:12 forState:LRDataLoadStateEmpty];
    [handler setVerticalOffset:-50 forState:LRDataLoadStateEmpty];
    //点击按钮回调
    [handler setTapButtonHandler:^(UIButton *button) {
        if (self.collectionViewPlaceholderBlock) {
            self.collectionViewPlaceholderBlock();
        }
    } forState:LRDataLoadStateEmpty];
    [handler setScrollable:YES forState:LRDataLoadStateEmpty];
    
    
    //加载错误状态配置
    [handler setTitle:@"网络好像出了点问题..." forState:LRDataLoadStateFailed];
    [handler setImage:[UIImage imageNamed:@"img_network_error"] forState:LRDataLoadStateFailed];
//    [handler setImage:[UIImage imageNamed:@"icon_loadingError"] forState:LRDataLoadStateFailed];
//    [handler setAttributedDescription:({
//        //设置指定文字样式
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"连接错误!"];
//        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, string.length)];
//        [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(0, string.length)];
//
//        string;
//    }) forState:LRDataLoadStateFailed];
    [handler setButtonTitle:@"刷新重试" controlState:UIControlStateNormal forState:LRDataLoadStateFailed];
//    bgImage = [[bgImage resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
//    [handler setButtonBackgroundImage:bgImage controlState:UIControlStateNormal forState:LRDataLoadStateFailed];
//    [handler setButtonBackgroundImage:bgImage controlState:UIControlStateHighlighted forState:LRDataLoadStateFailed];
    [handler setSpaceHeight:12 forState:LRDataLoadStateFailed];
    [handler setVerticalOffset:-50 forState:LRDataLoadStateFailed];
    //点击按钮回调
    [handler setTapButtonHandler:^(UIButton *button) {
        if (self.collectionViewPlaceholderBlock) {
            self.collectionViewPlaceholderBlock();
        }
    } forState:LRDataLoadStateFailed];
    [handler setScrollable:NO forState:LRDataLoadStateFailed];
    //禁止滚动
    //handler.scrollable = NO;
    
    self.lr_handler = handler;
}



#pragma mark - public methods

/** 开始刷新动画 */
- (void)beginRefresh{
    if (self.mj_header) [self.mj_header beginRefreshing];
}

/** 停止刷新动画 */
- (void)endingRefresh{
    if (self.mj_header&&self.mj_header.state == MJRefreshStateRefreshing) [self.mj_header endRefreshing];
}

/** 开始加载更多动画 */
- (void)beginLoadMore{
    if (self.mj_footer) [self.mj_footer beginRefreshing];
}

/** 停止加载更多动画 */
- (void)endingLoadMore{
    if (self.mj_footer&&self.mj_footer.state == MJRefreshStateRefreshing) [self.mj_footer endRefreshing];
}

/** 停止加载更多动画，并提示没有更多内容 */
- (void)endingNoMoreData{
    if (self.mj_footer&&(self.mj_footer.state == MJRefreshStateRefreshing || self.mj_footer.state == MJRefreshStateIdle)) [self.mj_footer endRefreshingWithNoMoreData];
}

/** 重新设置没有更多内容 */
- (void)resetNoMoreData{
    if (self.mj_footer&&self.mj_footer.state == MJRefreshStateNoMoreData) [self.mj_footer resetNoMoreData];
}




- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_HAVENETWORK_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_NONETWORK_SUCCESS object:nil];
    
    
    //LLog(@"LRBaseTableView dealloc");
}

@end
