//
//  MainHomeVC.m
//  移动采集
//
//  Created by hcat on 2017/7/18.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "MainHomeVC.h"
#import "BaseImageCollectionCell.h"
#import "UserModel.h"

//#import "IllegalParkManageVC.h"
//#import "IllegalParkManageViewModel.h"
//#import "AccidentVC.h"
//#import "AccidentViewModel.h"


#import "IllegalParkVC.h"
#import "CarInfoAddVC.h"
#import "AccidentManageVC.h"

#import "VideoColectVC.h"
#import "SignInVC.h"
#import "ImportCarHomeVC.h"

#import "PoliceDistributeViewModel.h"
#import "PoliceDistributeVC.h"

#import "PoliceCommandVC.h"
#import "JointEnforceVC.h"
#import "ActionManageVC.h"
#import "SpecialVehicleVC.h"
#import "NoticeVC.h"
#import "AttendanceManageVC.h"
#import "TakeOutSearchVC.h"

#import "MainCellLayout.h"
#import "MainHomeViewModel.h"
#import "MainAllFunctionVC.h"

@interface MainHomeVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (weak, nonatomic) IBOutlet UILabel *lb_departmentName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_topHeight;

@property (weak, nonatomic) IBOutlet UIView *v_notice;
@property (weak, nonatomic) IBOutlet UILabel *lb_notice;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_top_colectionVIew;

@property (assign, nonatomic) long section;

@property (nonatomic,strong) MainHomeViewModel * viewModel;


@end

@implementation MainHomeVC

static NSString *const cellId = @"BaseImageCollectionCell";

- (instancetype)init{
    
    if (self = [super init]) {
        self.viewModel = [[MainHomeViewModel alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lb_departmentName.text = [ShareFun takeStringNoNull:[UserModel getUserModel].departmentName];
    
    if (IS_IPHONE_X_MORE) {
        _layout_topHeight.constant = _layout_topHeight.constant + 24;
    }
    
    [_collectionView registerClass:[BaseImageCollectionCell class] forCellWithReuseIdentifier:cellId];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mainCollectHeader"];
     [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"mainFootView"];
   
    MainCellLayout *layout=[[MainCellLayout alloc] init];
    [_collectionView setCollectionViewLayout:layout];
    
   

    _v_notice.hidden = YES;
    
    [self bindViewModel];
    
    [self.viewModel.command_requestNotice execute:nil];
    [self.viewModel.command_requestMenu execute:nil];
    
}

- (void)bindViewModel{
    @weakify(self);
    
//    [RACObserve([UserModel getUserModel], departmentName) subscribeNext:^(NSString * _Nullable x) {
//        @strongify(self);
//        if (x && x.length > 0) {
//            NSLog(@"%@",[UserModel getUserModel].departmentName);
//            self.lb_departmentName.text = x;
//        }
//        
//    }];
    
    [self.viewModel.command_requestNotice.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        if ([x isKindOfClass:[RACTuple class]]) {
            RACTupleUnpack(NSNumber * swicth,NSString * content) = x;
            
            if ([swicth isEqualToNumber:@1]) {
                self.v_notice.hidden = NO;
                self.lb_notice.text = content;
                self.layout_top_colectionVIew.constant = 74;
                [self.view setNeedsLayout];
            }else{
                self.v_notice.hidden = YES;
            }
            
        }
        
    }];
    
    [self.viewModel.command_requestMenu.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        [self.collectionView reloadData];

    }];
    
}


#pragma mark - ButtonAction

- (IBAction)handleBtnSignInClicked:(id)sender {
    
    SignInVC *t_vc = [[SignInVC alloc] init];
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

- (IBAction)handleBtnNoticeClicked:(id)sender {
    
    NoticeVC *t_vc = [[NoticeVC alloc] init];
    t_vc.content = _lb_notice.text;
    [self.navigationController pushViewController:t_vc animated:YES];
}



#pragma mark - UICollectionView Data Source

//返回多少个组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView   *)collectionView{
    
    NSInteger section = 0;
    
    if (self.viewModel.arr_illegal && self.viewModel.arr_illegal.count > 0) {
        
        NSMutableArray * t_arr = @[].mutableCopy;
        
        for (CommonMenuModel * menuModel in self.viewModel.arr_illegal) {
            if ([menuModel.isOrg isEqualToNumber:@1]) {
                [t_arr addObject:menuModel];
            }
            
        }
    
        if (t_arr && t_arr.count > 0) {
            section += 1;
        }
        
    }
    if (self.viewModel.arr_accident && self.viewModel.arr_accident.count > 0){
        NSMutableArray * t_arr = @[].mutableCopy;
        
        for (CommonMenuModel * menuModel in self.viewModel.arr_accident) {
            if ([menuModel.isOrg isEqualToNumber:@1]) {
                [t_arr addObject:menuModel];
            }
            
        }
        
        if (t_arr && t_arr.count > 0) {
            section += 1;
        }
    }
    
    if (self.viewModel.arr_policeMatter && self.viewModel.arr_policeMatter.count > 0){
        NSMutableArray * t_arr = @[].mutableCopy;
        for (CommonMenuModel * menuModel in self.viewModel.arr_policeMatter) {
            if ([menuModel.isOrg isEqualToNumber:@1]) {
                [t_arr addObject:menuModel];
            }
            
        }
        
        if (t_arr && t_arr.count > 0) {
            section += 1;
        }
    }
    
    self.section = section;
    
    return section;
}

//返回每组多少个视图
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSMutableArray *t_arr = [self.viewModel arrayFromSection:section];
    if (t_arr) {
        return t_arr.count;
    }
    
    return 0;
}

