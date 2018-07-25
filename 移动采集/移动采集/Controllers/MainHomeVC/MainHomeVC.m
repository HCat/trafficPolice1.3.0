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

#import "IllegalParkVC.h"
#import "CarInfoAddVC.h"
#import "AccidentVC.h"
#import "AccidentManageVC.h"
#import "VideoColectVC.h"
#import "SignInVC.h"
#import "ImportCarHomeVC.h"
#import "PoliceCommandVC.h"
#import "JointEnforceVC.h"
#import "NoticeVC.h"

#import "MainCellLayout.h"
#import "CommonAPI.h"

@interface MainHomeVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (weak, nonatomic) IBOutlet UILabel *lb_departmentName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_topHeight;

@property (weak, nonatomic) IBOutlet UIView *v_notice;
@property (weak, nonatomic) IBOutlet UILabel *lb_notice;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_top_colectionVIew;


@property (nonatomic,strong) NSMutableArray * arr_illegal;
@property (nonatomic,strong) NSMutableArray * arr_accident;
@property (nonatomic,strong) NSMutableArray * arr_policeMatter;

@end

@implementation MainHomeVC

static NSString *const cellId = @"BaseImageCollectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IPHONE_X) {
        _layout_topHeight.constant = _layout_topHeight.constant + 24;
    }
    
    //这里获取事故通用值
    [[ShareValue sharedDefault] accidentCodes];
    //这里获取道路通用值通用值
    [[ShareValue sharedDefault] roadModels];
    
    [_collectionView registerClass:[BaseImageCollectionCell class] forCellWithReuseIdentifier:cellId];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mainCollectHeader"];
    
    MainCellLayout *layout=[[MainCellLayout alloc] init];
    [_collectionView setCollectionViewLayout:layout];
    
    if ([UserModel getUserModel] != nil) {
        _lb_departmentName.text = [UserModel getUserModel].departmentName;
    }
   
    _v_notice.hidden = YES;
    [self requestNotice];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

#pragma mark - set&&get

- (NSMutableArray *)arr_illegal{
    
    if (!_arr_illegal) {
        _arr_illegal = [NSMutableArray array];
        
        if ([UserModel getUserModel]) {
            
            if ([UserModel isPermissionForIllegal]) {
                [_arr_illegal  addObject:@{@"image":@"menu_illegal",@"title":@"违停录入"}];
            }
            
            if ([UserModel isPermissionForIllegalReverseParking]) {
                [_arr_illegal  addObject:@{@"image":@"menu_reversePark",@"title":@"不按朝向"}];
            }
            
            if ([UserModel isPermissionForIllegalReverseParking]) {
                [_arr_illegal  addObject:@{@"image":@"menu_lockCar",@"title":@"违停锁车"}];
            }
            
            if ([UserModel isPermissionForIllegalReverseParking]) {
                [_arr_illegal  addObject:@{@"image":@"menu_carInfoAdd",@"title":@"车辆录入"}];
            }
            
            if ([UserModel isPermissionForThrough]) {
                [_arr_illegal  addObject:@{@"image":@"menu_through",@"title":@"违反禁令"}];
            }
            
            if ([UserModel isPermissionForVideoCollect]) {
                [_arr_illegal  addObject:@{@"image":@"menu_videoCollect",@"title":@"视频录入"}];
            }
            
            if ([UserModel isPermissionForJointEnforcement]) {
                [_arr_illegal  addObject:@{@"image":@"menu_jointEnforcement",@"title":@"联合执法"}];
            }
            
            
        }
    }
    
    return _arr_illegal;
}

- (NSMutableArray *)arr_accident{
    
    if (!_arr_accident) {
        _arr_accident = [NSMutableArray array];
        
        if ([UserModel getUserModel]) {
            
            if ([UserModel isPermissionForFastAccident]) {
                [_arr_accident  addObject:@{@"image":@"menu_fastAccident",@"title":@"快处录入"}];
            }
            
            if ([UserModel isPermissionForAccident]) {
                [_arr_accident  addObject:@{@"image":@"menu_accident",@"title":@"事故录入"}];
            }
            
        }
    }
    
    return _arr_accident;
    
}


