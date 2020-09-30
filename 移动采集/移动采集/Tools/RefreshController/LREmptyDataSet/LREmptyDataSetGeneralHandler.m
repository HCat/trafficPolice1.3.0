//
//  LREmptyDataSetGeneralHandler.m
//  框架
//
//  Created by hcat on 2019/11/20.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "LREmptyDataSetGeneralHandler.h"

@interface LREmptyDataSetGeneralHandler()

@property (nonatomic, strong) NSMutableDictionary   *titles;
@property (nonatomic, strong) NSMutableDictionary   *descriptions;
@property (nonatomic, strong) NSMutableDictionary   *images;
@property (nonatomic, strong) NSMutableDictionary   *imageTintColors;
@property (nonatomic, strong) NSMutableDictionary   *imageAnimations;
@property (nonatomic, strong) NSMutableDictionary   *buttonTitles;
@property (nonatomic, strong) NSMutableDictionary   *buttonImages;
@property (nonatomic, strong) NSMutableDictionary   *buttonBackgroundImages;
@property (nonatomic, strong) NSMutableDictionary   *backgroundColors;
@property (nonatomic, strong) NSMutableDictionary   *customViews;
@property (nonatomic, strong) NSMutableDictionary   *verticalOffsets;
@property (nonatomic, strong) NSMutableDictionary   *spaceHeights;

@property (nonatomic, strong) NSMutableDictionary   *fadeInSet;
@property (nonatomic, strong) NSMutableDictionary   *displaySet;
@property (nonatomic, strong) NSMutableDictionary   *forcedToDisplaySet;
@property (nonatomic, strong) NSMutableDictionary   *touchableSet;
@property (nonatomic, strong) NSMutableDictionary   *scrollableSet;
@property (nonatomic, strong) NSMutableDictionary   *animateSet;
@property (nonatomic, strong) NSMutableDictionary   *tapButtonHandlers;
@property (nonatomic, strong) NSMutableDictionary   *tapViewHandlers;

@property (nonatomic, strong) NSMutableDictionary   *titleFonts;
@property (nonatomic, strong) NSMutableDictionary   *titleColors;
@property (nonatomic, strong) NSMutableDictionary   *descriptionFonts;
@property (nonatomic, strong) NSMutableDictionary   *descriptionColors;
@property (nonatomic, strong) NSMutableDictionary   *buttonTitleFonts;
@property (nonatomic, strong) NSMutableDictionary   *buttonTitleColors;

@end


@implementation LREmptyDataSetGeneralHandler

- (void)configure{
    [super configure];
    
    //初始化
    self.titles = [NSMutableDictionary dictionary];
    self.descriptions = [NSMutableDictionary dictionary];
    self.images = [NSMutableDictionary dictionary];
    self.imageTintColors = [NSMutableDictionary dictionary];
    self.imageAnimations = [NSMutableDictionary dictionary];
    self.buttonTitles = [NSMutableDictionary dictionary];
    self.buttonImages = [NSMutableDictionary dictionary];
    self.buttonBackgroundImages = [NSMutableDictionary dictionary];
    self.backgroundColors = [NSMutableDictionary dictionary];
    self.customViews = [NSMutableDictionary dictionary];
    self.verticalOffsets = [NSMutableDictionary dictionary];
    self.spaceHeights = [NSMutableDictionary dictionary];
    
    self.fadeInSet = [NSMutableDictionary dictionary];
    self.displaySet = [NSMutableDictionary dictionary];
    self.forcedToDisplaySet = [NSMutableDictionary dictionary];
    self.touchableSet = [NSMutableDictionary dictionary];
    self.scrollableSet = [NSMutableDictionary dictionary];
    self.animateSet = [NSMutableDictionary dictionary];
    self.tapButtonHandlers = [NSMutableDictionary dictionary];
    self.tapViewHandlers = [NSMutableDictionary dictionary];
    
    self.titleFonts = [NSMutableDictionary dictionary];
    self.titleColors = [NSMutableDictionary dictionary];
    self.descriptionFonts = [NSMutableDictionary dictionary];
    self.descriptionColors = [NSMutableDictionary dictionary];
    self.buttonTitleFonts = [NSMutableDictionary dictionary];
    self.buttonTitleColors = [NSMutableDictionary dictionary];
    
    //设置默认值
    self.fadeIn = YES;
    self.display = YES;
    self.forcedToDisplay = NO;
    self.touchable = YES;
    self.scrollable = YES;
    self.animate = NO;
    
}

#pragma mark - Public