//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *t_arr = [self.viewModel arrayFromSection:indexPath.section];
    
    if (t_arr) {
        BaseImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
        
        cell.isNeedTitle = YES;
        cell.imageView.contentMode = UIViewContentModeCenter;
        cell.layer.cornerRadius = 0.0f;
        cell.lb_title.textColor = DefaultTextColor;
        if (SCREEN_WIDTH > 320) {
            cell.layout_imageWithLb.constant = -15;
        }else{
            cell.layout_imageWithLb.constant = -10;
        }
        
        [cell layoutIfNeeded];
        
        CommonMenuModel * menuModel  = [t_arr objectAtIndex:indexPath.row];
        
        
        cell.imageView.image = [UIImage imageNamed:menuModel.funImage];
        cell.lb_title.text = menuModel.funTitle;
        
        return cell;
    }
   
    return nil;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *t_title = nil;
    if (indexPath.section == 0) {
        if (self.viewModel.arr_illegal && self.viewModel.arr_illegal.count > 0) {
            t_title = @"违法采集";
        }else if (self.viewModel.arr_accident && self.viewModel.arr_accident.count > 0){
            t_title = @"事故纠纷";
        }else if (self.viewModel.arr_policeMatter && self.viewModel.arr_policeMatter.count > 0){
            t_title = @"警务管理";
        }
        
    }else if (indexPath.section == 1){
        if (self.viewModel.arr_accident && self.viewModel.arr_accident.count > 0){
            t_title = @"事故纠纷";
        }else if (self.viewModel.arr_policeMatter && self.viewModel.arr_policeMatter.count > 0){
            t_title = @"警务管理";
        }
        
    }else if (indexPath.section == 2){
        if (self.viewModel.arr_policeMatter && self.viewModel.arr_policeMatter.count > 0){
            t_title = @"警务管理";
        }
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mainCollectHeader" forIndexPath:indexPath];
        headerView.backgroundColor =[UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 0, headerView.bounds.size.width - 15.f, headerView.bounds.size.height)];
        label.text = t_title;
        label.textColor = DefaultTextColor;
        label.font = [UIFont boldSystemFontOfSize:17.f];
        [headerView addSubview:label];
        
        return headerView;
    } else {
        
        if (indexPath.section == self.section - 1) {
            UICollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"mainFootView" forIndexPath:indexPath];
            footView.backgroundColor = [UIColor clearColor];
            
            UIButton * button  = [UIButton new];
            
            [button setTitle:@"+查看全部功能" forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x3399FF) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14.f];
            button.layer.borderWidth = 1.f;
            button.layer.cornerRadius = 5.f;
            button.layer.borderColor = UIColorFromRGB(0x3399FF).CGColor;
            [button setBackgroundColor:UIColorFromRGB(0xEBF5FF)];
            @weakify(self);
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                MainAllFunctionVC * vc = [[MainAllFunctionVC alloc] init];
                vc.arr_illegal = self.viewModel.arr_illegal;
                vc.arr_accident = self.viewModel.arr_accident;
                vc.arr_policeMatter = self.viewModel.arr_policeMatter;
                [self.navigationController pushViewController:vc animated:YES];
                
            }];
            [footView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@120.);
                make.height.equalTo(@38.);
                make.centerX.mas_equalTo(footView.mas_centerX);
                make.centerY.mas_equalTo(footView.mas_centerY);
            }];
            
            return footView;
        }
        
        return nil;
        
    }
    
}



