//
//  ScreenAddVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/6/24.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ScreenAddVC.h"
#import "ScreenAddCell.h"
#import "ScreenManageAPI.h"
#import "UINavigationBar+BarItem.h"
#import "LRCameraVC.h"

@interface ScreenAddVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) UICollectionView * mainCollectionView;

@property(nonatomic,strong) NSMutableArray * arr_name;
@property (weak, nonatomic) IBOutlet UIButton *btn_makeSure;

@end

@implementation ScreenAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arr_name = @[].mutableCopy;
    
    [self lr_configUI];
    [self lr_bindViewModel];

}

- (void)lr_configUI{
    
    [self showRightBarButtonItemWithImage:@"icon_screen_scan" target:self action:@selector(showCamare)];
    
    self.title = @"添加";
    
    self.btn_makeSure.layer.cornerRadius = 5.f;
    self.btn_makeSure.layer.masksToBounds = YES;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置item的行间距和列间距
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    
    // 设置item的大小
    CGFloat itemW = (SCREEN_WIDTH - 40) / 2;
    layout.itemSize = CGSizeMake(itemW, 50);
    
    // 设置每个分区的 上左下右 的内边距
    layout.sectionInset = UIEdgeInsetsMake(15, 15 ,15, 15);
    
    // 设置区头和区尾的大小
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 0);
    layout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, 0);
    
    // 设置分区的头视图和尾视图 是否始终固定在屏幕上边和下边
    layout.sectionFootersPinToVisibleBounds = YES;
    
    // 设置滚动条方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = YES;   //是否显示滚动条
    collectionView.scrollEnabled = YES;  //滚动使能
    //3、添加到控制器的view
    [self.view addSubview:collectionView];
    self.mainCollectionView = collectionView;
    //4、布局
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.btn_makeSure.mas_top).offset(10);
    }];
    
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"ScreenAddCell" bundle:nil] forCellWithReuseIdentifier:@"AddNameID"];
    [self.mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"AddID"];
    

}

- (void)lr_bindViewModel{
    
    @weakify(self);
    [[self.btn_makeSure rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        if (self.arr_name.count > 0) {
            ScreenAddManger * manger = [[ScreenAddManger alloc] init];
            
            [self.arr_name enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString * name = (NSString * )obj;
                if (name.length == 0) {
                    [self.arr_name removeObject:name];
                }
            }];

            NSLog(@"%@",self.arr_name);
            

            if (self.arr_name.count == 0) {
                [LRShowHUD showError:@"输入姓名不能为空" duration:1.5f];
                return;
            }
        
            manger.nameArr = [self.arr_name componentsJoinedByString:@","];
            
            [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                @strongify(self);
                       
                if (manger.responseModel.code == CODE_SUCCESS) {
                    [LRShowHUD showSuccess:@"添加成功" duration:1.5f];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [self.navigationController popViewControllerAnimated:YES];
                    });
                   
                }
                       
             } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                 [LRShowHUD showError:@"请求失败" duration:1.5f];
             }];
        }else{
            [LRShowHUD showError:@"请添加成员" duration:1.5f];
        }
        
               
        
        
    }];
    
    
    
}

- (void)showCamare{
    
    LRCameraVC *home = [[LRCameraVC alloc] init];
    home.isAccident = YES;
    home.type = 3;
    home.fininshCaptureBlock = ^(LRCameraVC *camera) {
        if (camera) {
            if (camera.type == 3) {
                NSString * t_name = camera.commonIdentifyResponse.name;
                [self.arr_name addObject:t_name];
                [self.mainCollectionView reloadData];
            }
        }
    };
    [self presentViewController:home
                       animated:NO
                     completion:^{
                     }];
    
}

