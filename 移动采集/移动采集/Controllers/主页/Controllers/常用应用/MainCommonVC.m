//
//  MainCommonVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/11.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "MainCommonVC.h"
#import "MainCommonViewModel.h"
#import "MainItemCell.h"
#import "LRBaseCollectionView.h"
#import "UIWindow+JXSafeArea.h"

#import "IllegalParkVC.h"
#import "CarInfoAddVC.h"
#import "AccidentManageVC.h"
#import "VideoColectVC.h"
#import "ImportCarHomeVC.h"

#import "PoliceDistributeViewModel.h"
#import "PoliceDistributeVC.h"

#import "JointEnforceVC.h"
#import "ActionManageVC.h"
#import "AttendanceManageVC.h"
#import "SpecialVehicleVC.h"
#import "TakeOutSearchVC.h"
#import "ParkingForensicsListVC.h"
#import "IllegalExposureVC.h"
#import "DailyPatrolListVC.h"
#import "IllegalAddVC.h"
#import "ElectronicPoliceVC.h"
#import "ScreenManageVC.h"
#import "NoticeVC.h"
#import "WebVC.h"
#import "ActionVC.h"
#import "TaskFlowsContainerVC.h"

#import "MainAddMoreListVC.h"
#import "ThroughManageVC.h"
#import "IllegalCollectList.h"

#import "IllegalParkForJJVC.h"
#import "NoPressTowardVC.h"
#import "InhibitLineVC.h"
#import "LockParkVC.h"
#import "CarInfoInputVC.h"
#import "MotorbikeAddVC.h"
#import "ThroughAddVC.h"
#import "ThroughManageListVC.h"
#import "VideoAddListVC.h"
#import "VideoColectVC.h"

#import "IllegalAddListVC.h"
#import "IllegalAddForSSVC.h"

#import "ExpressRegulationVC.h"


@interface MainCommonVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property(nonatomic,strong) LRBaseCollectionView * collectionView;
@property(nonatomic,strong) MainCommonViewModel * viewModel;

@end

@implementation MainCommonVC

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.viewModel = [[MainCommonViewModel alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainCommonSave:) name:NOTIFICATION_MAINCOMMON_SUCCESS object:nil];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self lr_configUI];
    [self lr_bindViewModel];
}

- (void)lr_configUI{
    
    @weakify(self);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置item的行间距和列间距
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    // 设置item的大小
    CGFloat itemW = (SCREEN_WIDTH - 0) / 4;
    layout.itemSize = CGSizeMake(itemW, 110);
    
    // 设置每个分区的 上左下右 的内边距
    layout.sectionInset = UIEdgeInsetsMake(0, 0 ,0, 0);
    
    // 设置滚动条方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    LRBaseCollectionView *collectionView = [[LRBaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    //3、添加到控制器的view
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    //4、布局
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MainItemCell" bundle:nil] forCellWithReuseIdentifier:@"MainItemCellID"];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, UIApplication.sharedApplication.keyWindow.jx_layoutInsets.bottom, 0);
    self.collectionView.isHavePlaceholder = YES;
    self.collectionView.enableRefresh = YES;
    
    self.collectionView.collectionViewPlaceholderBlock = ^{
        @strongify(self);
        
        
        if (self.viewModel.arr_items.count > 0) {
            [self.viewModel.arr_items removeAllObjects];
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
    
    
}

- (void)lr_bindViewModel{
    
    @weakify(self);
    

    [self.viewModel.command_common.executionSignals.switchToLatest subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        [self.collectionView endingRefresh];
        
        if([x isEqualToString:@"加载成功"]){
            self.collectionView.lr_handler.state = LRDataLoadStateIdle;
            
        }else if([x isEqualToString:@"加载失败"]){
            
            self.collectionView.lr_handler.state = LRDataLoadStateFailed;
        }
        
        [self.collectionView reloadData];
        
    }];
    
    if (self.viewModel.arr_items.count > 0) {
        [self.viewModel.arr_items removeAllObjects];
        [self.collectionView reloadData];
    }
    
    self.collectionView.lr_handler.state = LRDataLoadStateLoading;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          @strongify(self);
          [self reloadData];
    });
    
}

- (void)reloadData{

    [self.viewModel.command_common execute:nil];
    
}


