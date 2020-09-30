//
//  VideoAddListVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/29.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "VideoAddListVC.h"
#import "LRBaseCollectionView.h"
#import "UserModel.h"
#import "VideoListCell.h"
#import "VideoDetailVC.h"
#import "VideoColectVC.h"

@interface VideoAddListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) VideoAddListViewModel * viewModel;

@property (weak, nonatomic) IBOutlet LRBaseCollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet UIView *v_search;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_viewSearch_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_viewSearch_top;

@property (weak, nonatomic) IBOutlet UIButton *btn_illegalAdd;


@end

@implementation VideoAddListVC

- (instancetype)initWithViewModel:(VideoAddListViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return  self;
}


- (void)lr_configUI{
    
    @weakify(self);
    
    self.collectionView.autoNetworkNotice = YES;
    self.collectionView.isHavePlaceholder = YES;
    
    
    self.collectionView.collectionViewPlaceholderBlock = ^{
        @strongify(self);
        
        if (self.viewModel.arr_content.count > 0) {
            [self.viewModel.arr_content removeAllObjects];
            [self.collectionView reloadData];
        }
        
        self.collectionView.lr_handler.state = LRDataLoadStateLoading;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              @strongify(self);
              [self reloadData];
        });
    };
    
    self.collectionView.collectionViewHeaderRefresh = ^{
        @strongify(self);
        [self reloadData];
        
    };
    
    self.collectionView.collectionViewFooterLoadMore = ^{
        @strongify(self);
        [self loadData];
        
    };
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoListCell" bundle:nil] forCellWithReuseIdentifier:@"VideoListCellID"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    

    if (self.viewModel.type == 1) {
        
        @weakify(self);
        [self zx_setRightBtnWithImgName:@"btn_search" clickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
            @strongify(self);
            
            if ([UserModel isPermissionForVideoCollectList] == NO) {
                [LRShowHUD showError:@"请联系管理员授权" duration:1.5f];
                return;
            }
            
            
            [self handleBtnSearchClicked:nil];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoSuccess:) name:NOTIFICATION_VIDEO_SUCCESS object:nil];
        
        _v_search.hidden = YES;
        _layout_viewSearch_height.constant = 0;
        
        self.btn_illegalAdd.hidden = NO;
        
    }else if(self.viewModel.type == 2){
        
        self.zx_hideBaseNavBar = YES;
        if (IS_IPHONE_X_MORE){
            _layout_viewSearch_height.constant = _layout_viewSearch_height.constant + 24 ;
            
        }
        
        _layout_viewSearch_top.constant = - Height_StatusBar;
    
        self.btn_illegalAdd.hidden = YES;
        
    }
    
    
}

- (void)lr_bindViewModel{
    
    
    @weakify(self);
    

    [self.viewModel.command_list.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        [self.collectionView endingRefresh];
        [self.collectionView endingLoadMore];
        
        if ([x isEqualToString:@"请求最后一条成功"]) {
            [self.collectionView endingNoMoreData];
            if (self.viewModel.arr_content.count == 0) {
                self.collectionView.lr_handler.state = LRDataLoadStateEmpty;
            }
        }else if([x isEqualToString:@"加载成功"]){
            if (self.viewModel.arr_content.count == 0) {
                self.collectionView.lr_handler.state = LRDataLoadStateEmpty;
            }else{
                self.collectionView.lr_handler.state = LRDataLoadStateIdle;
            }
            
        }else if([x isEqualToString:@"加载失败"]){
        
            if (self.viewModel.arr_content.count == 0) {
                self.collectionView.lr_handler.state = LRDataLoadStateFailed;
            }
        }
        
        [self.collectionView reloadData];
        
    }];
    
#pragma mark - 权限判断
    if (self.viewModel.type == 1) {
        
        if ([UserModel isPermissionForVideoCollectList]) {
            [self loadDataForStart];
        }else{
            [self loadDataForEmpty];
        }
        
    }else{
        
        if (self.viewModel.arr_content.count > 0) {
            [self.viewModel.arr_content removeAllObjects];
            [self.collectionView reloadData];
        }
        self.collectionView.enableRefresh = NO;
        self.collectionView.enableLoadMore = NO;
        self.collectionView.lr_handler.state = LRDataLoadStateEmpty;
        [self.collectionView reloadData];
        
    }
    
}