- (void)setTitle:(NSString *)title forState:(LRDataLoadState)state{
    if (!title) {
        [self setObject:nil inDictionary:self.titles forState:state];
        return;
    }
    
    NSAttributedString * string = [self attributedStringWithString:title useFonts:self.titleFonts andColors:self.titleColors forState:state];
    
    [self setObject:string inDictionary:self.titles forState:state];
    
}

- (void)setAttributedTitle:(NSAttributedString *)title forState:(LRDataLoadState)state {
    [self setObject:title inDictionary:self.titles forState:state];
}


- (void)setDescription:(NSString *)description forState:(LRDataLoadState)state {
    if (!description) {
        [self setObject:nil inDictionary:self.descriptions forState:state];
    }
    NSAttributedString *string = [self attributedStringWithString:description useFonts:self.descriptionFonts andColors:self.descriptionColors forState:state];
    [self setObject:string inDictionary:self.descriptions forState:state];
}

- (void)setAttributedDescription:(NSAttributedString *)description forState:(LRDataLoadState)state {
    [self setObject:description inDictionary:self.descriptions forState:state];
}

- (void)setImage:(UIImage *)image forState:(LRDataLoadState)state {
    [self setObject:image inDictionary:self.images forState:state];
}

- (void)setImageTintColor:(UIColor *)color forState:(LRDataLoadState)state {
    [self setObject:color inDictionary:self.imageTintColors forState:state];
}

- (void)setImageAnimation:(CAAnimation *)animation forState:(LRDataLoadState)state {
    [self setObject:animation inDictionary:self.imageAnimations forState:state];
}

- (void)setButtonTitle:(NSString *)title controlState:(UIControlState)cState forState:(LRDataLoadState)state {
    if (!title) {
        [self setObject:nil inDictionary:self.buttonTitles forState:state];
        return;
    }
    NSAttributedString *string = [self attributedStringWithString:title useFonts:self.buttonTitleFonts andColors:self.buttonTitleColors forState:state];
    [self setObject:string forControlState:cState inDictionary:self.buttonTitles forState:state];
}

- (void)setAttributedButtonTitle:(NSAttributedString *)title controlState:(UIControlState)cState forState:(LRDataLoadState)state {
    [self setObject:title forControlState:cState inDictionary:self.buttonTitles forState:state];
}

- (void)setButtonImage:(UIImage *)image controlState:(UIControlState)cState forState:(LRDataLoadState)state {
    [self setObject:image forControlState:cState inDictionary:self.buttonImages forState:state];
}

- (void)setButtonBackgroundImage:(UIImage *)image controlState:(UIControlState)cState forState:(LRDataLoadState)state {
    [self setObject:image forControlState:cState inDictionary:self.buttonBackgroundImages forState:state];
}

- (void)setBackgroundColor:(UIColor *)color forState:(LRDataLoadState)state {
    [self setObject:color inDictionary:self.backgroundColors forState:state];
}

- (void)setCustomView:(UIView *)view forState:(LRDataLoadState)state {
    [self setObject:view inDictionary:self.customViews forState:state];
}

- (void)setVerticalOffset:(CGFloat)offset forState:(LRDataLoadState)state {
    [self setObject:@(offset) inDictionary:self.verticalOffsets forState:state];
}

- (void)setSpaceHeight:(CGFloat)space forState:(LRDataLoadState)state {
    [self setObject:@(space) inDictionary:self.spaceHeights forState:state];
}

- (void)setFadeIn:(BOOL)fadeIn forState:(LRDataLoadState)state {
    [self setObject:@(fadeIn) inDictionary:self.fadeInSet forState:state];
}

- (void)setDisplay:(BOOL)display forState:(LRDataLoadState)state {
    [self setObject:@(display) inDictionary:self.displaySet forState:state];
}

- (void)setForcedToDisplay:(BOOL)forcedToDisplay forState:(LRDataLoadState)state {
    [self setObject:@(forcedToDisplay) inDictionary:self.forcedToDisplaySet forState:state];
}

- (void)setTouchable:(BOOL)touchable forState:(LRDataLoadState)state {
    [self setObject:@(touchable) inDictionary:self.touchableSet forState:state];
}

- (void)setScrollable:(BOOL)scrollable forState:(LRDataLoadState)state {
    [self setObject:@(scrollable) inDictionary:self.scrollableSet forState:state];
}

- (void)setAnimate:(BOOL)animate forState:(LRDataLoadState)state {
    [self setObject:@(animate) inDictionary:self.animateSet forState:state];
}

- (void)setTapButtonHandler:(void (^)(UIButton *))tapButtonHandler forState:(LRDataLoadState)state {
    [self setObject:tapButtonHandler inDictionary:self.tapButtonHandlers forState:state];
}

