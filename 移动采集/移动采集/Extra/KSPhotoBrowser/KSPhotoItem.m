//
//  KSPhotoItem.m
//  KSPhotoBrowser
//
//  Created by Kyle Sun on 12/25/16.
//  Copyright © 2016 Kyle Sun. All rights reserved.
//

#import "KSPhotoItem.h"

@interface KSPhotoItem ()

@property (nonatomic, strong, readwrite) UIImage *thumbImage;
@property (nonatomic, strong, readwrite) UIImage *image;
@property (nonatomic, strong, readwrite) NSURL   *imageUrl;

@end

@implementation KSPhotoItem

- (instancetype)initWithSourceView:(UIView *)view
                        thumbImage:(UIImage *)image
                          imageUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        _sourceView = view;
        _thumbImage = image;
        _imageUrl   = url;
    }
    return self;
}

- (instancetype)initWithSourceView:(UIImageView *)view
                          imageUrl:(NSURL *)url
{
    return [self initWithSourceView:view
                         thumbImage:view.image
                           imageUrl:url];
}

- (instancetype)initWithSourceView:(UIImageView *)view
                             image:(UIImage *)image {
    self = [super init];
    if (self) {
        _sourceView = view;
        _thumbImage = image;
        _imageUrl   = nil;
        _image      = image;
    }
    return self;
}

+ (instancetype)itemWithSourceView:(UIView *)view
                        thumbImage:(UIImage *)image
                          imageUrl:(NSURL *)url
{
    return [[KSPhotoItem alloc] initWithSourceView:view
                                        thumbImage:image
                                          imageUrl:url];
}

+ (instancetype)itemWithSourceView:(UIImageView *)view
                          imageUrl:(NSURL *)url
{
    return [[KSPhotoItem alloc] initWithSourceView:view
                                          imageUrl:url];
}

+ (instancetype)itemWithSourceView:(UIImageView *)view
                             image:(UIImage *)image
{
    return [[KSPhotoItem alloc] initWithSourceView:view
                                             image:image];
    
}

#pragma mark - 扩展出来的方法

+ (instancetype)itemWithSourceView:(UIImageView *)view
                          imageUrl:(NSURL *)url withDic:(NSDictionary *)dic{
   KSPhotoItem *item =  [[KSPhotoItem alloc] initWithSourceView:view
                                      imageUrl:url];
    
    item.illegalDic = dic;
    return item;

}
+ (instancetype)itemWithSourceView:(UIImageView *)view
                             image:(UIImage *)image withDic:(NSDictionary *)dic{
    
    KSPhotoItem *item =  [[KSPhotoItem alloc] initWithSourceView:view
                                                           image:image];
    
    item.illegalDic = dic;
    return item;

}


+ (instancetype)itemWithSourceView:(UIImageView *)view
                          imageUrl:(NSURL *)url withPhotoModel:(AccidentChangePhotoModel *)photo{

    KSPhotoItem *item =  [[KSPhotoItem alloc] initWithSourceView:view
                                                        imageUrl:url];
    
    item.photo = photo;
    return item;

}
+ (instancetype)itemWithSourceView:(UIImageView *)view
                             image:(UIImage *)image withPhotoModel:(AccidentChangePhotoModel *)photo{

    KSPhotoItem *item =  [[KSPhotoItem alloc] initWithSourceView:view
                                                           image:image];
    
    item.photo = photo;
    return item;
    
}

+ (instancetype)itemWithSourceView:(UIImageView *)view
                          imageUrl:(NSURL *)url withVehiclePhotoModel:(VehicleImageModel *)photo{
    
    KSPhotoItem *item =  [[KSPhotoItem alloc] initWithSourceView:view
                                                        imageUrl:url];
    
    item.vehicle = photo;
    return item;
    
    
}

@end
