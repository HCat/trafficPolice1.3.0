//
//  NSArray+PureLayoutMore.h
//  移动采集
//
//  Created by hcat on 2018/6/14.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <PureLayoutDefines.h>

@interface NSArray (PureLayoutMore)

- (PL__NSArray_of(NSLayoutConstraint *) *)autoDistributeViewsAlongAxis:(ALAxis)axis
                                                             alignedTo:(ALAttribute)alignment
                                                      withFixedSpacing:(CGFloat)spacing
                                                      withFixedLeading:(CGFloat)leading
                                                      withFixedTrailing:(CGFloat)trailing
                                                          matchedSizes:(BOOL)shouldMatchSizes;


@end
