//
//  DailyPatrolAnnotationView.m
//  移动采集
//
//  Created by hcat-89 on 2020/4/13.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "DailyPatrolAnnotationView.h"
#import "DailyPatrolAnnotation.h"

#define kDailyMinWidth  20
#define kDailyMaxWidth  200
#define kDailyHeight    44

#define kDailyHoriMargin 3
#define kDailyVertMargin 5

#define kDailyFontSize   12
#define kDailyIconSize   22

#define kDailyArrorHeight 3
#define kDailyArrorWidth  6


@interface DailyPatrolAnnotationView()

@property(nonatomic,strong) UIView *v_back;
@property(nonatomic,strong) UIView *v_action;
@property(nonatomic,strong) UIImageView *imgv_icon;
@property(nonatomic,strong) UIImageView *imgv_title_bg;
@property(nonatomic,strong) UILabel *lb_title;
@property(nonatomic,strong) UIButton *btn_action;

@property(nonatomic,strong) UIButton *btn_signIn;
@property(nonatomic,strong) UIButton *btn_cancel;
@property(nonatomic,assign) BOOL isShowed;

@end


@implementation DailyPatrolAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    DailyPatrolAnnotation *ann = (DailyPatrolAnnotation *)annotation;
    self = [super initWithAnnotation:ann reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initializeAnnotation:ann];
    }
    
    return self;
}

- (void)initializeAnnotation:(DailyPatrolAnnotation *)ann {
    [self setupAnnotation:ann];
}



- (void)setAnnotation:(id<MAAnnotation>)annotation {
    [super setAnnotation:annotation];
    
    DailyPatrolAnnotation *ann = (DailyPatrolAnnotation *)self.annotation;
    
    //当annotation滑出地图时候，即ann为nil时，不设置(否则由于枚举的类型会执行不该执行的方法)，只有annotation在地图范围内出现时才设置，可以打断点调试
    if (ann) {
        [self setupAnnotation:ann];
    }
}


- (void)setupAnnotation:(DailyPatrolAnnotation *)ann {
    
    CGRect frame = CGRectZero;
    
    self.isShowed = NO;
    self.v_back.backgroundColor  = [UIColor clearColor];
    
    if ([ann.type isEqualToNumber:@1]) {
        //站岗
        
        self.btn_action.enabled = YES;
        self.lb_title.hidden = YES;
        
        [self.imgv_title_bg setImage:[UIImage imageNamed:@"icon_dailyPatrol_info"]];
        [self.imgv_title_bg setFrame:CGRectMake(0, 0, 232, 82)];
        [self.btn_cancel setFrame:CGRectMake(13, 13, 95, 39)];
        [self.btn_signIn setFrame:CGRectMake(114.5, 13, 95, 39)];
        
        self.v_action.frame = CGRectMake(0, 0, 232, 82);
        
        
        self.imgv_icon.frame = CGRectMake(0, 0, 23, 23);
        frame = CGRectMake(0, 0, 232, 82+23);
        self.imgv_icon.center = CGPointMake(frame.size.width*0.5, 82 + 23/2);
        self.centerOffset = CGPointMake(0, - (82+23)/2 + 23/2);
        
        self.v_back.frame = frame;
        
        if ([ann.model.pointType isEqualToNumber:@2]) {
            //未到岗状态
           [self.btn_signIn setTitle:@"到岗" forState:UIControlStateNormal];
           self.imgv_icon.image = [UIImage imageNamed:@"icon_dailyPatrol_unSignIn"];
            
        }else if([ann.model.pointType isEqualToNumber:@0]){
            //到岗状态
            self.imgv_icon.image = [UIImage imageNamed:@"icon_dailyPatrol_signIn"];
            [self.btn_signIn setTitle:@"离岗" forState:UIControlStateNormal];
        }else{
            //离岗状态
            [self.btn_signIn setTitle:@"已离岗" forState:UIControlStateNormal];
            self.imgv_icon.image = [UIImage imageNamed:@"icon_dailyPatrol_unSignIn"];
        }
        
    }else{
        //巡逻
        if ([ann.model.status isEqualToNumber:@0]) {
            
            self.btn_action.enabled = YES;
            self.lb_title.hidden = YES;
            
            [self.imgv_title_bg setImage:[UIImage imageNamed:@"icon_dailyPatrol_info"]];
            [self.imgv_title_bg setFrame:CGRectMake(0, 0, 232, 82)];
            [self.btn_cancel setFrame:CGRectMake(13, 13, 95, 39)];
            [self.btn_signIn setFrame:CGRectMake(114.5, 13, 95, 39)];
            
            self.v_action.frame = CGRectMake(0, 0, 232, 82);
            
            self.imgv_icon.image = [UIImage imageNamed:@"icon_dailyPatrol_unSignIn"];
            self.imgv_icon.frame = CGRectMake(0, 0, 23, 23);
            frame = CGRectMake(0, 0, 232, 82+23);
            self.imgv_icon.center = CGPointMake(frame.size.width*0.5, 82 + 23/2);
            self.centerOffset = CGPointMake(0, - (82+23)/2 + 23/2);
            
            self.v_back.frame = frame;
            
        }else{
            
            self.btn_action.enabled = NO;
            self.lb_title.hidden = NO;
            
            //NSString *t_str = [ShareFun timeWithTimeInterval:ann.model.signTime];
            CGFloat width = [self getWidthWithTitle:ann.model.signTime font:[UIFont systemFontOfSize:10]];
            width = width + 8;
            self.lb_title.frame = CGRectMake(0, 0, width, 30);
            self.lb_title.text = ann.model.signTime;
            
            self.imgv_icon.image = [UIImage imageNamed:@"icon_dailyPatrol_signIn"];
            self.imgv_icon.frame = CGRectMake(0, 0, 23, 23);
            frame = CGRectMake(0, 0, width, 30+23);
            self.imgv_icon.center = CGPointMake(frame.size.width*0.5, 30 + 23/2);
            self.centerOffset = CGPointMake(0, - (30+23)/2 + 23/2);
        
            self.v_back.frame = frame;
            
        }
        
    }
    
    self.bounds = frame;
    
    //self.btn_action.frame = self.bounds;
    

}

- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
    
}

- (UIView *)v_back {
    if (!_v_back) {
        _v_back = [[UIView alloc] init];
        [self addSubview:_v_back];
    }
    return _v_back;
}

- (UIView *)v_action {
    if (!_v_action) {
        _v_action = [[UIView alloc] init];
        [self.v_back addSubview:_v_action];
    }
    return _v_action;
}

- (UILabel *)lb_title{
    if (!_lb_title) {
        _lb_title = [[UILabel alloc] init];
        _lb_title.backgroundColor = [UIColor whiteColor];
        _lb_title.layer.cornerRadius = 5.0f;
        _lb_title.layer.masksToBounds = YES;
        _lb_title.textAlignment = NSTextAlignmentCenter;
        _lb_title.textColor = UIColorFromRGB(0x333333);
        _lb_title.font = [UIFont systemFontOfSize:10];
        [_v_back addSubview:_lb_title];
    }
    return _lb_title;
    
}

- (UIImageView *)imgv_icon{
    if (!_imgv_icon) {
        _imgv_icon = [[UIImageView alloc] init];
        _imgv_icon.frame = CGRectMake(0, 0, 23, 23);
        [_v_back addSubview:_imgv_icon];
    }
    return _imgv_icon;
    
}

- (UIImageView *)imgv_title_bg{
    if (!_imgv_title_bg) {
        _imgv_title_bg = [[UIImageView alloc] init];
        [self.v_action addSubview:_imgv_title_bg];
    }
    
    return _imgv_title_bg;
    
}

- (UIButton *)btn_action{
    if (!_btn_action) {
        _btn_action = [[UIButton alloc] init];
        _btn_action.backgroundColor = [UIColor clearColor];
        [_btn_action addTarget:self action:@selector(handleBtnActionClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.btn_action.frame = CGRectMake(0, 62, 232, 40);
        [self.v_back addSubview:_btn_action];
    }
    
    return _btn_action;
    
}


- (UIButton *)btn_cancel{
    if (!_btn_cancel) {
        _btn_cancel = [[UIButton alloc] init];
        _btn_cancel.backgroundColor = UIColorFromRGB(0xE5E5E5);
        [_btn_cancel setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [_btn_cancel setTitle:@"取消" forState:UIControlStateNormal];
        _btn_cancel.layer.cornerRadius = 39.0/2;
        [_btn_cancel addTarget:self action:@selector(handleBtnCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.v_action addSubview:_btn_cancel];
    }
    
    return _btn_cancel;
    
}


- (UIButton *)btn_signIn{
    if (!_btn_signIn) {
        _btn_signIn = [[UIButton alloc] init];
        _btn_signIn.backgroundColor = UIColorFromRGB(0x3396FC);
        [_btn_signIn setTitle:@"签到" forState:UIControlStateNormal];
        [_btn_signIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn_signIn.layer.cornerRadius = 39.0/2;
        [_btn_signIn addTarget:self action:@selector(handleBtnSignInClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.v_action addSubview:_btn_signIn];
    }
    
    return _btn_signIn;
    
}

- (void)setIsShowed:(BOOL)isShowed{
    
    if (isShowed) {
        self.v_action.hidden = NO;
    }else{
        self.v_action.hidden = YES;
    }
    
}

- (void)handleBtnActionClicked:(id)sender{
    
    self.isShowed = YES;

}

- (void)handleBtnCancelClicked:(id)sender{
    self.isShowed = NO;

}



- (void)handleBtnSignInClicked:(id)sender{
    
    if (self.block) {
        self.block((DailyPatrolAnnotation *)self.annotation);
    }
    
}


@end
