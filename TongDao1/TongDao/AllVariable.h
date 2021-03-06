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

ViewController *RootViewContr;
AudioPlayerViewCtr *AllAudioPlayViewCtr;
UIScrollView *AllScrollView;
int AllOnlyShowPresentOne;  // 只能同时展开一个详细内容
SCGIFImageView* gifImageView;
UIImageView *playMusicImageV;
BOOL playing;  // 音乐的播放状态

NSMutableArray *AllMusicQueAry;

#endif