- (NSMutableArray *)arr_policeMatter{
    
    if (!_arr_policeMatter) {
        _arr_policeMatter = [NSMutableArray array];
        
        if ([UserModel getUserModel]) {
            
            if ([UserModel isPermissionForImportantCar]) {
                [_arr_policeMatter  addObject:@{@"image":@"menu_keyPointCar",@"title":@"工程车辆"}];
            }
            
            if ([UserModel isPermissionForPoliceCommand]) {
                [_arr_policeMatter  addObject:@{@"image":@"menu_serviceCommand",@"title":@"警力分布"}];
            }
            
        }
    }
    
    return _arr_policeMatter;
    
}

#pragma mark - 通知数据请求

- (void)requestNotice{

    WS(weakSelf);
    CommonPoliceAnounceManger *manger = [[CommonPoliceAnounceManger alloc] init];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {

            if ([manger.swicth isEqualToNumber:@1]) {
                strongSelf.v_notice.hidden = NO;
                strongSelf.lb_notice.text = manger.content;
                strongSelf.layout_top_colectionVIew.constant = 74;
                [strongSelf.view setNeedsLayout];
            }else{
                strongSelf.v_notice.hidden = YES;
            }
            
        }

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {

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
    
    if (self.arr_illegal && self.arr_illegal.count > 0) {
        section += 1;
    }
    if (self.arr_accident && self.arr_accident.count > 0){
        section += 1;
    }
    
    if (self.arr_policeMatter && self.arr_policeMatter.count > 0){
        section += 1;
    }
    
    return section;
}

//返回每组多少个视图
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSMutableArray *t_arr = [self arrayFromSection:section];
    return t_arr.count;
    
}

//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *t_arr = [self arrayFromSection:indexPath.section];
    
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
        
        NSDictionary *t_dic = [t_arr objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[t_dic objectForKey:@"image"]];
        cell.lb_title.text = [t_dic objectForKey:@"title"];
        
        return cell;
    }
   
    return nil;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *t_title = nil;
    if (indexPath.section == 0) {
        if (self.arr_illegal && self.arr_illegal.count > 0) {
            t_title = @"违章采集";
        }else if (self.arr_accident && self.arr_accident.count > 0){
            t_title = @"事故纠纷";
        }else if (self.arr_policeMatter && self.arr_policeMatter.count > 0){
            t_title = @"警务管理";
        }
        
    }else if (indexPath.section == 1){
        if (self.arr_accident && self.arr_accident.count > 0){
            t_title = @"事故纠纷";
        }else if (self.arr_policeMatter && self.arr_policeMatter.count > 0){
            t_title = @"警务管理";
        }
        
    }else if (indexPath.section == 2){
        if (self.arr_policeMatter && self.arr_policeMatter.count > 0){
            t_title = @"警务管理";
        }
    }
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"mainCollectHeader" forIndexPath:indexPath];
    headerView.backgroundColor =[UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 0, headerView.bounds.size.width - 15.f, headerView.bounds.size.height)];
    label.text = t_title;
    label.textColor = DefaultTextColor;
    label.font = [UIFont boldSystemFontOfSize:17.f];
    [headerView addSubview:label];
    return headerView;
}



