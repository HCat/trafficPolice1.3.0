//
//  ElectronicAnnotationView.m
//  移动采集
//
//  Created by hcat-89 on 2020/4/24.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ElectronicAnnotationView.h"
#import "UIImage+Category.h"


@interface ElectronicAnnotationView()

@property(nonatomic,strong) UIView *v_back;

@property(nonatomic,strong) UIView *v_action;
@property(nonatomic,strong) UIButton *btn_action;

@property(nonatomic,strong) UIImageView *imgv_action_bg;
@property(nonatomic,strong) UIButton *btn_close;

@property(nonatomic,strong) UIImageView *imgv_icon;



@property(nonatomic,strong) UIButton *btn_showImg;


@property(nonatomic,assign) BOOL isShowed;

@end


@implementation ElectronicAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    ElectronicAnnotation *ann = (ElectronicAnnotation *)annotation;
    self = [super initWithAnnotation:ann reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initializeAnnotation:ann];
    }
    
    return self;
}

- (void)initializeAnnotation:(ElectronicAnnotation *)ann {
    [self setupAnnotation:ann];
}



- (void)setAnnotation:(id<MAAnnotation>)annotation {
    [super setAnnotation:annotation];
    
    ElectronicAnnotation *ann = (ElectronicAnnotation *)self.annotation;
    
    //当annotation滑出地图时候，即ann为nil时，不设置(否则由于枚举的类型会执行不该执行的方法)，只有annotation在地图范围内出现时才设置，可以打断点调试
    if (ann) {
        [self setupAnnotation:ann];
    }
}


- (void)setupAnnotation:(ElectronicAnnotation *)ann {
    
    CGRect frame = CGRectZero;
    
    self.isShowed = NO;
    self.v_back.backgroundColor  = [UIColor clearColor];

    [self.imgv_action_bg setImage:[UIImage imageNamed:@"electronic_bg"]];
    [self.imgv_action_bg setFrame:CGRectMake(0, 0, 233, 143)];
    [self.btn_close setFrame:CGRectMake(13, 13, 40, 40)];
    [self.btn_showImg setFrame:CGRectMake(32, 33, 60, 20)];
    
    self.v_action.frame = CGRectMake(0, 0, 233, 143);
    
    UIImage * image = [UIImage imageNamed:@"electronic_carmera"];
    
    
    self.imgv_icon.image = image;
    self.imgv_icon.frame = CGRectMake(0, 0, 20, 30);
    frame = CGRectMake(0, 0, 233, 143+30);
    self.imgv_icon.center = CGPointMake(frame.size.width*0.5, 143 + 30/2);
    self.centerOffset = CGPointMake(0, - (143+30)/2 + 30/2);
    
    self.v_back.frame = frame;

    self.bounds = frame;
    
}

- (UIImageView *)imgv_action_bg{
    
    if (!_imgv_action_bg) {
        _imgv_action_bg = [[UIImageView alloc] init];
        [self.v_action addSubview:_imgv_action_bg];
    }
    
    return _imgv_action_bg;
    
}

- (UIButton *)btn_action{
    
    if (!_btn_action) {
        _btn_action = [[UIButton alloc] init];
        _btn_action.backgroundColor = [UIColor clearColor];
        [_btn_action addTarget:self action:@selector(handleBtnActionClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_action.frame = CGRectMake(0, 143, 233, 40);
        [self.v_back addSubview:_btn_action];
    }
    
    return _btn_action;
    
}


- (UIButton *)btn_close{
    if (!_btn_close) {
        _btn_close = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_btn_close setImage:[UIImage imageNamed:@"electronic_close"] forState:UIControlStateNormal];
        [_btn_close addTarget:self action:@selector(handleBtnCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.v_action addSubview:_btn_close];
    }
    
    return _btn_close;
    
}


- (UIButton *)btn_showImg{
    if (!_btn_showImg) {
        _btn_showImg = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        _btn_showImg.backgroundColor = [UIColor whiteColor];
        [_btn_showImg setTitle:@"查看图片" forState:UIControlStateNormal];
        [_btn_showImg setTitleColor:UIColorFromRGB(0x3396FC) forState:UIControlStateNormal];
        _btn_showImg.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        _btn_showImg.layer.cornerRadius = 20.0/2;
        _btn_showImg.layer.borderColor = UIColorFromRGB(0x3396FC).CGColor;
        _btn_showImg.layer.borderWidth = 1.0;
        _btn_showImg.layer.masksToBounds = YES;
        [_btn_showImg addTarget:self action:@selector(handleBtnShowImgClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.v_action addSubview:_btn_showImg];
    }
    
    return _btn_showImg;
    
}

- (void)setIsShowed:(BOOL)isShowed{
    
    if (isShowed) {
        self.v_action.hidden = NO;
    }else{
        self.v_action.hidden = YES;
    }
    
}

#pragma mark - button Action

- (void)handleBtnActionClicked:(id)sender{
    self.isShowed = YES;
}

- (void)handleBtnCancelClicked:(id)sender{
    self.isShowed = NO;
}

- (void)handleBtnShowImgClicked:(id)sender{
    
    if (self.block) {
        self.block((ElectronicAnnotation *)self.annotation);
    }
    
}

- (void)dealloc{
    LxPrintf(@"%@-dealloc",[self class]);
}


@end
