//
//  VehicleReportVC.m
//  移动采集
//
//  Created by hcat on 2018/2/8.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleReportVC.h"
#import <UIButton+WebCache.h>
#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"
#import "LRCameraVC.h"

@interface VehicleReportVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf_info;    //事故成因
@property (weak, nonatomic) IBOutlet UIButton *btn_commit;
@property (weak, nonatomic) IBOutlet UIButton *btn_image;

@property(nonatomic,assign) BOOL isCanCommit;

@property(nonatomic,strong) VehicleUpReportInfoParam *param;
@property(nonatomic,strong) VehicleReportInfoReponse *reponse; //请求下来的数据
@property(nonatomic,assign) BOOL isHaveImage;
@property(nonatomic,assign) BOOL isChangeImage;
@property (nonatomic,strong) ImageFileInfo *imageInfo;



@end

@implementation VehicleReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tf_info.attributedPlaceholder = [ShareFun highlightInString:@"请输入(必填)" withSubString:@"(必填)"];
    [_tf_info addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    _tf_info.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    _tf_info.leftViewMode = UITextFieldViewModeAlways;
    
    _btn_image.layer.cornerRadius = 5.0f;
    _btn_image.layer.masksToBounds = YES;
    _btn_image.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    _btn_image.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    _btn_image.layer.borderWidth = 1.0f;
    _btn_image.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
    
    
    self.isHaveImage = NO;
    self.isChangeImage = NO;
    self.isCanCommit = NO;
    
    self.param = [[VehicleUpReportInfoParam alloc] init];
    
    [self loadReportInfo];
}

-(void)setIsCanCommit:(BOOL)isCanCommit{
    _isCanCommit = isCanCommit;
    if (_isCanCommit == NO) {
        _btn_commit.enabled = NO;
        [_btn_commit setBackgroundColor:DefaultBtnNuableColor];
    }else{
        _btn_commit.enabled = YES;
        [_btn_commit setBackgroundColor:DefaultBtnColor];
    }
}

- (void)setIsHaveImage:(BOOL)isHaveImage{
    _isHaveImage = isHaveImage;
    if (!_isHaveImage) {
        _btn_image.imageView.contentMode = UIViewContentModeCenter;
        [_btn_image setImage:[UIImage imageNamed:@"btn_jointImageAdd"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - 请求数据

- (void)loadReportInfo{
    
    WS(weakSelf);
    
    VehicleReportInfoManger *manger = [[VehicleReportInfoManger alloc] init];
    manger.vehicleId = _platNo;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            strongSelf.reponse = manger.vehicleReportInfo;
            
            strongSelf.tf_info.text = manger.vehicleReportInfo.carriageOutsideH;
            if(strongSelf.reponse.mediaThumbUrl.length > 0 && strongSelf.reponse.mediaThumbUrl){
                strongSelf.isHaveImage = YES;
                NSString *str_url = [NSString stringWithFormat:@"%@%@",Base_URL,_reponse.mediaThumbUrl];
                strongSelf.btn_image.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [strongSelf.btn_image sd_setImageWithURL:[NSURL URLWithString:str_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];

            }else{
                strongSelf.isHaveImage = NO;
            }
            
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];

}

- (void)upReportInfo{

    if (self.imageInfo) {
        _param.oldImgId = _reponse.mediaId;
        _param.imgFile = self.imageInfo;
    }


    WS(weakSelf);
    
    VehicleUpReportInfoManger *manger = [[VehicleUpReportInfoManger alloc] init];
    manger.param = _param;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf,weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.block(manger.imageModel,manger.param.oldImgId);
            [strongSelf.navigationController popViewControllerAnimated:YES];
            
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}

#pragma mark - buttonAction

- (IBAction)handleBtnShowImageClicked:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    if (_isHaveImage) {
        
        NSMutableArray *t_arr = [NSMutableArray array];
        
        KSPhotoItem *item  = nil;
        
        if (_isChangeImage) {
            item = [KSPhotoItem itemWithSourceView:btn.imageView image:_imageInfo.image];
        }else{
            item = [KSPhotoItem itemWithSourceView:btn.imageView imageUrl:[NSURL URLWithString:_reponse.mediaUrl]];
        }
        
        [t_arr addObject:item];
        
        KSPhotoBrowser *browser     = [KSPhotoBrowser browserWithPhotoItems:t_arr selectedIndex:0];
        [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
        [browser setDelegate:(id<KSPhotoBrowserDelegate> _Nullable)self];
        browser.dismissalStyle      = KSPhotoBrowserInteractiveDismissalStyleScale;
        browser.backgroundStyle     = KSPhotoBrowserBackgroundStyleBlur;
        browser.loadingStyle        = KSPhotoBrowserImageLoadingStyleIndeterminate;
        browser.pageindicatorStyle  = KSPhotoBrowserPageIndicatorStyleText;
        browser.bounces             = NO;
        browser.isShowDeleteBtn     = YES;
        [browser showFromViewController:self];
        
    }else{
        
        WS(weakSelf);
        
        LRCameraVC *home = [[LRCameraVC alloc] init];
        home.type = 5;
        home.isIllegal = NO;
        home.fininshCaptureBlock = ^(LRCameraVC *camera) {
            
            if (camera) {
                
                SW(strongSelf, weakSelf);
                
                if (camera.type == 5) {
                    
                    strongSelf.imageInfo = camera.imageInfo;
                    strongSelf.isHaveImage = YES;
                    strongSelf.isChangeImage = YES;
                    strongSelf.btn_image.imageView.contentMode = UIViewContentModeScaleAspectFill;
                    [strongSelf.btn_image setImage:strongSelf.imageInfo.image forState:UIControlStateNormal];
                    
                    [strongSelf judgeIsCanCommit];
                }
            }
            
        };
        [self presentViewController:home
                           animated:YES
                         completion:^{
                         }];
        
        
    }

}

- (IBAction)handleBtnUpReportInfoClicked:(id)sender{

    [self upReportInfo];
}

#pragma mark - UITextFieldDelegate

-(void)passConTextChange:(id)sender{
    
    UITextField* textField = (UITextField*)sender;
    LxDBAnyVar(textField.text);
    NSInteger length =  textField.text.length;
    if (textField == _tf_info) {
        _param.carriageOutsideH = length > 0 ? _tf_info.text : nil;
    }

    [self judgeIsCanCommit];
   
}

#pragma mark -

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didDeleteItem:(KSPhotoItem *)item{
    
    self.param.oldImgId = _reponse.mediaId;
    self.isHaveImage = NO;
    self.isChangeImage = YES;
    
    
    [self judgeIsCanCommit];
}

#pragma mark -

- (void)judgeIsCanCommit{
    if ((![_tf_info.text isEqualToString:_reponse.carriageOutsideH] && _param.carriageOutsideH.length > 0) || self.isChangeImage == YES) {
        self.isCanCommit = YES;
    }else{
        self.isCanCommit = NO;
    }
    
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"VehicleReportVC dealloc");
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