- (void)setTapViewHandler:(void (^)(UIView *))tapViewHandler forState:(LRDataLoadState)state {
    [self setObject:tapViewHandler inDictionary:self.tapViewHandlers forState:state];
}
#pragma mark - Setter
- (void)setFadeIn:(BOOL)fadeIn {
    _fadeIn = fadeIn;
    [self setFadeIn:fadeIn forState:LRDataLoadStateAll];
}

- (void)setDisplay:(BOOL)display {
    _display = display;
    [self setDisplay:display forState:LRDataLoadStateAll];
}

- (void)setForcedToDisplay:(BOOL)forcedToDisplay {
    _forcedToDisplay = forcedToDisplay;
    [self setForcedToDisplay:forcedToDisplay forState:LRDataLoadStateAll];
}

- (void)setTouchable:(BOOL)touchable {
    _touchable = touchable;
    [self setTouchable:touchable forState:LRDataLoadStateAll];
}

- (void)setScrollable:(BOOL)scrollable {
    _scrollable = scrollable;
    [self setScrollable:scrollable forState:LRDataLoadStateAll];
}

- (void)setAnimate:(BOOL)animate {
    _animate = animate;
    [self setAnimate:animate forState:LRDataLoadStateAll];
}

- (void)setTapButtonHandler:(void (^)(UIButton *))tapButtonHandler {
    _tapButtonHandler = tapButtonHandler;
    [self setTapButtonHandler:tapButtonHandler forState:LRDataLoadStateAll];
}

- (void)setTapViewHandler:(void (^)(UIView *))tapViewHandler {
    _tapViewHandler = tapViewHandler;
    [self setTapViewHandler:tapViewHandler forState:LRDataLoadStateAll];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    [self setObject:titleFont inDictionary:self.titleFonts forState:LRDataLoadStateAll];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self setObject:titleColor inDictionary:self.titleColors forState:LRDataLoadStateAll];
}

- (void)setDescriptionFont:(UIFont *)descriptionFont {
    _descriptionFont = descriptionFont;
    [self setObject:descriptionFont inDictionary:self.descriptionFonts forState:LRDataLoadStateAll];
}

- (void)setDescriptionColor:(UIColor *)descriptionColor {
    _descriptionColor = descriptionColor;
    [self setObject:descriptionColor inDictionary:self.descriptionColors forState:LRDataLoadStateAll];
}

- (void)setButtonTitleFont:(UIFont *)buttonTitleFont {
    _buttonTitleFont = buttonTitleFont;
    [self setObject:buttonTitleFont inDictionary:self.buttonTitleFonts forState:LRDataLoadStateAll];
}

- (void)setButtonTitleColor:(UIColor *)buttonTitleColor {
    _buttonTitleColor = buttonTitleColor;
    [self setObject:buttonTitleColor inDictionary:self.buttonTitleColors forState:LRDataLoadStateAll];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self setObject:backgroundColor inDictionary:self.backgroundColors forState:LRDataLoadStateAll];
}

- (void)setVerticalOffset:(CGFloat)verticalOffset {
    _verticalOffset = verticalOffset;
    [self setObject:@(verticalOffset) inDictionary:self.verticalOffsets forState:LRDataLoadStateAll];
}

- (void)setSpaceHeight:(CGFloat)spaceHeight {
    _spaceHeight = spaceHeight;
    [self setObject:@(spaceHeight) inDictionary:self.spaceHeights forState:LRDataLoadStateAll];
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [self availableObjectInDictionary:self.titles];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return [self availableObjectInDictionary:self.descriptions];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [self availableObjectInDictionary:self.images];
}

- (UIColor *)imageTintColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [self availableObjectInDictionary:self.imageTintColors];
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
    return [self availableObjectInDictionary:self.imageAnimations];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSDictionary *dict = [self availableObjectInDictionary:self.buttonTitles];
    return dict ? dict[@(state)] : nil;
}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSDictionary *dict = [self availableObjectInDictionary:self.buttonImages];
    return dict ? dict[@(state)] : nil;
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSDictionary *dict = [self availableObjectInDictionary:self.buttonBackgroundImages];
    return dict ? dict[@(state)] : nil;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [self availableObjectInDictionary:self.backgroundColors];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    return [self availableObjectInDictionary:self.customViews];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    NSNumber *value = [self availableObjectInDictionary:self.verticalOffsets];
    return value ? [value floatValue] : 0;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    NSNumber *value = [self availableObjectInDictionary:self.spaceHeights];
    return value ? [value floatValue] : 0;
}

