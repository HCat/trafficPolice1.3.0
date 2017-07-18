//
//  ImageFileInfo.h
//  trafficPolice
//
//  Created by hcat on 2017/5/26.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageFileInfo : NSObject

//服务端中需要给bodystream附的key值
@property(nonatomic,strong) NSString *name;

//图片文件名字，必须保证唯一性
@property(nonatomic,strong) NSString *fileName;

//转换成bodystream的编码方式
@property(nonatomic,strong) NSString *mimeType;

//图片大小
@property(nonatomic,assign) long long filesize;

//图片的data值
@property(nonatomic,strong) NSData *fileData;

//具体的图片,有经过压缩处理的
@property(nonatomic,strong) UIImage *image;

//图片的宽
@property(nonatomic,assign) float width;

//图片的高
@property(nonatomic,assign) float height;

//初始化成具体的ImageFileInfo类型
//@prame : name 代表key值
//@prame : image 具体的UIImage对象

-(id)initWithImage:(UIImage *)image withName:(NSString *)name;

@end
