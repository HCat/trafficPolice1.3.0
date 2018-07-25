//
//  LRSliderView.m
//  LRSliderViewDemo
//
//  Created by hcat on 2018/7/13.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "LRSliderView.h"
#import "SliderTitleCell.h"

#import <Masonry.h>


typedef NS_ENUM(NSUInteger,CollectionViewType){
    
    CollectionViewTypeTitle = 0,
    CollectionViewTypeContent = 1

};



@interface LRSliderView()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout>

//当前页面索引
@property (nonatomic, assign, readwrite) NSInteger currentIndex;

//标题视图
@property (nonatomic, strong) UICollectionView *titleCollectionView;

//内容视图
@property (nonatomic, strong) UICollectionView *contentCollectionView;

//标题底部滚动条
@property (nonatomic, strong) UIView *sliderLine;

//标题数组
@property (nonatomic, strong) NSMutableArray *buttonArray;

//标题文字宽度存储
@property (nonatomic, strong) NSMutableDictionary *titleWidthCache;

//用于保存选择状态
@property (nonatomic, strong) NSMutableDictionary *statusDic;

//用于判断是否是第一次初始化
@property (nonatomic, assign) BOOL firstLoading;

@end

@implementation LRSliderView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self.titleCollectionView registerClass:[SliderTitleCell class] forCellWithReuseIdentifier:@"SliderTitleCell"];
        [self.contentCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"SliderContentCell"];
        NSAssert([LRSliderViewConfig sharedConfig].scaleSize >= 1, @"LRSliderView -- Title放大倍数需要不小于1的值");
        self.firstLoading = YES;
    }
    return self;
}


#pragma mark - instance methods

- (void)reloadData{
    
    [self.titleCollectionView reloadData];
    [self.contentCollectionView reloadData];
    self.buttonArray = nil;
    self.titleWidthCache = nil;
    self.statusDic = nil;
}


- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self manageButtonStatus:indexPath.item];
    [self.contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
    [self.titleCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    [self updateSliderLineAtIndexValue:self.currentIndex ToNewIndexValue:index];
    [self.titleCollectionView reloadData];
    self.currentIndex = indexPath.item;
    
}

#pragma mark - UICollectionViewDelegate & DataSource


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.delegate numberOfItemsInSliderView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewType type = collectionView.tag;
    switch (type) {
        case CollectionViewTypeTitle: {
            SliderTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SliderTitleCell" forIndexPath:indexPath];
            
            BOOL isSelected = [[self.statusDic objectForKey:[NSNumber numberWithInteger:indexPath.row]] boolValue];
            [cell bindStyleButton:self.buttonArray[indexPath.row] status:isSelected];
        
            return cell;
        }
        case CollectionViewTypeContent: {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SliderContentCell" forIndexPath:indexPath];
            while (cell.contentView.subviews.count) {
                [cell.contentView.subviews.lastObject removeFromSuperview];
            }
            
            UIView *view = [self.delegate sliderView:self viewForItemAtIndex:indexPath.row];
            [cell.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
        
            
            return cell;
        }
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewType type = collectionView.tag;
    if (type == CollectionViewTypeTitle) {
        
        [self.contentCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [self.titleCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self updateSliderLinePosition:indexPath.item];
        [self.titleCollectionView reloadData];
        self.currentIndex = indexPath.item;
        [self manageButtonStatus:indexPath.item];
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.titleCollectionView) {
        NSInteger totalNum = [self.delegate numberOfItemsInSliderView:self];
        CGFloat width = 0;
        if ( totalNum <= [LRSliderViewConfig sharedConfig].maxCountInScreen) {
            width = self.frame.size.width / totalNum;
        } else {
            width = self.frame.size.width / [LRSliderViewConfig sharedConfig].maxCountInScreen;
        }
        CGFloat calcWidth = [self calculateItemWithAtIndex:indexPath.row] + 30;//加上左右各15的边距
        if (calcWidth > width) {
            width = calcWidth;
        }
        return CGSizeMake(width, [LRSliderViewConfig sharedConfig].topViewHeight);
    } else {
        return CGSizeMake(self.frame.size.width, self.frame.size.height - [LRSliderViewConfig sharedConfig].topViewHeight);
    }
}

#pragma mark - UIScrollViewDelegate

/**
 *  滚动完毕就会调用（如果不是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
 */

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (scrollView.tag == CollectionViewTypeContent) {
        
        NSInteger index = (NSInteger)(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
        self.currentIndex = index;
        [self.titleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self manageButtonStatus:index];
        [self.titleCollectionView reloadData];
    }
    
}

/**
 *  滚动完毕就会调用（如果是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.tag == CollectionViewTypeContent) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.tag == CollectionViewTypeContent) {
        CGFloat indexValue = (CGFloat)(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
        CGFloat currentIndexValue = 0.00;
        if (indexValue > self.currentIndex) {
            //向右移动时候，向下取整，取出当前页的最左初点
            currentIndexValue = floor(indexValue);
        } else {
            //向右移动时候，向上取整，取出当前页的最左初点
            currentIndexValue = ceil(indexValue);
        }
        NSLog(@"%f",currentIndexValue);
        
        [self updateSliderLineAtIndexValue:currentIndexValue ToNewIndexValue:indexValue];
        [self updateLabelInCellAtIndexValue:currentIndexValue ToNewIndexValue:indexValue];
    }
    
}

#pragma mark - Actions

//计算title宽度
- (CGFloat)calculateItemWithAtIndex:(NSInteger)index {
    
    NSNumber *width = [self.titleWidthCache objectForKey:[NSString stringWithFormat:@"%ld", index]];
    if (width) {
        return [width doubleValue];
    } else {
        NSString *title = [self.delegate sliderView:self titleForItemAtIndex:index];
        NSDictionary *attrs = @{NSFontAttributeName: [LRSliderViewConfig sharedConfig].font};
        CGFloat itemWidth = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attrs context:nil].size.width;
        itemWidth = itemWidth * [LRSliderViewConfig sharedConfig].scaleSize;
        [self.titleWidthCache setObject:@(itemWidth) forKey:[NSString stringWithFormat:@"%ld", index]];
        return ceil(itemWidth);
    }
    
}

/**
 *  更新Cell中Label的颜色和大小
 *
 *  @param indexValue 当前位置
 *  @param nextIndexValue 即将移动到的位置
 */
- (void)updateLabelInCellAtIndexValue:(CGFloat)indexValue ToNewIndexValue:(CGFloat)nextIndexValue {
    NSIndexPath *currentIndexPath;
    NSIndexPath *nextIndexPath;
    if (indexValue == nextIndexValue) {return;}
    
    currentIndexPath = [NSIndexPath indexPathForItem:indexValue  inSection:0];
    
    if (nextIndexValue > indexValue) {
        nextIndexPath = [NSIndexPath indexPathForItem:indexValue + 1 inSection:0];
    } else if (nextIndexValue < indexValue){
        nextIndexPath = [NSIndexPath indexPathForItem:indexValue - 1 inSection:0];
    }
    CGFloat rate = fabs(indexValue - nextIndexValue);     //取绝对值
    CGFloat lagerScale = [LRSliderViewConfig sharedConfig].scaleSize - rate * ([LRSliderViewConfig sharedConfig].scaleSize - 1);
    CGFloat smallScale = rate * ([LRSliderViewConfig sharedConfig].scaleSize - 1) + 1;
    
    UIButton *nextBtn = self.buttonArray[nextIndexPath.row];
    UIButton *currentBtn = self.buttonArray[currentIndexPath.row];
    
    [self changeButtonColor:nextBtn To:[LRSliderViewConfig sharedConfig].selectedColor WithScale:rate];
    [self changeButtonColor:currentBtn To:[LRSliderViewConfig sharedConfig].titleColor WithScale:rate];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    nextBtn.transform = CGAffineTransformMakeScale(smallScale, smallScale);
    currentBtn.transform = CGAffineTransformMakeScale(lagerScale, lagerScale);
    [CATransaction commit];
    
}

/**
 *  线性改变UIButton颜色
 *
 *  @param btn  改色btn
 *  @param toColor 改变后的颜色
 *  @param scale   改色进度
 */
- (void)changeButtonColor:(UIButton *)btn To:(UIColor *)toColor WithScale:(CGFloat)scale {
    CGFloat originRed, originGreen, originBlue;
    [btn.titleLabel.textColor getRed:&originRed green:&originGreen blue:&originBlue alpha:nil];
    CGFloat targetRed, targetGreen, targetBlue;
    [toColor getRed:&targetRed green:&targetGreen blue:&targetBlue alpha:nil];
    CGFloat currentRed, currentGreen, currentBlue;
    currentRed = originRed + (targetRed - originRed) * scale * 0.1;
    currentGreen = originGreen + (targetGreen - originGreen) * scale * 0.1;
    currentBlue = originBlue + (targetBlue - originBlue) * scale;
    [btn setTitleColor:[UIColor colorWithRed:currentRed green:currentGreen blue:currentBlue alpha:1] forState:UIControlStateNormal];
}


/**
 *  更新下划线位置
 *
 *  @param indexValue 当前位置
 *  @param newIndexValue 即将移动到的位置
 */
- (void)updateSliderLineAtIndexValue:(CGFloat)indexValue ToNewIndexValue:(CGFloat)newIndexValue{
    NSIndexPath *currentIndexPath;
    NSIndexPath *nextIndexPath;
    if (indexValue == newIndexValue) {return;}
    
    currentIndexPath =[NSIndexPath indexPathForItem:indexValue inSection:0];
    
    if (newIndexValue > indexValue) {
        nextIndexPath = [NSIndexPath indexPathForItem:indexValue + 1 inSection:0];
    } else if (newIndexValue < indexValue){
        nextIndexPath = [NSIndexPath indexPathForItem:indexValue - 1 inSection:0];
    }
    
    //获取即将移动到的cell。获取cell相对于View中的相对位置
    SliderTitleCell *cell = [self.titleCollectionView dequeueReusableCellWithReuseIdentifier:@"SliderTitleCell" forIndexPath:nextIndexPath];
    CGRect cellFrame = [self.titleCollectionView convertRect:cell.frame toView:self.titleCollectionView];
    CGFloat labelWidth = [self calculateItemWithAtIndex:nextIndexPath.row];
    CGFloat startPointX = cellFrame.origin.x + (cellFrame.size.width - labelWidth) / 2;
    
    //获取之前的cell。获取cell相对于View中的相对位置
    SliderTitleCell *preCell = [self.titleCollectionView dequeueReusableCellWithReuseIdentifier:@"SliderTitleCell" forIndexPath:currentIndexPath];
    CGRect preCellFrame = [self.titleCollectionView convertRect:preCell.frame toView:self.titleCollectionView];
    CGFloat preLabelWidth = [self calculateItemWithAtIndex:currentIndexPath.row];
    CGFloat preStartPointX = preCellFrame.origin.x + (preCellFrame.size.width - preLabelWidth) / 2;
    
    CGFloat rate = fabs(newIndexValue - indexValue);
    [self.sliderLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(preLabelWidth + (labelWidth - preLabelWidth) * rate);
        make.left.mas_equalTo(preStartPointX + (startPointX - preStartPointX) * rate);
    }];
}

- (void)updateSliderLinePosition:(CGFloat)index {
    SliderTitleCell *cell = [self.titleCollectionView dequeueReusableCellWithReuseIdentifier:@"SliderTitleCell" forIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    CGRect cellFrame = [self.titleCollectionView convertRect:cell.frame toView:self.titleCollectionView];
    CGFloat labelWidth = [self calculateItemWithAtIndex:index];
    
    [self.sliderLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(labelWidth);
        make.left.mas_equalTo(cellFrame.origin.x + (cellFrame.size.width - labelWidth) / 2);
    }];
}

- (void)manageButtonStatus:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(sliderViewScrolledtoPageAtIndex:)]) {
        [self.delegate sliderViewScrolledtoPageAtIndex:index];
    }
    for (NSNumber *number in self.statusDic.allKeys) {
        if ([number integerValue] == index) {
            [self.statusDic setObject:[NSNumber numberWithBool:YES] forKey:number];
        } else {
            [self.statusDic setObject:[NSNumber numberWithBool:NO] forKey:number];
        }
    }
}