#pragma mark - 开始加载数据

- (void)loadDataForStart{
    @weakify(self);
    if (self.viewModel.arr_content.count > 0) {
        [self.viewModel.arr_content removeAllObjects];
        [self.collectionView reloadData];
    }
    self.collectionView.enableRefresh = YES;
    self.collectionView.enableLoadMore = YES;
    [self.collectionView resetNoMoreData];
    self.collectionView.lr_handler.state = LRDataLoadStateLoading;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self reloadData];
    });
    
}


#pragma mark - 配置不能加载数据

- (void)loadDataForEmpty{
    
    //[ShareFun showTipLable:@"请联系管理员授权"];
    
    if (self.viewModel.arr_content.count > 0) {
        [self.viewModel.arr_content removeAllObjects];
        [self.collectionView reloadData];
    }
    self.collectionView.enableRefresh = NO;
    self.collectionView.enableLoadMore = NO;
    self.collectionView.lr_handler.state = LRDataLoadStateEmpty;
    [self.collectionView reloadData];
    
}


#pragma mark - 加载新数据

- (void)reloadData{
    
    self.viewModel.index= 0;
    [self.collectionView resetNoMoreData];
    [self.viewModel.command_list execute:nil];
    
}

- (void)loadData{
    [self.viewModel.command_list execute:nil];
}

#pragma mark - UICollectionView Data Source

//返回多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView   *)collectionView
{
    return 1;
}
//返回每组多少个视图
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.viewModel.arr_content.count;
}
//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoListCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoListCellID" forIndexPath:indexPath];
    
    if (self.viewModel.arr_content && self.viewModel.arr_content.count > 0) {
        VideoColectListModel *model = self.viewModel.arr_content[indexPath.row];
        cell.model = model;
    }
    
    return cell;
}

#pragma mark - UICollectionView Delegate method

//选中某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LxPrintf(@"选中 : %ld--%ld",(long)indexPath.section,(long)indexPath.item);
    
    if (self.viewModel.arr_content && self.viewModel.arr_content.count > 0) {
        
        VideoColectListModel *model = self.viewModel.arr_content[indexPath.row];
        VideoDetailVC * t_vc = [[VideoDetailVC alloc] init];
        t_vc.path = model.path;
        [self.navigationController pushViewController:t_vc animated:YES];
    }
    
}

//取消某个 item 触发
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LxPrintf(@"取消选中 : %ld--%ld",(long)indexPath.section,(long)indexPath.item);
}


#pragma mark - UICollectionView Delegate FlowLayout

// cell 尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width=(self.view.bounds.size.width-6)/2;
    return CGSizeMake(width, 153);
}

// 装载内容 cell 的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

//item最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}


#pragma mark - buttonAction

- (IBAction)handleBtnSearchClicked:(id)sender {
    
    VideoAddListViewModel * viewModel = [[VideoAddListViewModel alloc] init];
    viewModel.type = 2;
    VideoAddListVC *vc = [[VideoAddListVC alloc] initWithViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(IBAction)handleBtnBackClicked:(id)sender{
    
    if (self.navigationController.viewControllers.count == 1) {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (IBAction)handleIllegalAdd:(id)sender {
    
    VideoColectVC *t_vc = [[VideoColectVC alloc] init];
    NSRange range = [self.title rangeOfString:@"列表"];
    NSLog(@"rang:%@",NSStringFromRange(range));
    t_vc.title =  [self.title substringToIndex:range.location];
    [self.navigationController pushViewController:t_vc animated:YES];

}

#pragma mark - UItextFieldDelegate

- (IBAction)handleBtnSearch:(id)sender {
    
    [self.tf_search resignFirstResponder];
     self.viewModel.str_search = self.tf_search.text;
    if (self.viewModel.str_search.length == 0) {
        [LRShowHUD showError:@"请输入搜索内容" duration:1.5f];
    }
    self.collectionView.enableRefresh = YES;
    self.collectionView.enableLoadMore = YES;
    [self.collectionView beginRefresh];
    
}


#pragma mark -notification

- (void)videoSuccess:(NSNotification *)notification{
    [self.collectionView beginRefresh];
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_VIDEO_SUCCESS object:nil];
    LxPrintf(@"VideoListVC dealloc");
    
}

@end
