//
//  AudioPlayerViewCtr.h
//  TongDao
//
//  Created by sunyong on 13-9-17.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "LoadMusicQue.h"

@interface AudioPlayerViewCtr : UIViewController<NetworkDelegate, AVAudioPlayerDelegate>
{
    NSString *CurrentUrlStr;
	NSTimer *progressUpdateTimer;
    
	NSString *currentArtist;
	NSString *currentTitle;
    
    IBOutlet UILabel *titleLb;
    IBOutlet UIProgressView *progreView;
    
    IBOutlet UIButton *playerBt;
    
    int currentPosition;
    
    IBOutlet UIActivityIndicatorView *activeView;
    
    IBOutlet UIView *stopAllView;
    
    AVAudioPlayer *musicPlayer;
}
@property (strong, nonatomic) AVAudioPlayer *avPlay;

- (IBAction)play:(UIButton*)sender;
- (IBAction)before:(UIButton*)sender;
- (IBAction)next:(UIButton*)sender;
@end
