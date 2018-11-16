//
//  VehicleCarAnnotationView.m
//  移动采集
//
//  Created by hcat on 2018/5/24.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleCarAnnotationView.h"
#import "VehicleCarAnnotation.h"

@interface VehicleCarAnnotationView()

@property(nonatomic,strong) UIView *v_back;
@property(nonatomic,strong) UIImageView *imgv_icon;
@property(nonatomic,strong) UIImageView *imgv_title_bg;
@property(nonatomic,strong) UILabel *lb_title;
@property(nonatomic,strong) UIButton *btn_action;

@end

@implementation VehicleCarAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    VehicleCarAnnotation *ann = (VehicleCarAnnotation *)annotation;
    self = [super initWithAnnotation:ann reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initializeAnnotation:ann];
    }
    
    return self;
}

- (void)initializeAnnotation:(VehicleCarAnnotation *)ann {
    [self setupAnnotation:ann];
}



- (void)setAnnotation:(id<MAAnnotation>)annotation {
    [super setAnnotation:annotation];
    
    VehicleCarAnnotation *ann = (VehicleCarAnnotation *)self.annotation;
    
    //当annotation滑出地图时候，即ann为nil时，不设置(否则由于枚举的类型会执行不该执行的方法)，只有annotation在地图范围内出现时才设置，可以打断点调试
    if (ann) {
        [self setupAnnotation:ann];
    }
}


- (void)setupAnnotation:(VehicleCarAnnotation *)ann {
    
    CGRect frame = CGRectZero;
    
   
    self.v_back.backgroundColor  = [UIColor clearColor];
   
    NSString *t_str = nil;
    
    if (ann.vehicleCar.selfNo && ann.vehicleCar.selfNo.length > 0) {
        t_str = [NSString stringWithFormat:@"%@%@",ann.vehicleCar.memFormNo,ann.vehicleCar.selfNo];
    }else{
        t_str = ann.vehicleCar.plateNo;
    }

    CGFloat width = [self getWidthWithTitle:t_str font:[UIFont systemFontOfSize:10]];
    width = width + 8;
    frame = CGRectMake(0, 0, width, 60);
    
    
    self.imgv_title_bg.frame =  CGRectMake(0, 0, width, 28);
    UIImage *initialImage = [UIImage imageNamed:@"icon_vehicleCar_info.png"];
    UIImage *rightStretchImage = [initialImage stretchableImageWithLeftCapWidth:initialImage.size.width *0.7 topCapHeight:initialImage.size.height *0.2];
    //拉伸后的宽度=总宽度/2+初始图片宽度/2
    CGFloat stretchWidth =width/2+initialImage.size.width/2;
    //获得右侧拉伸过后的图片
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(stretchWidth, 19), NO, [UIScreen mainScreen].scale);
    [rightStretchImage drawInRect:CGRectMake(0, 0, stretchWidth,  19)];
    UIImage *firstStretchImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //拉伸图片左侧，获得最终图片
    UIImage *finalImage = [firstStretchImage stretchableImageWithLeftCapWidth:initialImage.size.width *0.2 topCapHeight:initialImage.size.height*0.2];

    [self.imgv_title_bg setImage:finalImage];
   
    self.lb_title.text = t_str;
    self.v_back.frame = frame;
    self.lb_title.frame = CGRectMake(0, 0, width, 25);
    
    if ([ann.carType isEqualToNumber:@1]) {
        self.imgv_icon.image = [UIImage imageNamed:@"map_policeCar"];
    }else{
        self.imgv_icon.image = [UIImage imageNamed:@"map_truck"];
    }
    
    self.imgv_icon.center = CGPointMake(frame.size.width*0.5, 30 + (self.bounds.size.height-30)*0.5);

    self.bounds = frame;
    
    self.btn_action.frame = self.bounds;
    
    self.centerOffset = CGPointMake(0, - 30 *0.5);
    
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

- (UILabel *)lb_title{
    if (!_lb_title) {
        _lb_title = [[UILabel alloc] init];
        _lb_title.backgroundColor = [UIColor clearColor];
        _lb_title.textAlignment = NSTextAlignmentCenter;
        _lb_title.textColor = UIColorFromRGB(0xffffff);
        _lb_title.font = [UIFont systemFontOfSize:10];
        [_v_back addSubview:_lb_title];
    }
    return _lb_title;
    
}

- (UIImageView *)imgv_icon{
    if (!_imgv_icon) {
        _imgv_icon = [[UIImageView alloc] init];
        _imgv_icon.frame = CGRectMake(0, 0, 29, 29);
        [_v_back addSubview:_imgv_icon];
    }
    return _imgv_icon;
    
}

- (UIImageView *)imgv_title_bg{
    if (!_imgv_title_bg) {
        _imgv_title_bg = [[UIImageView alloc] init];
        [_v_back addSubview:_imgv_title_bg];
    }
    
    return _imgv_title_bg;
    
}

- (UIButton *)btn_action{
    if (!_btn_action) {
        _btn_action = [[UIButton alloc] init];
        _btn_action.backgroundColor = [UIColor clearColor];
        [_btn_action addTarget:self action:@selector(handleBtnCarClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_v_back addSubview:_btn_action];
    }
    
    return _btn_action;
    
}


- (void)handleBtnCarClicked:(id)sender{
    
    if (self.block) {
        self.block((VehicleCarAnnotation *)self.annotation);
    }
    
}

@end
