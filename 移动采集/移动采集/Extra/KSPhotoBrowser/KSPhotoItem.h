//
//  KSPhotoItem.h
//  KSPhotoBrowser
//
//  Created by Kyle Sun on 12/25/16.
//  Copyright © 2016 Kyle Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccidentChangePhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSPhotoItem : NSObject

@property (nonatomic, strong) UIView  *sourceView;
@property (nonatomic, strong, readonly) UIImage *thumbImage;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong, readonly) NSURL   *imageUrl;
@property (nonatomic, assign) BOOL finished;

@property (nonatomic, strong) NSDictionary *illegalDic;
@property (nonatomic, strong) AccidentChangePhotoModel *photo;


- (instancetype)initWithSourceView:(UIView *)view
                        thumbImage:(UIImage *)image
                          imageUrl:(NSURL *)url;
- (instancetype)initWithSourceView:(UIImageView *)view
                          imageUrl:(NSURL *)url;
- (instancetype)initWithSourceView:(UIImageView *)view
                             image:(UIImage *)image;

+ (instancetype)itemWithSourceView:(UIView *)view
                        thumbImage:(UIImage *)image
                          imageUrl:(NSURL *)url;
+ (instancetype)itemWithSourceView:(UIImageView *)view
                          imageUrl:(NSURL *)url;
+ (instancetype)itemWithSourceView:(UIImageView *)view
                             image:(UIImage *)image;

//拓展出来的
+ (instancetype)itemWithSourceView:(UIImageView *)view
                          imageUrl:(NSURL *)url withDic:(NSDictionary *)dic;
+ (instancetype)itemWithSourceView:(UIImageView *)view
                             image:(UIImage *)image withDic:(NSDictionary *)dic;

+ (instancetype)itemWithSourceView:(UIImageView *)view
                          imageUrl:(NSURL *)url withPhotoModel:(AccidentChangePhotoModel *)photo;
+ (instancetype)itemWithSourceView:(UIImageView *)view
                             image:(UIImage *)image withPhotoModel:(AccidentChangePhotoModel *)photo;

@end

NS_ASSUME_NONNULL_END
