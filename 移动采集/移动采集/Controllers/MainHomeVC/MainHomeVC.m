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

@interface MainHomeVC ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (nonatomic,strong) NSArray *arr_items;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_collection_top; //用于适配不同屏幕大小

@end

@implementation MainHomeVC

static NSString *const cellId = @"BaseImageCollectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //这里获取事故通用值
    [[ShareValue sharedDefault] accidentCodes];
    //这里获取道路通用值通用值
    [[ShareValue sharedDefault] roadModels];
    //定位
    [[LocationHelper sharedDefault] startLocation];
    
    [_collectionView registerClass:[BaseImageCollectionCell class] forCellWithReuseIdentifier:cellId];
    
    if (IS_IPHONE_4_OR_LESS) {
        self.layout_collection_top.constant = -127.f;
    }else if (IS_IPHONE_5){
        self.layout_collection_top.constant = -80.f;
    }else{
        self.layout_collection_top.constant = -47.f;
    }
    [self.view layoutIfNeeded];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];

}

#pragma mark - set

-(NSArray *)arr_items{
    
    if (!_arr_items) {
        
        NSMutableArray *t_arr = [NSMutableArray array];
        
        if ([UserModel getUserModel]) {
            
            if ([UserModel isPermissionForIllegal]) {
                [t_arr  addObject:@{@"image":@"menu_illegal",@"title":@"违停录入"}];
            }
            
            if ([UserModel isPermissionForThrough]) {
                [t_arr  addObject:@{@"image":@"menu_through",@"title":@"闯禁令录入"}];
            }
            
            if ([UserModel isPermissionForAccident]) {
                [t_arr  addObject:@{@"image":@"menu_accident",@"title":@"事故录入"}];
            }
            
            if ([UserModel isPermissionForFastAccident]) {
                [t_arr  addObject:@{@"image":@"menu_fastAccident",@"title":@"快处录入"}];
            }
            
            if ([UserModel isPermissionForVideoCollect]) {
                [t_arr  addObject:@{@"image":@"menu_videoCollect",@"title":@"视频录入"}];
            }

        }
        
        [t_arr  addObject:@{@"image":@"menu_keyPointCar",@"title":@"重点车辆"}];
        
        [t_arr  addObject:@{@"image":@"menu_serviceCommand",@"title":@"勤务指挥"}];
        
        [t_arr  addObject:@{@"image":@"menu_roadLive",@"title":@"路面实况"}];
        
        
        _arr_items = t_arr.copy;
        
    }
    
    return _arr_items;
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
    return [self.arr_items count];
}
//返回视图的具体事例，我们的数据关联就是放在这里
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BaseImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    cell.isNeedTitle = YES;
    cell.imageView.contentMode = UIViewContentModeCenter;
    cell.layer.cornerRadius = 0.0f;
    cell.lb_title.textColor = UIColorFromRGB(0x444444);
    cell.layout_imageWithLb.constant = -20;
    [cell layoutIfNeeded];

    NSDictionary *t_dic = [_arr_items objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[t_dic objectForKey:@"image"]];
    cell.lb_title.text = [t_dic objectForKey:@"title"];
   
    return cell;
}

#pragma mark - UICollectionView Delegate method

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    //设置(Highlight)高亮下的颜色
    [cell setBackgroundColor:DefaultBGColor];
}

- (void)collectionView:(UICollectionView *)colView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    //设置(Nomal)正常状态下的颜色
    [cell setBackgroundColor:[UIColor whiteColor]];
}
//选中时的操作
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

#pragma mark - UICollectionView Delegate FlowLayout

// cell 尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width=(ScreenWidth - 30 -2.1f)/3.f;
    return CGSizeMake(width, width+10);
}

// 装载内容 cell 的内边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 0, 0, 0);
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

#pragma mark - AKTabBar Method

- (NSString *)tabImageName{
    return @"tabbar_main_n";
}

- (NSString *)tabSelectedImageName{
    return @"tabbar_main_h";
}

- (NSString *)tabTitle{
    return NSLocalizedString(@"首页", nil);
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