#pragma mark - init

- (UICollectionView *)titleCollectionView {
    if (_titleCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _titleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [LRSliderViewConfig sharedConfig].topViewHeight) collectionViewLayout:layout];
        _titleCollectionView.tag = CollectionViewTypeTitle;
        _titleCollectionView.bounces = NO;
        _titleCollectionView.showsHorizontalScrollIndicator = NO;
        _titleCollectionView.pagingEnabled = YES;
        _titleCollectionView.delegate = self;
        _titleCollectionView.dataSource = self;
        _titleCollectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_titleCollectionView];
        [_titleCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0).mas_offset([LRSliderViewConfig sharedConfig].topViewHeight);
            make.top.mas_equalTo(0);
            make.leading.mas_equalTo(0);
            make.trailing.mas_equalTo(0);
        }];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleCollectionView.frame), CGRectGetWidth(self.frame), 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
        [self addSubview:lineView];
        
    }
    
    UICollectionViewFlowLayout *topLayout = (UICollectionViewFlowLayout *)_titleCollectionView.collectionViewLayout;
    NSInteger totalNum = [self.delegate numberOfItemsInSliderView:self];
    if ( totalNum <= [LRSliderViewConfig sharedConfig].maxCountInScreen) {
        topLayout.itemSize = CGSizeMake(self.frame.size.width / totalNum, [LRSliderViewConfig sharedConfig].topViewHeight);
    } else {
        topLayout.itemSize = CGSizeMake(self.frame.size.width / [LRSliderViewConfig sharedConfig].maxCountInScreen, [LRSliderViewConfig sharedConfig].topViewHeight);
    }
    
    return _titleCollectionView;
}

