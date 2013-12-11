//
//  AllVariable.h
//  TongDao
//
//  Created by sunyong on 13-9-17.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "QueueProHanle.h"
#import "QueueZipHandle.h"

#ifndef TongDao_AllVariable_h
#define TongDao_AllVariable_h

@class ViewController;
@class SCGIFImageView;
@class AudioPlayerViewCtr;
@class LoaderViewController;

ViewController *RootViewContr;
AudioPlayerViewCtr *AllAudioPlayViewCtr;  /// 音乐VC
LoaderViewController *AllLoaderViewContr;   //
NSMutableArray *AllGroupInfoArray;  // 存放所有区下载的任务相关的数据，但视频数据临时计算
UIScrollView *AllScrollView;
int AllOnlyShowPresentOne;  // 只能同时展开一个详细内容
SCGIFImageView* gifImageView;
UIImageView *playMusicImageV;
BOOL playing;  // 音乐的播放状态
BOOL AllLoad;
BOOL AllOnceLoad;

NSMutableArray *AllMusicQueAry;
NSMutableDictionary *AllMovieInfoDict;
long AllZipSize;
long AllLoadLenght;

long AllVideoSize;
long AllLoadVideoLenght;

#endif
