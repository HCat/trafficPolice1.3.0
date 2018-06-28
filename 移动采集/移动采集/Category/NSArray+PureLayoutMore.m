//
//  NSArray+PureLayoutMore.m
//  移动采集
//
//  Created by hcat on 2018/6/14.
//  Copyright © 2018年 Hcat. All rights reserved.
//



#import "NSArray+PureLayoutMore.h"
#import <ALView+PureLayout.h>
#import <NSLayoutConstraint+PureLayout.h>
#import <PureLayout+Internal.h>


@implementation NSArray (PureLayoutMore)


- (PL__NSArray_of(NSLayoutConstraint *) *)autoDistributeViewsAlongAxis:(ALAxis)axis
                                                             alignedTo:(ALAttribute)alignment
                                                      withFixedSpacing:(CGFloat)spacing
                                                      withFixedLeading:(CGFloat)leading
                                                     withFixedTrailing:(CGFloat)trailing
                                                          matchedSizes:(BOOL)shouldMatchSizes{
    NSAssert([self al_containsMinimumNumberOfViews:1], @"This array must contain at least 1 view to distribute.");
    ALDimension matchedDimension;
    ALEdge firstEdge, lastEdge;
    switch (axis) {
        case ALAxisHorizontal:
        case ALAxisBaseline: // same value as ALAxisLastBaseline
#if PL__PureLayout_MinBaseSDK_iOS_8_0
        case ALAxisFirstBaseline:
#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 */
            matchedDimension = ALDimensionWidth;
            firstEdge = ALEdgeLeading;
            lastEdge = ALEdgeTrailing;
            break;
        case ALAxisVertical:
            matchedDimension = ALDimensionHeight;
            firstEdge = ALEdgeTop;
            lastEdge = ALEdgeBottom;
            break;
        default:
            NSAssert(nil, @"Not a valid ALAxis.");
            return nil;
    }
    
    __NSMutableArray_of(NSLayoutConstraint *) *constraints = [NSMutableArray new];
    ALView *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[ALView class]]) {
            ALView *view = (ALView *)object;
            view.translatesAutoresizingMaskIntoConstraints = NO;
            if (previousView) {
                // Second, Third, ... View
                [constraints addObject:[view autoPinEdge:firstEdge toEdge:lastEdge ofView:previousView withOffset:spacing]];
                if (shouldMatchSizes) {
                    [constraints addObject:[view autoMatchDimension:matchedDimension toDimension:matchedDimension ofView:previousView]];
                }
                [constraints addObject:[view al_alignAttribute:alignment toView:previousView forAxis:axis]];
            }
            else {
                // First view
                [constraints addObject:[view autoPinEdgeToSuperviewEdge:firstEdge withInset:leading]];
            }
            previousView = view;
        }
    }
    if (previousView) {
        // Last View
        [constraints addObject:[previousView autoPinEdgeToSuperviewEdge:lastEdge withInset:trailing]];
    }
    
    return constraints;
    
}


@end
