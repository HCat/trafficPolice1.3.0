//
//  ElectronicAnnotationView.m
//  移动采集
//
//  Created by hcat-89 on 2020/4/24.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ElectronicAnnotationView.h"
#import "UIImage+Category.h"
#import "ElectronicAnnotation.h"


@interface ElectronicAnnotationView()

@property(nonatomic,strong) UIView *v_back;

@property(nonatomic,strong) UIView *v_action;
@property(nonatomic,strong) UIButton *btn_action;

@property(nonatomic,strong) UIImageView *imgv_action_bg;
@property(nonatomic,strong) UIButton *btn_close;

@property(nonatomic,strong) UIImageView *imgv_icon;

@property(nonatomic,strong) UILabel *lb_name;
@property(nonatomic,strong) UILabel *lb_name_t;
@property(nonatomic,strong) UILabel *lb_type;
@property(nonatomic,strong) UILabel *lb_type_t;
@property(nonatomic,strong) UILabel *lb_use;
@property(nonatomic,strong) UILabel *lb_use_t;

@property(nonatomic,strong)UIImageView * imageView_top;
@property(nonatomic,strong) UILabel * lb_top;

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
    [self.btn_close setFrame:CGRectMake(193, 0, 40, 40)];
    
    
    if (self.imageView_top) {
        [self.imageView_top removeFromSuperview];
    }
    
    self.imageView_top = [[UIImageView alloc] init];
    [self.imageView_top setImage:[UIImage imageNamed:@"electronic_carmera_pre"]];
    [self.imageView_top setFrame:CGRectMake(15, 14, 17, 17)];
    [self.v_action addSubview:self.imageView_top];
    
    if (self.lb_top) {
        [self.lb_top removeFromSuperview];
    }
    
    self.lb_top = [[UILabel alloc] init];
    [self.lb_top setFrame:CGRectMake(15+17+5, 14, 70, 17)];
    self.lb_top.text = @"设备信息";
    self.lb_top.textColor = UIColorFromRGB(0x3396FC);
    self.lb_top.font = [UIFont systemFontOfSize:15];
    [self.v_action addSubview:self.lb_top];
    
    [self lb_name];
    [self lb_type];
    [self lb_use];
    
    CGFloat width = [self getWidthWithTitle:ann.model.cameraName font:[UIFont systemFontOfSize:15]];
    if (width > 160) {
        width = 160;
    }
    
    [self.lb_name_t setFrame:CGRectMake(15+45, 14+17+10, width, 17)];
    self.lb_name_t.text = ann.model.cameraName;
    
    
    
    width = [self getWidthWithTitle:ann.model.cameraType font:[UIFont systemFontOfSize:15]];
    if (width > 90) {
        width = 90;
    }
    
    [self.lb_type_t setFrame:CGRectMake(15+45, 14+17+10+17+10, width, 17)];
    self.lb_type_t.text = ann.model.cameraType;
    
   
    
    [self.btn_showImg setFrame:CGRectMake(15+45+90+10, 14+17+10+17+10-3, 60, 20)];
    

    width = [self getWidthWithTitle:ann.model.usePlace font:[UIFont systemFontOfSize:15]];
    if (width > 160) {
        width = 160;
    }
    
    [self.lb_use_t setFrame:CGRectMake(15+45, 14+17+10+17+10+17+10, width, 17)];
    self.lb_use_t.text = ann.model.usePlace;
   

    self.v_action.frame = CGRectMake(0, 0, 233, 143);

    UIImage * image = [UIImage imageNamed:@"electronic_carmera"];

    image = [image imageChangeColor:[self stringTOColor:ann.model.color]];
    self.imgv_icon.image = image;
    self.imgv_icon.frame = CGRectMake(0, 0, 20, 30);
    self.imgv_icon.contentMode = UIViewContentModeCenter;
    self.imgv_icon.transform = CGAffineTransformMakeRotation([ann.model.rotate floatValue]*M_PI/180);
    frame = CGRectMake(0, 0, 233, 143+30);
    self.imgv_icon.center = CGPointMake(frame.size.width*0.5, 143 + 30/2);
    self.centerOffset = CGPointMake(0, - (143+30)/2 + 30/2);
    
    self.btn_action.center = CGPointMake(frame.size.width*0.5, 143 + 40/2);
    
    
    self.v_back.frame = frame;
    
    

    self.bounds = frame;
    
}