//选中时的操作
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSMutableArray * t_arr = [self.viewModel arrayFromSection:indexPath.section];
    
    if (t_arr) {
        
        CommonMenuModel * menuModel = [t_arr objectAtIndex:indexPath.row];

        NSString *t_title = menuModel.funTitle;
        
        if ([t_title isEqualToString:@"违停录入"]) {
            
            if ([menuModel.isUser isEqualToNumber:@1]) {
                
//                IllegalParkManageViewModel *viewModel = [[IllegalParkManageViewModel alloc] init];
//                viewModel.illegalType = IllegalTypePark;
//                viewModel.subType = ParkTypePark;
//                viewModel.illegalCount = @5;
//                IllegalParkManageVC * t_vc = [[IllegalParkManageVC alloc] initWithViewModel:viewModel];
                
                IllegalParkVC *t_vc = [[IllegalParkVC alloc] init];
                t_vc.illegalType = IllegalTypePark;
                t_vc.subType = ParkTypePark;

                [self.navigationController pushViewController:t_vc animated:YES];
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }
            
        }else if ([t_title isEqualToString:@"不按朝向"]) {
            
            if ([menuModel.isUser isEqualToNumber:@1]) {
                
//                IllegalParkManageViewModel *viewModel = [[IllegalParkManageViewModel alloc] init];
//                viewModel.illegalType = IllegalTypePark;
//                viewModel.subType = ParkTypeReversePark;
//                IllegalParkManageVC * t_vc = [[IllegalParkManageVC alloc] initWithViewModel:viewModel];
                IllegalParkVC *t_vc = [[IllegalParkVC alloc] init];
                t_vc.illegalType = IllegalTypePark;
                t_vc.subType = ParkTypeReversePark;
                [self.navigationController pushViewController:t_vc animated:YES];
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }
 
        }else if ([t_title isEqualToString:@"违停锁车"]) {
            
            if ([menuModel.isUser isEqualToNumber:@1]) {
                //                IllegalParkManageViewModel *viewModel = [[IllegalParkManageViewModel alloc] init];
                //                viewModel.illegalType = IllegalTypePark;
                //                viewModel.subType = ParkTypeLockPark;
                //                IllegalParkManageVC * t_vc = [[IllegalParkManageVC alloc] initWithViewModel:viewModel];
                IllegalParkVC *t_vc = [[IllegalParkVC alloc] init];
                t_vc.illegalType = IllegalTypePark;
                t_vc.subType = ParkTypeLockPark;
                [self.navigationController pushViewController:t_vc animated:YES];
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }
            
        }else if ([t_title isEqualToString:@"违反禁止线"]) {
            
            if ([menuModel.isUser isEqualToNumber:@1]) {
                //                IllegalParkManageViewModel *viewModel = [[IllegalParkManageViewModel alloc] init];
                //                viewModel.illegalType = IllegalTypePark;
                //                viewModel.subType = ParkTypeCarInfoAdd;
                //                IllegalParkManageVC * t_vc = [[IllegalParkManageVC alloc] initWithViewModel:viewModel];
                IllegalParkVC *t_vc = [[IllegalParkVC alloc] init];
                t_vc.illegalType = IllegalTypePark;
                t_vc.subType = ParkTypeViolationLine;
                [self.navigationController pushViewController:t_vc animated:YES];
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }
            
        }else if ([t_title isEqualToString:@"车辆录入"]) {
            
            if ([menuModel.isUser isEqualToNumber:@1]) {
//                IllegalParkManageViewModel *viewModel = [[IllegalParkManageViewModel alloc] init];
//                viewModel.illegalType = IllegalTypePark;
//                viewModel.subType = ParkTypeCarInfoAdd;
//                IllegalParkManageVC * t_vc = [[IllegalParkManageVC alloc] initWithViewModel:viewModel];
                CarInfoAddVC *t_vc = [[CarInfoAddVC alloc] init];
                t_vc.type = ParkTypeCarInfoAdd;
                [self.navigationController pushViewController:t_vc animated:YES];
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }
 
        }else if ([t_title isEqualToString:@"摩托车违章"]) {
            
            if ([menuModel.isUser isEqualToNumber:@1]) {
                //                IllegalParkManageViewModel *viewModel = [[IllegalParkManageViewModel alloc] init];
                //                viewModel.illegalType = IllegalTypePark;
                //                viewModel.subType = ParkTypeCarInfoAdd;
                //                IllegalParkManageVC * t_vc = [[IllegalParkManageVC alloc] initWithViewModel:viewModel];
                CarInfoAddVC *t_vc = [[CarInfoAddVC alloc] init];
                t_vc.type = ParkTypeMotorbikeAdd;
                [self.navigationController pushViewController:t_vc animated:YES];
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }
            
        }else if ([t_title isEqualToString:@"违反禁令"]){
            
            if ([menuModel.isUser isEqualToNumber:@1]) {
//                IllegalParkManageViewModel *viewModel = [[IllegalParkManageViewModel alloc] init];
//                viewModel.illegalType = IllegalTypeThrough;
//                viewModel.subType = ParkTypeThrough;
//                IllegalParkManageVC * t_vc = [[IllegalParkManageVC alloc] initWithViewModel:viewModel];
                IllegalParkVC *t_vc = [[IllegalParkVC alloc] init];
                t_vc.illegalType = IllegalTypeThrough;
                [self.navigationController pushViewController:t_vc animated:YES];
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }

        }else if ([t_title isEqualToString:@"事故录入"]){

            if ([menuModel.isUser isEqualToNumber:@1]) {
                
//                AccidentViewModel *viewModel = [[AccidentViewModel alloc] init];
//                viewModel.accidentType = AccidentTypeAccident;
//                AccidentVC * t_vc = [[AccidentVC alloc] initWithViewModel:viewModel];
                AccidentManageVC *t_vc = [[AccidentManageVC alloc] init];
                t_vc.accidentType = AccidentTypeAccident;

                [self.navigationController pushViewController:t_vc animated:YES];
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }

        }else if ([t_title isEqualToString:@"快处录入"]){

            if ([menuModel.isUser isEqualToNumber:@1]) {
//                AccidentViewModel *viewModel = [[AccidentViewModel alloc] init];
//                viewModel.accidentType = AccidentTypeFastAccident;
//                AccidentVC * t_vc = [[AccidentVC alloc] initWithViewModel:viewModel];
                AccidentManageVC *t_vc = [[AccidentManageVC alloc] init];
                t_vc.accidentType = AccidentTypeFastAccident;
                [self.navigationController pushViewController:t_vc animated:YES];
                
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }
            
        }else if ([t_title isEqualToString:@"视频录入"]){
            
            if ([menuModel.isUser isEqualToNumber:@1]) {
                VideoColectVC *t_vc = [[VideoColectVC alloc] init];
                [self.navigationController pushViewController:t_vc animated:YES];
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }

        }else if ([t_title isEqualToString:@"工程车辆"]){
            
            if ([menuModel.isUser isEqualToNumber:@1]) {
                ImportCarHomeVC * t_vc = [[ImportCarHomeVC alloc] init];
                [self.navigationController pushViewController:t_vc animated:YES];
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }

        }else if ([t_title isEqualToString:@"警力分布"]){
            
            if ([menuModel.isUser isEqualToNumber:@1]) {
                
                PoliceDistributeViewModel * viewModel = [[PoliceDistributeViewModel alloc] init];
                PoliceDistributeVC * t_vc = [[PoliceDistributeVC alloc] initWithViewModel:viewModel];
                //PoliceCommandVC * t_vc = [[PoliceCommandVC alloc] init];
                [self.navigationController pushViewController:t_vc animated:YES];
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }

        }else if ([t_title isEqualToString:@"联合执法"]){
            
            if ([menuModel.isUser isEqualToNumber:@1]) {
                JointEnforceVC *t_vc = [[JointEnforceVC alloc] init];
                [self.navigationController pushViewController:t_vc animated:YES];
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }

        }else if ([t_title isEqualToString:@"行动管理"]){
            
            if ([menuModel.isUser isEqualToNumber:@1]) {
                ActionManageVC *t_vc = [[ActionManageVC alloc] init];
                t_vc.type = 1;
                [self.navigationController pushViewController:t_vc animated:YES];
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }
            
        }else if ([t_title isEqualToString:@"特殊车辆"]){
            
            if ([menuModel.isUser isEqualToNumber:@1]) {
                SpecialVehicleVC *t_vc = [[SpecialVehicleVC alloc] init];
                t_vc.type = 1;
                [self.navigationController pushViewController:t_vc animated:YES];
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }
            
        }else if ([t_title isEqualToString:@"勤务管理"]){
            
            if ([menuModel.isUser isEqualToNumber:@1]) {
                AttendanceManageVC *t_vc = [[AttendanceManageVC alloc] init];
                [self.navigationController pushViewController:t_vc animated:YES];
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }
            
        }else if ([t_title isEqualToString:@"资料共享"]){
            
            if ([menuModel.isUser isEqualToNumber:@1]) {
                [ShareFun showTipLable:@"当前功能正在研发中，请耐心等待"];
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }
            
        }else if ([t_title isEqualToString:@"车场管理"]){
            
            if ([menuModel.isUser isEqualToNumber:@1]) {
                [ShareFun showTipLable:@"当前功能正在研发中，请耐心等待"];
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }
            
        }else if ([t_title isEqualToString:@"快递员监管"]){
            
            if ([menuModel.isUser isEqualToNumber:@1]) {
                TakeOutSearchVC *t_vc = [[TakeOutSearchVC alloc] init];
                [self.navigationController pushViewController:t_vc animated:YES];
            }else{
                [ShareFun showTipLable:@"您暂无权限使用本功能"];
            }
            
        }
        
        
    }
}


#pragma mark - UICollectionView Delegate FlowLayout

// cell 尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width=(ScreenWidth - 30 -3.1f)/4.f;
    if (SCREEN_WIDTH > 320) {
        return CGSizeMake(width, width);
    }else{
        return CGSizeMake(width, width+10);
    }
    
}

// 装载内容 cell 的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 10, 15);
}

//最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}

//item最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}

//header头部大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return (CGSize){ScreenWidth,46};
}

// 设置section尾视图的参考大小，与tablefooterview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == self.section - 1) {
        return (CGSize){ScreenWidth,60};;
    }
    return CGSizeZero;
}

#pragma mark - AKTabBar Method

- (NSString *)tabImageName{
    return @"tabbar_main_n";
}

- (NSString *)tabSelectedImageName{
    return @"tabbar_main_h";
}

- (NSString *)tabTitle{
    return NSLocalizedString(@"工作", nil);
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    LxPrintf(@"MainHomeVC dealloc");

}

@end