//选中时的操作
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSMutableArray * t_arr = [self arrayFromSection:indexPath.section];
    
    if (t_arr) {
        
        NSDictionary *t_dic = [t_arr objectAtIndex:indexPath.row];
        NSString *t_title = [t_dic objectForKey:@"title"];
        
        if ([t_title isEqualToString:@"违停录入"]) {
            
            IllegalParkVC *t_vc = [[IllegalParkVC alloc] init];
            t_vc.illegalType = IllegalTypePark;
            t_vc.subType = ParkTypePark;
            [self.navigationController pushViewController:t_vc animated:YES];
            
        }else if ([t_title isEqualToString:@"不按朝向"]) {
            
            IllegalParkVC *t_vc = [[IllegalParkVC alloc] init];
            t_vc.illegalType = IllegalTypePark;
            t_vc.subType = ParkTypeReversePark;
            [self.navigationController pushViewController:t_vc animated:YES];
            
        }else if ([t_title isEqualToString:@"车辆录入"]) {
            
            CarInfoAddVC *t_vc = [[CarInfoAddVC alloc] init];
            [self.navigationController pushViewController:t_vc animated:YES];
            
        }else if ([t_title isEqualToString:@"违停锁车"]) {
            
            IllegalParkVC *t_vc = [[IllegalParkVC alloc] init];
            t_vc.illegalType = IllegalTypePark;
            t_vc.subType = ParkTypeLockPark;
            [self.navigationController pushViewController:t_vc animated:YES];
            
        }else if ([t_title isEqualToString:@"违反禁令"]){
            
            IllegalParkVC *t_vc = [[IllegalParkVC alloc] init];
            t_vc.illegalType = IllegalTypeThrough;
            [self.navigationController pushViewController:t_vc animated:YES];
            
        }else if ([t_title isEqualToString:@"事故录入"]){
            
            AccidentManageVC *t_vc = [[AccidentManageVC alloc] init];
            t_vc.accidentType = AccidentTypeAccident;
            [self.navigationController pushViewController:t_vc animated:YES];
            
        }else if ([t_title isEqualToString:@"快处录入"]){
            
            AccidentManageVC *t_vc = [[AccidentManageVC alloc] init];
            t_vc.accidentType = AccidentTypeFastAccident;
            [self.navigationController pushViewController:t_vc animated:YES];
            
        }else if ([t_title isEqualToString:@"视频录入"]){
            
            VideoColectVC *t_vc = [[VideoColectVC alloc] init];
            [self.navigationController pushViewController:t_vc animated:YES];
            
        }else if ([t_title isEqualToString:@"工程车辆"]){
            ImportCarHomeVC * t_vc = [[ImportCarHomeVC alloc] init];
            [self.navigationController pushViewController:t_vc animated:YES];
            
            
        }else if ([t_title isEqualToString:@"警力分布"]){
            
            PoliceCommandVC * t_vc = [[PoliceCommandVC alloc] init];
            [self.navigationController pushViewController:t_vc animated:YES];
            
        }else if ([t_title isEqualToString:@"联合执法"]){
            JointEnforceVC *t_vc = [[JointEnforceVC alloc] init];
            [self.navigationController pushViewController:t_vc animated:YES];
            
        }
    }
    
    

}

- (NSMutableArray *)arrayFromSection:(NSInteger)section{
    
    if (section == 0) {
        if (self.arr_illegal && self.arr_illegal.count > 0) {
            return  _arr_illegal;
        }else if (self.arr_accident && self.arr_accident.count > 0){
            return _arr_accident;
        }else if (self.arr_policeMatter && self.arr_policeMatter.count > 0){
            return _arr_policeMatter;
        }
        
    }else if (section == 1){
        if (self.arr_accident && self.arr_accident.count > 0){
            return _arr_accident;
        }else if (self.arr_policeMatter && self.arr_policeMatter.count > 0){
            return _arr_policeMatter;
        }
        
    }else if (section == 2){
        if (self.arr_policeMatter && self.arr_policeMatter.count > 0){
            return _arr_policeMatter;
        }
    }
    
    return nil;
    
}


#pragma mark - UICollectionView Delegate FlowLayout

// cell 尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width=(ScreenWidth - 30 -3.1f)/4.f;
    if (SCREEN_WIDTH > 320) {
        return CGSizeMake(width, width+10);
    }else{
        return CGSizeMake(width, width+20);
    }
    
}

// 装载内容 cell 的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
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
