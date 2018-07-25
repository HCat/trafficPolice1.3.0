//
//  AccidentUpImageCell.m
//  移动采集
//
//  Created by hcat on 2018/7/10.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "AccidentUpImageCell.h"

#import "AccidentManageVC.h"
#import <PureLayout/PureLayout.h>
#import "NSArray+PureLayoutMore.h"

@interface AccidentUpImageCell()

@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic,strong) NSMutableArray *arr_view;

@end

@implementation AccidentUpImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.arr_view = [NSMutableArray array];
}

#pragma mark - set && get

- (void)setArr_photo:(NSMutableArray *)arr_photo{
    
    _arr_photo = arr_photo;
    
    if (_arr_photo) {
        
        for (int i = 0;i < [_arr_view count]; i++) {
            
            UIButton * t_button = _arr_view[i];
            [t_button removeFromSuperview];
        
        }
        
        [_arr_view removeAllObjects];
        
        
        NSMutableArray *arr_v = [NSMutableArray new];
        
        for (int i = 0;i < [_arr_photo count] + 1; i++) {
            
            UIImage * image = nil;
            if (i < [_arr_photo count]) {
                image = _arr_photo[i];
            }
            
            UIButton *t_button = [UIButton newAutoLayoutView];
            if (i == _arr_photo.count) {
                [t_button setImage:[UIImage imageNamed:@"btn_updatePhoto"] forState:UIControlStateNormal];
                t_button.imageView.contentMode = UIViewContentModeScaleAspectFit;
                t_button.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
                t_button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
            }else{
                [t_button setImage:image forState:UIControlStateNormal];
                t_button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            }
        
            t_button.tag = i;
            t_button.layer.cornerRadius = 5.0f;
            t_button.layer.masksToBounds = YES;
            
            [t_button addTarget:self action:@selector(btnTagAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:t_button];
            [_arr_view addObject:t_button];
            
            if ( i % 3 == 0) {
                
                if (arr_v && [arr_v count] > 0) {
                    [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:10.0 withFixedLeading:15 withFixedTrailing:15 matchedSizes:YES];
                    [arr_v removeAllObjects];
                }
                
                if ( i ==  0){
                    [t_button autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:50.0];
                }else{
                    UIButton *btn_before = _arr_view[i - 3];
                    [t_button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:btn_before withOffset:10.0];
                    
                }
                
            }
            
            [arr_v addObject:t_button];
        }
        
        if ([arr_v count] == 1) {
            
            UIButton *t_btn = arr_v[0];
            [t_btn autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 2*15 - 2*10)/3];
            [t_btn autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:15.0f];
        }else if ([arr_v count] == 2){
            
            UIButton *btn_before = arr_v[0];
            UIButton *btn_after = arr_v[1];
            [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 2*15 - 2*10)/3];
            [btn_after autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 2*15 - 2*10)/3];
            
            [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:15.0f];
            [btn_after autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:btn_before withOffset:10.0];
            
            [arr_v autoAlignViewsToAxis:ALAxisHorizontal];
        }else if ([arr_v count] == 3 ){
            [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:10.0 withFixedLeading:15 withFixedTrailing:15 matchedSizes:YES];
            
        }
        
        [arr_v removeAllObjects];
        
        for (int i = 0;i < [_arr_view count]; i++) {
            UIButton *t_button  = _arr_view[i];
            [t_button autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:t_button];
            
            if (i == _arr_view.count - 1 ) {
                UIButton *t_button_last  = _arr_view[i];
                [t_button_last autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-20.f];
            }
        }
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        
        
    }
    
}

- ( NSMutableArray<UIImage *> *) lastSelectPhotos{
    return _arr_photo.mutableCopy;
}

#pragma mark - 按钮事件

- (void)btnTagAction:(id)sender{
    UIButton *t_btn = (UIButton *)sender;
    
    if (t_btn.tag == _arr_photo.count) {
        
        [[self getPhotoActionSheet] showPhotoLibrary];
        
    } else {
        
        [[self getPhotoActionSheet] previewSelectedPhotos:self.lastSelectPhotos assets:self.lastSelectAssets index:t_btn.tag];
    }
    
    
}





#pragma mark - 初始化照片选择器

- (ZLPhotoActionSheet *)getPhotoActionSheet
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    actionSheet.sortAscending = NO;
    actionSheet.allowSelectImage = YES;
    actionSheet.allowSelectGif = NO;
    actionSheet.allowSelectVideo = NO;
    actionSheet.allowSelectLivePhoto = NO;
    actionSheet.allowForceTouch = NO;
    actionSheet.allowEditImage = NO;
    actionSheet.allowTakePhotoInLibrary = YES;
    actionSheet.showCaptureImageOnTakePhotoBtn = YES;
    //设置照片最大预览数
    actionSheet.maxPreviewCount = kmaxPreviewCount;
    actionSheet.maxSelectCount = kmaxSelectCount;
    actionSheet.cellCornerRadio = 0;
    actionSheet.showSelectBtn = NO;
    AccidentManageVC * vc = (AccidentManageVC *)[ShareFun findViewController:self withClass:[AccidentManageVC class]];
    actionSheet.sender = vc;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (PHAsset *asset in self.lastSelectAssets) {
        if (asset.mediaType == PHAssetMediaTypeImage) {
            [arr addObject:asset];
        }
    }
    actionSheet.arrSelectedAssets =  actionSheet.maxSelectCount > 1 ? arr : nil;
    
    WS(weakSelf);
    
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        SW(strongSelf, weakSelf);
        
        if (strongSelf.arr_photo && strongSelf.arr_photo.count > 0) {
            [strongSelf.arr_photo removeAllObjects];
        }
        if (strongSelf.lastSelectAssets && strongSelf.lastSelectAssets.count > 0) {
            [strongSelf.lastSelectAssets removeAllObjects];
        }
        
        [strongSelf.arr_photo addObjectsFromArray:images];
        [strongSelf.lastSelectAssets addObjectsFromArray:assets];

        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [[strongSelf getTableView] reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
        LxPrintf(@"image:%@", images);
    }];
    
    return actionSheet;
}

#pragma mark - 获取UITableView

- (UITableView *)getTableView {
    
    UIView *superView = self.superview;
    
    while (superView && ![superView isKindOfClass:[UITableView class]]) {
        superView = superView.superview;
    }
    
    if (superView) {
        return (UITableView *)superView;
    }
    
    return nil;
}

#pragma mark - dealloc

- (void)dealloc{
    LxPrintf(@"AccidentUpImageCell dealloc");
}

@end