- (UICollectionView *)contentCollectionView {
    if (_contentCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height - [LRSliderViewConfig sharedConfig].topViewHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.titleCollectionView.frame.size.height+0.5, self.frame.size.width, self.frame.size.height - [LRSliderViewConfig sharedConfig].topViewHeight) collectionViewLayout:layout];
       
        _contentCollectionView.tag = CollectionViewTypeContent;
        _contentCollectionView.backgroundColor = [UIColor colorWithRed:240/255.f green:244/255.f blue:245/255.f alpha:1.f];
        _contentCollectionView.bounces = NO;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
        _contentCollectionView.pagingEnabled = YES;
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        [self addSubview:_contentCollectionView];
        [_contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.titleCollectionView.mas_bottom).mas_offset(0.5);
            make.leading.mas_equalTo(0);
            make.trailing.mas_equalTo(0);
        }];
    }
    return _contentCollectionView;
}

- (UIView *)sliderLine {
    if (_sliderLine == nil) {
        _sliderLine = [[UIView alloc] init];
        _sliderLine.backgroundColor = [LRSliderViewConfig sharedConfig].selectedColor;
        [self.titleCollectionView addSubview:_sliderLine];
        UICollectionViewFlowLayout *topLayout = (UICollectionViewFlowLayout *)self.titleCollectionView.collectionViewLayout;
        [_sliderLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(2);
            make.top.mas_equalTo(self.titleCollectionView.mas_top).mas_offset([LRSliderViewConfig sharedConfig].topViewHeight-2);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(topLayout.itemSize.width);
        }];
    }
    return _sliderLine;
}

- (NSMutableDictionary *)statusDic {
    if (_statusDic == nil) {
        _statusDic = [[NSMutableDictionary alloc] init];
        for (int num = 0; num < [self.delegate numberOfItemsInSliderView:self]; num ++) {
            [_statusDic setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInt:num]];
            //带指定页面的初始化
            NSInteger initializeIndex = 0;
            if ([self.delegate respondsToSelector:@selector(startIndexForSliderView:)] && self.firstLoading) {
                initializeIndex = [self.delegate startIndexForSliderView:self];
            }else{
                initializeIndex = self.currentIndex;
            }
            if (num == initializeIndex) {
                self.currentIndex = num;
                [_statusDic setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInt:num]];
                [self.contentCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:num inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                [self.titleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:num inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
                [self updateSliderLinePosition:num];
                
            }
        }
        self.firstLoading = NO;
    }
    return _statusDic;
}

- (NSMutableArray *)buttonArray{
    
    if (_buttonArray == nil) {
        _buttonArray = [NSMutableArray new];
        for (NSInteger index = 0; index < [self.delegate numberOfItemsInSliderView:self]; index ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn.titleLabel setFont:[LRSliderViewConfig sharedConfig].font];
            [btn.titleLabel setText:[self.delegate sliderView:self titleForItemAtIndex:index]];
            [btn setTitleColor: [LRSliderViewConfig sharedConfig].titleColor forState:UIControlStateNormal];
            [self.buttonArray addObject:btn];
        }
    }
    
    return _buttonArray;
    
}

- (NSMutableDictionary *)titleWidthCache{
    if (_titleWidthCache == nil) {
        _titleWidthCache = [NSMutableDictionary new];
    }
    
    return _titleWidthCache;
}


@end
