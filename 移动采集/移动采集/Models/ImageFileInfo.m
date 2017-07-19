//
//  ImageFileInfo.m
//  trafficPolice
//
//  Created by hcat on 2017/5/26.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "ImageFileInfo.h"
#import "UserModel.h"

@implementation ImageFileInfo

-(id)initWithImage:(UIImage *)image withName:(NSString *)name{
    self = [super init];
    if (self) {
        if (image) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *time = [formatter stringFromDate:[NSDate date]];
            if ([UserModel getUserModel].userId) {
                time = [NSString stringWithFormat:@"%@_%@",[UserModel getUserModel].userId,time];
            }
            
            _name = name; //对应网站上[upload.php中]处理文件的[字段"file"]
            
            //self.image = image;
            LxPrintf(@"压缩成jpg之前Image尺寸是(宽：%f 长：%f)",image.size.width,image.size.height);
            _fileData = UIImageJPEGRepresentation(image, 1.0);
            LxPrintf(@"压缩成jpg之前的数据大小:%zd", _fileData.length/1024);
            
            //将图片进行等比例缩到指定大小
            //self.image = [ShareFun scaleFromImage:image];
            
            
            NSInteger kb = 400;
            
            kb*=1024;
            
            CGFloat compression = 1.0f;
            CGFloat maxCompression = 0.1f;
            _fileData = UIImageJPEGRepresentation(image, compression);
            while ([_fileData length] > kb && compression > maxCompression) {
                compression -= 0.05;
                _fileData = UIImageJPEGRepresentation(image, compression);
            }
            
//            //横向的情况下不压缩得特别厉害
//            TICK
//            if (self.image.size.width > self.image.size.height) {
//                _fileData = UIImagePNGRepresentation(self.image);
//            }else{
//                _fileData =UIImageJPEGRepresentation(self.image, 0.9);
//            }
            
            LxPrintf(@"压缩成jpg之后的数据大小:%zd", _fileData.length/1024);
            _fileName = [NSString stringWithFormat:@"%@.jpg",time];
            _mimeType = @"image/jpeg";
            
            self.image = [UIImage imageWithData:_fileData scale:2.0f];
            LxPrintf(@"压缩成jpg之之后Image尺寸是(宽：%f 长：%f)",self.image.size.width,self.image.size.height);
            
            self.filesize = _fileData.length;
            self.width = self.image.size.width;
            self.height = self.image.size.height;
            
        }
    }
    return self;
}



@end