#pragma mark -collectionview 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;   //返回section数
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (self.arr_name.count > 0) {
        return self.arr_name.count + 1;
    }else{
        return 2;
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    if (self.arr_name.count > 0) {
        
        if (indexPath.row == self.arr_name.count) {
            UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddID" forIndexPath:indexPath];
            UIButton * button = [[UIButton alloc] init];
            [button setImage:[UIImage imageNamed:@"icon_screen_add"] forState:UIControlStateNormal];
            [button setTitle:@"新增" forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x3396FC) forState:UIControlStateNormal];
            [cell.contentView addSubview:button];
            button.backgroundColor = UIColorFromRGB(0xF5F9FE);
            button.layer.borderColor = UIColorFromRGB(0x3396FC).CGColor;
            button.layer.borderWidth = .5f;
            button.layer.cornerRadius = 5.f;
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.equalTo(cell.contentView).offset(1);
            }];
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                NSString * name = @"";
                [self.arr_name addObject:name];
                [self.mainCollectionView reloadData];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     ScreenAddCell *cell = (ScreenAddCell*)[self.mainCollectionView
                                                                      cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.arr_name.count-1 inSection:0]];
                    [cell.tf_name becomeFirstResponder];
                    [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.arr_name.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
                });
                
            }];
            
            return cell;
            
        }else{
            ScreenAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddNameID" forIndexPath:indexPath];
            NSString * t_name = self.arr_name[indexPath.row];
            cell.index = @(indexPath.row);
            cell.count = @(self.arr_name.count);
            cell.name = t_name;
            cell.block = ^(NSNumber * _Nonnull index) {
                
                [self.arr_name removeObjectAtIndex:[index intValue]];
                [self.mainCollectionView reloadData];
            };
            cell.doneBlock = ^(NSNumber * _Nonnull index, NSString * _Nonnull name) {
                if (([index intValue] > self.arr_name.count -1) || self.arr_name.count == 0) {
                    return;
                }else{
                    [self.arr_name replaceObjectAtIndex:[index integerValue] withObject:name];
                    [self.mainCollectionView reloadData];
                }
                
            };
            
            return cell;
        }
        
    }else{
        
        
        if (indexPath.row == 1) {
            UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddID" forIndexPath:indexPath];
            UIButton * button = [[UIButton alloc] init];
            [button setImage:[UIImage imageNamed:@"icon_screen_add"] forState:UIControlStateNormal];
            [button setTitle:@"新增" forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x3396FC) forState:UIControlStateNormal];
            [cell.contentView addSubview:button];
            button.backgroundColor = UIColorFromRGB(0xF5F9FE);
            button.layer.borderColor = UIColorFromRGB(0x3396FC).CGColor;
            button.layer.borderWidth = .5f;
            button.layer.cornerRadius = 5.f;
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.equalTo(cell.contentView).offset(1);
            }];
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                NSString * name = @"";
                [self.arr_name addObject:name];
                [self.mainCollectionView reloadData];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     ScreenAddCell *cell = (ScreenAddCell*)[self.mainCollectionView
                                                                      cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.arr_name.count-1 inSection:0]];
                    [cell.tf_name becomeFirstResponder];
                    [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.arr_name.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
                });
                
            }];
            
            return cell;
            
        }else{
            
            ScreenAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddNameID" forIndexPath:indexPath];
            NSString * name = @"";
            [self.arr_name addObject:name];
            
            cell.index = @(indexPath.row);
            cell.count = @(self.arr_name.count);
            cell.block = ^(NSNumber * _Nonnull index) {
                
                [self.arr_name removeObjectAtIndex:[index intValue]];
                [self.mainCollectionView reloadData];
            };
            cell.doneBlock = ^(NSNumber * _Nonnull index, NSString * _Nonnull name) {
                if (([index intValue] > self.arr_name.count -1) || self.arr_name.count == 0) {
                    return;
                }else{
                    [self.arr_name replaceObjectAtIndex:[index integerValue] withObject:name];
                    [self.mainCollectionView reloadData];
                }
                
            };
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 ScreenAddCell *cell = (ScreenAddCell*)[self.mainCollectionView
                                                                  cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.arr_name.count-1 inSection:0]];
                [cell.tf_name becomeFirstResponder];
                [self.mainCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.arr_name.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
            });
            
            return cell;
        }
        
       
    }
    
}

@end
