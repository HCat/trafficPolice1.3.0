//
//  ArtVideoModel.h
//  ALiVideoRecorder
//
//  Created by LeeWong on 2017/4/16.
//  Copyright © 2017年 LeeWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArtVideoModel : NSObject
/// 完整视频 本地路径
@property (nonatomic, copy) NSString *videoAbsolutePath;
/// 缩略图 路径
@property (nonatomic, copy) NSString *thumAbsolutePath;
/// 完整视频 相对路径
@property (nonatomic, copy) NSString *videoRelativePath;
/// 缩略图 相对路径
@property (nonatomic, copy) NSString *thumRelativePath;
// 录制时间
@property (nonatomic, strong) NSDate *recordTime;

//服务端中需要给bodystream附的key值
@property(nonatomic,copy) NSString *name;

//视频文件名字，必须保证唯一性
@property(nonatomic,copy) NSString *fileName;

//转换成bodystream的编码方式
@property(nonatomic,copy) NSString *mimeType;

//视频大小
@property(nonatomic,assign) long long filesize;

//视频的data值
@property(nonatomic,strong) NSData *fileData;

//视频的长度：(秒)
@property(nonatomic,assign) NSInteger second;


+ (instancetype)modelWithPath:(NSString *)videoPath thumPath:(NSString *)thumPath recordTime:(NSDate *)recordTime;

@end
