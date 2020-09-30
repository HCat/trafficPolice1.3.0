//
//  PoliceHistorySearchVC.m
//  移动采集
//
//  Created by hcat on 2018/11/21.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "PoliceHistorySearchVC.h"
#import "TTGTextTagCollectionView.h"
#import "SearchTagHelper.h"
#import <PureLayout.h>
#import "PoliceSearchVC.h"

@interface PoliceHistorySearchVC ()

@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UIButton *btn_search;

@property (weak, nonatomic) IBOutlet UIView *v_history;
@property (weak, nonatomic) IBOutlet UIButton *btn_delHistory;
@property (weak, nonatomic) IBOutlet UILabel *lb_historyTip;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_historyHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_topHeight;


@property (nonatomic, strong) TTGTextTagCollectionView *tagView;

@property (nonatomic,strong) NSArray *arr_tags;         //获取搜索tag

@end

@implementation PoliceHistorySearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
    @weakify(self);
    [RACObserve(self, arr_tags) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.arr_tags && self.arr_tags.count > 0) {
            self.lb_historyTip.hidden  = YES;
        }else{
            self.lb_historyTip.hidden = NO;
        }
    }];
    
    //删除历史记录按钮
    [[self.btn_delHistory rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [SearchTagHelper removeAllArray];
        [self tagViewReloadTag];
    }];
    
    //取消按钮
    [[self.btn_cancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
    //搜索按钮
    [[self.btn_search rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        PoliceSearchViewModel * viewModel = [[PoliceSearchViewModel alloc] init];
        PoliceSearchVC * t_vc = [[PoliceSearchVC alloc] initWithViewModel:viewModel];
        [self.navigationController pushViewController:t_vc animated:YES];
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self tagViewReloadTag];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
    
}


#pragma mark - configUI

- (void)configUI{
    
    self.zx_hideBaseNavBar = YES;
    
    _layout_historyHeight.constant = Height_NavBar;
    
    if (IS_IPHONE_X_MORE){
        _layout_topHeight.constant = _layout_topHeight.constant + 24;
    }
    
    _tagView = [TTGTextTagCollectionView new];
    //_tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    
    TTGTextTagConfig *config = [TTGTextTagConfig new];
    config.tagTextFont = [UIFont systemFontOfSize:14];
    
    config.tagTextColor = UIColorFromRGB(0x787878);
    config.tagBackgroundColor = UIColorFromRGB(0xe6e6e6);
    config.tagSelectedTextColor = UIColorFromRGB(0x787878);
    config.tagSelectedBackgroundColor = UIColorFromRGB(0xe6e6e6);
    config.tagCornerRadius = 5.f;
    config.tagSelectedCornerRadius = 5.f;
    config.tagBorderWidth = 0.f;
    config.tagBorderColor = [UIColor clearColor];
    config.tagSelectedBorderWidth = 0.f;
    config.tagSelectedBorderColor = [UIColor clearColor];
    
    config.tagShadowColor = [UIColor clearColor];
    
    
    _tagView.defaultConfig = config;
    
    [_tagView configureForAutoLayout];
    [_v_history addSubview:_tagView];
    
    [_tagView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(50, 10, 10, 10)];
    
    [_tagView setDelegate:(id<TTGTextTagCollectionViewDelegate>)self];
    
    //_tagView.showsVerticalScrollIndicator = NO;
    
    [self.view layoutIfNeeded];
    
}

#pragma mark - 历史记录标签刷新

- (void)tagViewReloadTag{
    
    self.arr_tags = [SearchTagHelper readTagArray] ;
    if (self.arr_tags == nil) {
        self.arr_tags = [NSArray array];
    }
    
    [_tagView removeAllTags];
    if (_arr_tags && _arr_tags.count > 0) {
        [_tagView addTags:_arr_tags];
    }
    
    [_tagView reload];
    
    
}

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected {
    
    LxPrintf(@"Tap tag: %@, at: %ld, selected: %d", tagText, (long) index, selected);
    
    PoliceSearchViewModel * viewModel = [[PoliceSearchViewModel alloc] init];
    viewModel.keywords = tagText;
    PoliceSearchVC * t_vc = [[PoliceSearchVC alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:t_vc animated:YES];
    
    
    
    
    
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentSize:(CGSize)contentSize {
    LxPrintf(@"text tag collection: %@ new content size: %@", textTagCollectionView, NSStringFromCGSize(contentSize));
    if (_arr_tags && _arr_tags.count > 0) {
        _layout_historyHeight.constant = contentSize.height + 50 + 10;
        
        if (contentSize.height > 235) {
            _layout_historyHeight.constant = 235 + 50 + 10;
        }else{
            _layout_historyHeight.constant = contentSize.height + 50 + 10;
        }
        
    }else{
        
        _layout_historyHeight.constant = contentSize.height + 100 + 10;
    }
    
    [self.view layoutIfNeeded];
}

#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"PoliceHistorySearchVC dealloc");
    
}

@end