#pragma mark -collectionview 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;   //返回section数
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.viewModel.arr_items.count + 1;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == self.viewModel.arr_items.count) {
        
        MainItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainItemCellID" forIndexPath:indexPath];
        cell.imageV_icon.image = [UIImage imageNamed:@"menu_add"];
        cell.lb_title.text = @"添加常用";
        cell.lb_title.textColor = UIColorFromRGB(0x999999);
        cell.lb_number.hidden = YES;
        cell.lb_box.hidden = NO;
        return cell;
        
    }else{
        
        PoliceMenuListModel * model = self.viewModel.arr_items[indexPath.row];
        
        MainItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainItemCellID" forIndexPath:indexPath];
        cell.imageV_icon.image = [UIImage imageNamed:model.menuIcon];
        cell.lb_title.text = model.menuName;
        cell.lb_title.textColor = UIColorFromRGB(0x666666);
        
        cell.lb_box.hidden = YES;
        cell.lb_number.hidden = YES;
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];//取消选中
    
    if (indexPath.row == self.viewModel.arr_items.count) {
        
        MainAddMoreListVC * vc = [[MainAddMoreListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        PoliceMenuListModel * menuModel = self.viewModel.arr_items[indexPath.row];
        
        if ([menuModel.t_template isEqualToNumber:@0]) {
            
            WebVC * vc = [[WebVC alloc] init];
            vc.title = menuModel.menuName;
            vc.path = menuModel.url;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        
        if ([menuModel.menuCode isEqualToString:@"ILLEGAL_PARKING"]) {
            //menuModel.funTitle = @"违停录入";
            if ([menuModel.t_template isEqualToNumber:@1]) {
                
                IllegalCollectListViewModel * viewModel = [[IllegalCollectListViewModel alloc] init];
                viewModel.illegalType = IllegalTypePark;
                viewModel.subType = ParkTypePark;
                viewModel.type = 1;
                IllegalCollectList * t_vc = [[IllegalCollectList alloc] initWithViewModel:viewModel];
                t_vc.title = [NSString stringWithFormat:@"%@列表",menuModel.menuName];
                [self.navigationController pushViewController:t_vc animated:YES];
                
            }else if ([menuModel.t_template isEqualToNumber:@2]) {
                IllegalParkForJJVC * vc = [[IllegalParkForJJVC alloc] init];
                vc.title = menuModel.menuName;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if ([menuModel.menuCode isEqualToString:@"ILLEGAL_REVERSE_PARKING"]) {
            //menuModel.funTitle = @"不按朝向";
            if ([menuModel.t_template isEqualToNumber:@1]) {
                IllegalCollectListViewModel * viewModel = [[IllegalCollectListViewModel alloc] init];
                viewModel.illegalType = IllegalTypePark;
                viewModel.subType = ParkTypeReversePark;
                viewModel.type = 1;
                IllegalCollectList * t_vc = [[IllegalCollectList alloc] initWithViewModel:viewModel];
                t_vc.title = [NSString stringWithFormat:@"%@列表",menuModel.menuName];
                [self.navigationController pushViewController:t_vc animated:YES];
                
            }else if ([menuModel.t_template isEqualToNumber:@2]) {
                NoPressTowardVC * vc = [[NoPressTowardVC alloc] init];
                vc.title = menuModel.menuName;
                [self.navigationController pushViewController:vc animated:YES];
            
            }
            
        }else if ([menuModel.menuCode isEqualToString:@"ILLEGAL_INHIBIT_LINE"]) {
            //menuModel.funTitle = @"违反禁止线";
            
            if ([menuModel.t_template isEqualToNumber:@1]) {
                
                IllegalCollectListViewModel * viewModel = [[IllegalCollectListViewModel alloc] init];
                viewModel.illegalType = IllegalTypePark;
                viewModel.subType = ParkTypeViolationLine;
                viewModel.type = 1;
                IllegalCollectList * t_vc = [[IllegalCollectList alloc] initWithViewModel:viewModel];
                t_vc.title = [NSString stringWithFormat:@"%@列表",menuModel.menuName];
                [self.navigationController pushViewController:t_vc animated:YES];
                
            }else if ([menuModel.t_template isEqualToNumber:@2]) {
                InhibitLineVC * vc = [[InhibitLineVC alloc] init];
                vc.title = menuModel.menuName;
                [self.navigationController pushViewController:vc animated:YES];
            
            }
            
        }else if ([menuModel.menuCode isEqualToString:@"ILLEGAL_LOCK_PARKING"]) {
            //menuModel.funTitle = @"违停锁车";
            if ([menuModel.t_template isEqualToNumber:@1]) {
                
                IllegalCollectListViewModel * viewModel = [[IllegalCollectListViewModel alloc] init];
                viewModel.illegalType = IllegalTypePark;
                viewModel.subType = ParkTypeLockPark;
                viewModel.type = 1;
                IllegalCollectList * t_vc = [[IllegalCollectList alloc] initWithViewModel:viewModel];
                t_vc.title = [NSString stringWithFormat:@"%@列表",menuModel.menuName];
                [self.navigationController pushViewController:t_vc animated:YES];
                
            }else if ([menuModel.t_template isEqualToNumber:@2]) {
                LockParkVC * vc = [[LockParkVC alloc] init];
                vc.title = menuModel.menuName;
                [self.navigationController pushViewController:vc animated:YES];
            
            }
        
        }else if ([menuModel.menuCode isEqualToString:@"CAR_INFO_ADD"]) {
            //menuModel.funTitle = @"车辆录入";
            if ([menuModel.t_template isEqualToNumber:@1]) {
                
                IllegalCollectListViewModel * viewModel = [[IllegalCollectListViewModel alloc] init];
                viewModel.illegalType = IllegalTypePark;
                viewModel.subType = ParkTypeCarInfoAdd;
                viewModel.type = 1;
                IllegalCollectList * t_vc = [[IllegalCollectList alloc] initWithViewModel:viewModel];
                t_vc.title = [NSString stringWithFormat:@"%@列表",menuModel.menuName];
                [self.navigationController pushViewController:t_vc animated:YES];
                
            }else if ([menuModel.t_template isEqualToNumber:@2]) {
                CarInfoInputVC * vc = [[CarInfoInputVC alloc] init];
                vc.title = menuModel.menuName;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else if ([menuModel.menuCode isEqualToString:@"MOTOR_INFO_ADD"]) {
            //menuModel.funTitle = @"摩托车违章";
            
            if ([menuModel.t_template isEqualToNumber:@1]) {
                
                IllegalCollectListViewModel * viewModel = [[IllegalCollectListViewModel alloc] init];
                viewModel.illegalType = IllegalTypePark;
                viewModel.subType = ParkTypeMotorbikeAdd;
                viewModel.type = 1;
                IllegalCollectList * t_vc = [[IllegalCollectList alloc] initWithViewModel:viewModel];
                t_vc.title = [NSString stringWithFormat:@"%@列表",menuModel.menuName];
                [self.navigationController pushViewController:t_vc animated:YES];
                
            }else if ([menuModel.t_template isEqualToNumber:@2]) {
                MotorbikeAddVC * vc = [[MotorbikeAddVC alloc] init];
                vc.title = menuModel.menuName;
                [self.navigationController pushViewController:vc animated:YES];
            
            }
        
        }else if ([menuModel.menuCode isEqualToString:@"ILLEGAL_THROUGH"]) {
            //menuModel.funTitle = @"违反禁令";
            if ([menuModel.t_template isEqualToNumber:@1]) {
                
                IllegalCollectListViewModel * viewModel = [[IllegalCollectListViewModel alloc] init];
                viewModel.illegalType = IllegalTypeThrough;
                viewModel.subType = ParkTypeThrough;
                viewModel.type = 1;
                IllegalCollectList * t_vc = [[IllegalCollectList alloc] initWithViewModel:viewModel];
                t_vc.title = [NSString stringWithFormat:@"%@列表",menuModel.menuName];
                [self.navigationController pushViewController:t_vc animated:YES];
                
            }else if ([menuModel.t_template isEqualToNumber:@2]) {
                ThroughAddVC * vc = [[ThroughAddVC alloc] init];
                vc.title = menuModel.menuName;
                [self.navigationController pushViewController:vc animated:YES];
            
            }
            
        }else if ([menuModel.menuCode isEqualToString:@"VIDEO_COLLECT"]) {
            
            //menuModel.funTitle = @"视频录入";
            if ([menuModel.t_template isEqualToNumber:@1]) {
                
                VideoAddListViewModel * viewModel = [[VideoAddListViewModel alloc] init];
                viewModel.type = 1;
                VideoAddListVC * t_vc = [[VideoAddListVC alloc] initWithViewModel:viewModel];
                t_vc.title = [NSString stringWithFormat:@"%@列表",menuModel.menuName];
                [self.navigationController pushViewController:t_vc animated:YES];
                
            }else if ([menuModel.t_template isEqualToNumber:@2]) {
                
                VideoColectVC *t_vc = [[VideoColectVC alloc] init];
                t_vc.title = menuModel.menuName;
                [self.navigationController pushViewController:t_vc animated:YES];
            }
            
        }else if ([menuModel.menuCode isEqualToString:@"JOINT_LAW_ENFORCEMENT"]) {
            //menuModel.funTitle = @"联合执法";
           JointEnforceVC *t_vc = [[JointEnforceVC alloc] init];
           [self.navigationController pushViewController:t_vc animated:YES];
        }else if ([menuModel.menuCode isEqualToString:@"NORMAL_ACCIDENT_ADD"]) {
            //menuModel.funTitle = @"事故录入";
            AccidentManageVC *t_vc = [[AccidentManageVC alloc] init];
            t_vc.accidentType = AccidentTypeAccident;
            [self.navigationController pushViewController:t_vc animated:YES];
           
        }else if ([menuModel.menuCode isEqualToString:@"FAST_ACCIDENT_ADD"]) {
            //menuModel.funTitle = @"快处录入";
            AccidentManageVC *t_vc = [[AccidentManageVC alloc] init];
            t_vc.accidentType = AccidentTypeFastAccident;
            [self.navigationController pushViewController:t_vc animated:YES];
        }else if ([menuModel.menuCode isEqualToString:@"IMPORTANT_CAR"]) {
            //menuModel.funTitle = @"工程车辆";
            ImportCarHomeVC * t_vc = [[ImportCarHomeVC alloc] init];
            [self.navigationController pushViewController:t_vc animated:YES];
            
        }else if ([menuModel.menuCode isEqualToString:@"POLICE_COMMAND"]) {
            //menuModel.funTitle = @"警力分布";
            PoliceDistributeViewModel * viewModel = [[PoliceDistributeViewModel alloc] init];
            PoliceDistributeVC * t_vc = [[PoliceDistributeVC alloc] initWithViewModel:viewModel];
            [self.navigationController pushViewController:t_vc animated:YES];
        }else if ([menuModel.menuCode isEqualToString:@"POLICE_MANAGE"]) {
            //menuModel.funTitle = @"勤务管理";
            AttendanceManageVC *t_vc = [[AttendanceManageVC alloc] init];
            [self.navigationController pushViewController:t_vc animated:YES];
        }else if ([menuModel.menuCode isEqualToString:@"DATA_SHARE"]) {
            //menuModel.funTitle = @"资料共享";
            [ShareFun showTipLable:@"当前功能正在研发中，请耐心等待"];
        }else if ([menuModel.menuCode isEqualToString:@"ACTION_MANAGE"]) {
            //menuModel.funTitle = @"行动管理";
            ActionManageVC *t_vc = [[ActionManageVC alloc] init];
            t_vc.type = 1;
            [self.navigationController pushViewController:t_vc animated:YES];
        }else if ([menuModel.menuCode isEqualToString:@"SPECAIL_CAR_MANAGE"]) {
            //menuModel.funTitle = @"特殊车辆";
            SpecialVehicleVC *t_vc = [[SpecialVehicleVC alloc] init];
            t_vc.type = 1;
            [self.navigationController pushViewController:t_vc animated:YES];
        }else if ([menuModel.menuCode isEqualToString:@"CAR_YARD_COLLECT"]) {
            //menuModel.funTitle = @"车场管理";
            [ShareFun showTipLable:@"当前功能正在研发中，请耐心等待"];
        }else if ([menuModel.menuCode isEqualToString:@"DELVIERY_MANAGE"]) {
            //menuModel.funTitle = @"外卖监管";
            TakeOutSearchVC *t_vc = [[TakeOutSearchVC alloc] init];
            [self.navigationController pushViewController:t_vc animated:YES];
        }else if ([menuModel.menuCode isEqualToString:@"PARKING_COLLECT"]) {
            //menuModel.funTitle = @"停车取证";
            @weakify(self);
            ParkingForensicsListViewModel * viewModel = [[ParkingForensicsListViewModel alloc] init];
            
            [viewModel.command_isRegister.executionSignals.switchToLatest subscribeNext:^(id _Nullable x) {
                @strongify(self);
                
                if ([x isKindOfClass:[NSNumber class]]) {
                    
                    if ([x intValue] == 0 || [x intValue] == 2) {
                       [ShareFun showTipLable:@"您暂无权限使用本功能"];
                    }else {
                        ParkingForensicsListVC *t_vc = [[ParkingForensicsListVC alloc] initWithViewModel:viewModel];
                        [self.navigationController pushViewController:t_vc animated:YES];
                    }
                    
                }else{
                    [ShareFun showTipLable:@"未知错误,技术人员正在修复,请稍后再试."];
                }
                
            }];
            
            [viewModel.command_isRegister execute:nil];
            
        }else if ([menuModel.menuCode isEqualToString:@"ILLEGAL_EXPOSURE"]) {
            //menuModel.funTitle = @"违法曝光";
            IllegalExposureVC *t_vc = [[IllegalExposureVC alloc] init];
            [self.navigationController pushViewController:t_vc animated:YES];
        }else if ([menuModel.menuCode isEqualToString:@"PATROL_MANAGE"]) {
            //menuModel.funTitle = @"日常巡逻";
            DailyPatrolListVC *t_vc = [[DailyPatrolListVC alloc] init];
            [self.navigationController pushViewController:t_vc animated:YES];
        }else if ([menuModel.menuCode isEqualToString:@"ILLEGAL_PARK_COLLECT"]) {
            //menuModel.funTitle = @"违停采集";
            
            if ([menuModel.t_template isEqualToNumber:@1]) {
                
                IllegalAddListVC * vc = [[IllegalAddListVC alloc] init];
                vc.title = [NSString stringWithFormat:@"%@列表",menuModel.menuName];
                [self.navigationController pushViewController:vc animated:YES];
                

            }else if ([menuModel.t_template isEqualToNumber:@2]) {
                IllegalAddForSSVC * vc = [[IllegalAddForSSVC alloc] init];
                vc.title = menuModel.menuName;
                [self.navigationController pushViewController:vc animated:YES];
            
            }
            
            
            IllegalAddVC *t_vc = [[IllegalAddVC alloc] init];
            [self.navigationController pushViewController:t_vc animated:YES];
        }else if ([menuModel.menuCode isEqualToString:@"ELE_POLICE_MANAGE"]) {
            //menuModel.funTitle = @"电子警察";
            ElectronicPoliceVC *t_vc = [[ElectronicPoliceVC alloc] init];
            [self.navigationController pushViewController:t_vc animated:YES];
        }else if ([menuModel.menuCode isEqualToString:@"BOOKING_RECEIVE"]) {
            //menuModel.funTitle = @"综合屏管理";
            ScreenManageVC *t_vc = [[ScreenManageVC alloc] init];
            [self.navigationController pushViewController:t_vc animated:YES];
        }else if ([menuModel.menuCode isEqualToString:@"NOTICE_MANAGE"]) {
            //menuModel.funTitle = @"公告";
            NoticeVC *t_vc = [[NoticeVC alloc] init];
            [self.navigationController pushViewController:t_vc animated:YES];
            
        }else if ([menuModel.menuCode isEqualToString:@"TASK_MANAGE"]) {
            //menuModel.funTitle = @"任务";
           
            TaskFlowsContainerVC * vc = [[TaskFlowsContainerVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else if ([menuModel.menuCode isEqualToString:@"ACTION_MANGE"]) {
            //menuModel.funTitle = @"行动";
            ActionVC * vc = [[ActionVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([menuModel.menuCode isEqualToString:@"THROUGH_MANAGE"]) {
            //menuModel.funTitle = @"闯禁令管理";
            
            if ([menuModel.t_template isEqualToNumber:@1]) {
                
                ThroughManageListViewModel * viewModel = [[ThroughManageListViewModel alloc] init];
                viewModel.type = 1;
                ThroughManageListVC * t_vc = [[ThroughManageListVC alloc] initWithViewModel:viewModel];
                t_vc.title = [NSString stringWithFormat:@"%@列表",menuModel.menuName];
                [self.navigationController pushViewController:t_vc animated:YES];
                
            }else if ([menuModel.t_template isEqualToNumber:@2]) {
                
                ThroughManageVC * vc = [[ThroughManageVC alloc] init];
                vc.title = menuModel.menuName;
                [self.navigationController pushViewController:vc animated:YES];
            
            }
            
        }else if ([menuModel.menuCode isEqualToString:@"LOGISTICS_MANAGE"]) {
            //menuModel.funTitle = @"快递监管管理";
            ExpressRegulationVC * vc = [[ExpressRegulationVC alloc] init];
            vc.title = menuModel.menuName;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
    }
    
    

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}


#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listWillAppear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

- (void)listDidAppear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

- (void)listWillDisappear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}

- (void)listDidDisappear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
}


#pragma mark - notification

- (void)mainCommonSave:(NSNotification *)notification{

    [self.collectionView beginRefresh];
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_MAINCOMMON_SUCCESS object:nil];
    
}


@end
