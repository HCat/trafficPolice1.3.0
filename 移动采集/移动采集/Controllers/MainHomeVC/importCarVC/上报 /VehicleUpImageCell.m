//
//  VehicleUpImageCell.m
//  移动采集
//
//  Created by hcat on 2018/5/17.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleUpImageCell.h"
#import <PureLayout.h>
#import "ImageFileInfo.h"

#import "VehicleUpVC.h"

@interface VehicleUpImageCell()

@property (nonatomic,strong) UIScrollView *scro_image;
@property (nonatomic,strong) NSMutableArray *arr_view;
@property (nonatomic,strong) UIButton *btn_add;

@end

@implementation VehicleUpImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _arr_view = [NSMutableArray array];
    
    
}

- (void)setArr_images:(NSMutableArray *)arr_images{
    
    _arr_images = arr_images;
    [self handleUIWithCount:_arr_images.count];

}


- (void)handleUIWithCount:(NSInteger)count{
    
    [_scro_image removeFromSuperview];
    [_btn_add removeFromSuperview];
    [_arr_view removeAllObjects];
    
    
    _scro_image = [[UIScrollView alloc] init];
    _scro_image.backgroundColor = [UIColor clearColor];
    _scro_image.bounces = NO;
    [self.contentView addSubview:_scro_image];
    [_scro_image configureForAutoLayout];
    [_scro_image autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(49, 15, 10, 15) excludingEdge:ALEdgeBottom];
    [_scro_image autoSetDimension:ALDimensionHeight toSize:101.f];
    
    if (count == 0) {
        
        UIButton *t_button = [UIButton new];
        [_scro_image addSubview:t_button];
        t_button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        t_button.backgroundColor = [UIColor clearColor];
        t_button.layer.masksToBounds = YES;
        t_button.layer.cornerRadius = 5.f;
        [t_button setImage: [UIImage imageNamed:@"btn_updatePhoto"] forState:UIControlStateNormal];
        [t_button addTarget:self action:@selector(handleBtnTakePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [t_button autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTrailing];
        [t_button autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:_scro_image];
        [t_button autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:t_button];
        
        
    }else{
        
        for ( int i = 0 ; i < count ; i++) {
            
            UIButton *t_button = [UIButton new];
            [_scro_image addSubview:t_button];
            [_arr_view addObject:t_button];
            t_button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            t_button.backgroundColor = [UIColor clearColor];
            t_button.layer.masksToBounds = YES;
            t_button.layer.cornerRadius = 5.f;
            t_button.tag = i+100;
            [t_button setImage: _arr_images[i] forState:UIControlStateNormal];
            [t_button addTarget:self action:@selector(handleBtnShowPhoto:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                [t_button autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTrailing];
            }
            
            [t_button autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:_scro_image];
            [t_button autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:t_button];
            
            if (i > 0) {
                [t_button autoPinEdgeToSuperviewEdge:ALEdgeTop];
                [t_button autoPinEdgeToSuperviewEdge:ALEdgeBottom];
                UIButton *t_btn = (UIButton *)_arr_view[i-1];
                [t_button autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:t_btn withOffset:15.f];
                
            }
            
        }
        
        UIButton *t_addBtn = [UIButton new];
        [_scro_image addSubview:t_addBtn];
        t_addBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        t_addBtn.backgroundColor = [UIColor clearColor];
        t_addBtn.layer.masksToBounds = YES;
        t_addBtn.layer.cornerRadius = 5.f;
        [t_addBtn setImage: [UIImage imageNamed:@"btn_updatePhoto"] forState:UIControlStateNormal];
        [t_addBtn addTarget:self action:@selector(handleBtnTakePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [t_addBtn autoPinEdgeToSuperviewEdge:ALEdgeTop];
        [t_addBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
        [t_addBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
        [t_addBtn autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:_scro_image];
        [t_addBtn autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:t_addBtn];
        [t_addBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_arr_view.lastObject withOffset:15.f];
        
    }
    [_scro_image layoutIfNeeded];
    

    if(_scro_image.contentSize.width > (SCREEN_WIDTH-30)){
        
        _btn_add = [UIButton new];
        [self.contentView addSubview:_btn_add];
        _btn_add.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _btn_add.backgroundColor = [UIColor whiteColor];
        [_btn_add setImage: [UIImage imageNamed:@"btn_updatePhoto"] forState:UIControlStateNormal];
        [_btn_add addTarget:self action:@selector(handleBtnTakePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [_btn_add autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_scro_image withOffset:0];
        [_btn_add autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_scro_image withOffset:0];
        [_btn_add autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:_scro_image withOffset:0];
        [_btn_add autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:_scro_image];
        [_btn_add autoMatchDimension:ALDimensionWidth toDimension:ALDimensionHeight ofView:_btn_add];
        
        
        _scro_image.contentOffset = CGPointMake(_scro_image.contentSize.width - (SCREEN_WIDTH-30), 0);
    }
   
 
}

#pragma mark - buttonAction

- (IBAction)handleBtnTakePhoto:(id)sender{
    [[self getPhotoActionSheet] showPhotoLibrary];
 
}

- (IBAction)handleBtnShowPhoto:(id)sender{
    
    UIButton * t_btn = (UIButton *)sender;
    NSInteger tag = t_btn.tag;
     [[self getPhotoActionSheet] previewSelectedPhotos:self.lastSelectPhotos assets:self.lastSelectAssets index:tag-100 isOriginal:NO];
    
}


#pragma mark - initActionSheet

- (ZLPhotoActionSheet *)getPhotoActionSheet{
    
    VehicleUpVC * vc = (VehicleUpVC *)[ShareFun findViewController:self withClass:[VehicleUpVC class]];
    
    
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.configuration.allowSelectImage = YES;
    actionSheet.configuration.allowSelectGif = NO;
    actionSheet.configuration.allowSelectVideo = NO;
    actionSheet.configuration.allowSelectLivePhoto = NO;
    actionSheet.configuration.allowForceTouch = NO;
    actionSheet.configuration.allowEditImage = NO;
    actionSheet.configuration.allowTakePhotoInLibrary = YES;
    actionSheet.configuration.showCaptureImageOnTakePhotoBtn = YES;
    //设置照片最大预览数
    actionSheet.configuration.maxPreviewCount = 9;
    actionSheet.configuration.maxSelectCount = 9;
    actionSheet.configuration.cellCornerRadio = 0;
    actionSheet.configuration.showSelectBtn = NO;
    
    actionSheet.sender = vc;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (PHAsset *asset in self.lastSelectAssets) {
        if (asset.mediaType == PHAssetMediaTypeImage) {
            [arr addObject:asset];
        }
    }
    actionSheet.arrSelectedAssets =  actionSheet.configuration.maxSelectCount > 1 ? arr : nil;
    
    WS(weakSelf);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        SW(strongSelf, weakSelf);
        
        [strongSelf.lastSelectAssets removeAllObjects];
        [strongSelf.lastSelectPhotos removeAllObjects];
        [strongSelf.lastSelectPhotos addObjectsFromArray:images];
        [strongSelf.lastSelectAssets addObjectsFromArray:assets];
        
        [strongSelf.arr_images removeAllObjects];
        [strongSelf.arr_images addObjectsFromArray:images];
        
        [[self getTableView] reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[self getIndexPath],nil] withRowAnimation:UITableViewRowAnimationNone];
       
    }];
    
    return actionSheet;
}


- (NSIndexPath *)getIndexPath {
    return [[self getTableView] indexPathForCell:self];
}

// retrieve the table view from self
- (UITableView *)getTableView {
    // get the superview of this class, note the camel-case V to differentiate
    // from the class' superview property.
    UIView *superView = self.superview;
    
    /*
     check to see that *superView != nil* (if it is then we've walked up the
     entire chain of views without finding a UITableView object) and whether
     the superView is a UITableView.
     */
    while (superView && ![superView isKindOfClass:[UITableView class]]) {
        superView = superView.superview;
    }
    
    // if superView != nil, then it means we found the UITableView that contains
    // the cell.
    if (superView) {
        // cast the object and return
        return (UITableView *)superView;
    }
    
    // we did not find any UITableView
    return nil;
}


#pragma mark - dealloc

- (void)dealloc{
    LxPrintf(@"VehicleUpImageCell dealloc");
    
}


@end