#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldFadeIn:(UIScrollView *)scrollView {
    return [[self availableObjectInDictionary:self.fadeInSet] boolValue];
}

- (BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView {
    return [[self availableObjectInDictionary:self.forcedToDisplaySet] boolValue];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return [[self availableObjectInDictionary:self.displaySet] boolValue];
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return [[self availableObjectInDictionary:self.touchableSet] boolValue];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return [[self availableObjectInDictionary:self.scrollableSet] boolValue];
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView {
    return [[self availableObjectInDictionary:self.animateSet] boolValue];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    void (^handler)(UIView *view) = [self availableObjectInDictionary:self.tapViewHandlers];
    if (handler) {
        handler(view);
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    void (^handler)(UIView *view) = [self availableObjectInDictionary:self.tapButtonHandlers];
    if (handler) {
        handler(button);
    }
}

- (void)emptyDataSetDidAppear:(UIScrollView *)scrollView{
    CGRect frame   = scrollView.frame;
    frame.origin.y = 0;
    UIView *view = scrollView.emptyDataSetView;
    if (view) {
         view.frame  = frame;
    }
}


#pragma mark - Private

//设置各个状态下Dictionary中的object

- (void)setObject:(id)object inDictionary:(NSMutableDictionary *)dictionary forState:(LRDataLoadState)state {
    if (state & LRDataLoadStateIdle) {
        dictionary[@(LRDataLoadStateIdle)] = object;
    }
    if (state & LRDataLoadStateLoading) {
        dictionary[@(LRDataLoadStateLoading)] = object;
    }
    if (state & LRDataLoadStateEmpty) {
        dictionary[@(LRDataLoadStateEmpty)] = object;
    }
    if (state & LRDataLoadStateFailed) {
        dictionary[@(LRDataLoadStateFailed)] = object;
    }
}

//获取各个状态下Dictionary中的object

- (id)availableObjectInDictionary:(NSDictionary *)dictionary forState:(LRDataLoadState)state {
    for (NSNumber *key in [dictionary allKeys]) {
        NSUInteger option = [key unsignedIntegerValue];
        if (option & state) {
            return dictionary[key];
        }
    }
    return nil;
}

- (id)availableObjectInDictionary:(NSDictionary *)dictionary {
    return [self availableObjectInDictionary:dictionary forState:self.state];
}



- (void)setObject:(id)object forControlState:(UIControlState)cState inDictionary:(NSMutableDictionary *)dictionary forState:(LRDataLoadState)state {
    if (state & LRDataLoadStateIdle) {
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        NSDictionary *oldDict = [self availableObjectInDictionary:dictionary forState:LRDataLoadStateIdle];
        if (oldDict) {
            [newDict addEntriesFromDictionary:oldDict];
        }
        newDict[@(cState)] = object;
        dictionary[@(LRDataLoadStateIdle)] = newDict;
    }
    if (state & LRDataLoadStateLoading) {
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        NSDictionary *oldDict = [self availableObjectInDictionary:dictionary forState:LRDataLoadStateLoading];
        if (oldDict) {
            [newDict addEntriesFromDictionary:oldDict];
        }
        newDict[@(cState)] = object;
        dictionary[@(LRDataLoadStateLoading)] = newDict;
    }
    if (state & LRDataLoadStateEmpty) {
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        NSDictionary *oldDict = [self availableObjectInDictionary:dictionary forState:LRDataLoadStateEmpty];
        if (oldDict) {
            [newDict addEntriesFromDictionary:oldDict];
        }
        newDict[@(cState)] = object;
        dictionary[@(LRDataLoadStateEmpty)] = newDict;
    }
    if (state & LRDataLoadStateFailed) {
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        NSDictionary *oldDict = [self availableObjectInDictionary:dictionary forState:LRDataLoadStateFailed];
        if (oldDict) {
            [newDict addEntriesFromDictionary:oldDict];
        }
        newDict[@(cState)] = object;
        dictionary[@(LRDataLoadStateFailed)] = newDict;
    }
    
}


// NSString 转换 NSAttributedString

- (NSAttributedString *)attributedStringWithString:(NSString *)string useFonts:(NSDictionary *)fonts andColors:(NSDictionary *)colors forState:(LRDataLoadState)state {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    UIFont *font = [self availableObjectInDictionary:fonts forState:state];
    UIColor *color = [self availableObjectInDictionary:colors forState:state];
    if (font) {
        [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedString.length)];
    }
    if (color) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attributedString.length)];
    }
    
    return attributedString;
}




@end
