//
//  ParkingCarImageVC.m
//  移动采集
//
//  Created by hcat on 2019/9/23.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingCarImageVC.h"
#import "NSArray+MASConstraint.h"
#import "UIButton+NoRepeatClick.h"
#import <UIButton+WebCache.h>
#import "UIImage+Category.h"
#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"

@interface ParkingCarImageVC ()

@property (weak, nonatomic) IBOutlet UIView *v_images;
@property (strong, nonatomic) NSMutableArray *arr_buttons;


@end

@implementation ParkingCarImageVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    @weakify(self);
    
    //监听建筑垃圾类型数量
    [RACObserve(self,arr_images) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        for (int i = 0; i < self.arr_images.count; i++) {
//            DeliveryIllegalTypeModel * t_dic  = self.deliveryIllegalList[i];
            
            UIButton * t_button = [[UIButton alloc] init];
//            [t_button sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
            
            t_button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            t_button.tag = 1000+i;
            t_button.layer.cornerRadius = 5.f;
            t_button.layer.masksToBounds = YES;
            [[t_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                UIButton * button = (UIButton *)x;
                NSMutableArray *t_arr = [NSMutableArray array];
                
                for (int i = 0; i < self.arr_buttons.count; i++) {
                    UIButton * btn = self.arr_buttons[i];
                    //DeliveryIllegalImageModel * imageModel = self.viewModel.model.picList[i];
                    NSString * imageUrl = nil; //imageModel.imgUrl;
                    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:btn.imageView imageUrl:[NSURL URLWithString:imageUrl]];
                    [t_arr addObject:item];
                }
                
                KSPhotoBrowser *browser     = [KSPhotoBrowser browserWithPhotoItems:t_arr selectedIndex:(button.tag - 1000)];
                [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
                [browser setDelegate:(id<KSPhotoBrowserDelegate> _Nullable)self];
                browser.dismissalStyle      = KSPhotoBrowserInteractiveDismissalStyleScale;
                browser.backgroundStyle     = KSPhotoBrowserBackgroundStyleBlur;
                browser.loadingStyle        = KSPhotoBrowserImageLoadingStyleIndeterminate;
                browser.pageindicatorStyle  = KSPhotoBrowserPageIndicatorStyleText;
                browser.bounces             = NO;
                browser.isShowDeleteBtn     = NO;
                [browser showFromViewController:self];
                
            }];
            
            [self.v_images addSubview:t_button];
            [self.arr_buttons addObject:t_button];
        }
        
        if (self.v_images.subviews.count > 0) {
            
            [self.v_images.subviews mas_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:30.f
                                                                fixedLineSpacing:15 fixedInteritemSpacing:15
                                                                       warpCount:1
                                                                      topSpacing:15
                                                                   bottomSpacing:15 leadSpacing:15 tailSpacing:15];
        }
        
         [self.v_images layoutIfNeeded];
        
    }];
    
    
}

#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"ParkingCarImageVC dealloc");
}

@end