- (UILabel *)lb_name{
    
    if (!_lb_name) {
        _lb_name = [[UILabel alloc] init];
        [_lb_name setFrame:CGRectMake(15, 14+17+10, 45, 17)];
        _lb_name.text = @"名称：";
        _lb_name.textColor = UIColorFromRGB(0x999999);
        _lb_name.font = [UIFont systemFontOfSize:15];
        [self.v_action addSubview:_lb_name];
    }
    
    return _lb_name;
}

- (UILabel *)lb_type{
    
    if (!_lb_type) {
        _lb_type = [[UILabel alloc] init];
        [_lb_type setFrame:CGRectMake(15, 14+17+10+17+10, 45, 17)];
        _lb_type.text = @"类型：";
        _lb_type.textColor = UIColorFromRGB(0x999999);
        _lb_type.font = [UIFont systemFontOfSize:15];
        [self.v_action addSubview:_lb_type];
    }
    
    return _lb_type;
}


- (UILabel *)lb_use{
    
    if (!_lb_use) {
          _lb_use = [[UILabel alloc] init];
          [_lb_use setFrame:CGRectMake(15, 14+17+10+17+10+17+10, 45, 17)];
          _lb_use.text = @"用途：";
          _lb_use.textColor = UIColorFromRGB(0x999999);
          _lb_use.font = [UIFont systemFontOfSize:15];
          [self.v_action addSubview:_lb_use];
    }
    
    return _lb_use;
}





- (UILabel *)lb_name_t{
    
    if (!_lb_name_t) {
        _lb_name_t = [[UILabel alloc] init];
        _lb_name_t.textColor = UIColorFromRGB(0x66666);
        _lb_name_t.font = [UIFont systemFontOfSize:15];
        [self.v_action addSubview:_lb_name_t];
    }
    
    return _lb_name_t;
}


- (UILabel *)lb_type_t{
    
    if (!_lb_type_t) {
        _lb_type_t = [[UILabel alloc] init];
        _lb_type_t.textColor = UIColorFromRGB(0x66666);
        _lb_type_t.font = [UIFont systemFontOfSize:15];
        [self.v_action addSubview:_lb_type_t];
    }
    
    return _lb_type_t;
}



- (UILabel *)lb_use_t{
    
    if (!_lb_use_t) {
        _lb_use_t = [[UILabel alloc] init];
        _lb_use_t.textColor = UIColorFromRGB(0x66666);
        _lb_use_t.font = [UIFont systemFontOfSize:15];
        [self.v_action addSubview:_lb_use_t];
    }
    
    return _lb_use_t;
}







- (UIImageView *)imgv_action_bg{
    
    if (!_imgv_action_bg) {
        _imgv_action_bg = [[UIImageView alloc] init];
        [self.v_action addSubview:_imgv_action_bg];
    }
    
    return _imgv_action_bg;
    
}

- (UIImageView *)imgv_icon{
    if (!_imgv_icon) {
        _imgv_icon = [[UIImageView alloc] init];
        _imgv_icon.frame = CGRectMake(0, 0, 20, 30);
        [_v_back addSubview:_imgv_icon];
    }
    return _imgv_icon;
    
}


- (UIButton *)btn_action{
    
    if (!_btn_action) {
        _btn_action = [[UIButton alloc] init];
        _btn_action.backgroundColor = [UIColor clearColor];
        [_btn_action addTarget:self action:@selector(handleBtnActionClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btn_action.frame = CGRectMake(0, 133, 85, 50);
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

- (CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
    
}


- (UIColor *) stringTOColor:(NSString *)str
{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
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
