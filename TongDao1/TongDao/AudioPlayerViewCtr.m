//
//  AudioPlayerViewCtr.m
//  TongDao
//
//  Created by sunyong on 13-9-17.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "AudioPlayerViewCtr.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>
#import "AllVariable.h"
#import "LoadSimpleMusicNet.h"
#import "SCGIFImageView.h"

@interface AudioPlayerViewCtr ()

@end

@implementation AudioPlayerViewCtr
@synthesize avPlay = _avPlay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [stopAllView removeFromSuperview];
    [activeView stopAnimating];
    progreView.progressTintColor = [UIColor whiteColor];
    progreView.trackTintColor = RedColor;
    
    self.view.backgroundColor = RedColor;
    currentPosition = 0;
    LoadMusicQue *loadMusicQNet = [[LoadMusicQue alloc] init];
    loadMusicQNet.delegate = self;
    [loadMusicQNet loadMusicFromUrl];
    [super viewDidLoad];
    
    NSURL *musicURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"03Shange" ofType:@"mp3"]];
    titleLb.text = @"03Shange";
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    musicPlayer.delegate = self;
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playProgress) userInfo:nil repeats:YES];
}

- (void)playProgress
{
    if (musicPlayer)
    {
        progreView.progress = musicPlayer.currentTime/musicPlayer.duration;
    }
    
}

- (IBAction)play:(UIButton *)sender
{
    if (AllMusicQueAry.count == 0)
    {
        if (musicPlayer.playing)
        {
            [musicPlayer pause];
            playMusicImageV.hidden = NO;
            [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_play_normal.png"] forState:UIControlStateNormal];
            [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_play_pressed.png"] forState:UIControlStateHighlighted];
        }
        else
        {
            [musicPlayer play];
            playMusicImageV.hidden = YES;
            [gifImageView startAnimating];
            [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_pause_normal.png"] forState:UIControlStateNormal];
            [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_pause_pressed.png"] forState:UIControlStateHighlighted];
        }
        return;
    }
    if (!musicPlayer)
    {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"music/%@", [AllMusicQueAry objectAtIndex:currentPosition]]];
        musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
        musicPlayer.delegate = self;
    }
    if (!playing)
	{
        playing = YES;
        [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_pause_normal.png"] forState:UIControlStateNormal];
        [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_pause_pressed.png"] forState:UIControlStateHighlighted];
		[musicPlayer play];
        [gifImageView startAnimating];
        playMusicImageV.hidden = YES;
	}
	else
	{
        playing = NO;
        [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_play_normal.png"] forState:UIControlStateNormal];
        [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_play_pressed.png"] forState:UIControlStateHighlighted];
		[musicPlayer pause];
        playMusicImageV.hidden = NO;
	}
}

- (IBAction)before:(UIButton*)sender
{
    if (AllMusicQueAry.count == 0)
    {
        if (!musicPlayer.playing)
        {
            [musicPlayer play];
            [gifImageView startAnimating];
            playMusicImageV.hidden = YES;
            [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_pause_normal.png"] forState:UIControlStateNormal];
            [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_pause_pressed.png"] forState:UIControlStateHighlighted];
        }
        return;
    }
    else
    {
        if (musicPlayer)
        {
            [musicPlayer stop];
            playMusicImageV.hidden = NO;
            musicPlayer = nil;
        }
        currentPosition--;
        if (currentPosition < 0)
            currentPosition = AllMusicQueAry.count - 1;
        if (currentPosition < AllMusicQueAry.count && currentPosition >= 0)
        {
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"music/%@", [AllMusicQueAry objectAtIndex:currentPosition]]];
            
            musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
            musicPlayer.delegate = self;
            titleLb.text = [[[AllMusicQueAry objectAtIndex:currentPosition] componentsSeparatedByString:@"."] objectAtIndex:0];
        }
        [musicPlayer play];
        [gifImageView startAnimating];
        playMusicImageV.hidden = YES;
        playing = YES;
        [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_pause_normal.png"] forState:UIControlStateNormal];
        [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_pause_pressed.png"] forState:UIControlStateHighlighted];
    }
}

- (IBAction)next:(UIButton*)sender
{
    if (AllMusicQueAry.count == 0)
    {
        if (!musicPlayer.playing)
        {
            [musicPlayer play];
            [gifImageView startAnimating];
            playMusicImageV.hidden = YES;
            [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_pause_normal.png"] forState:UIControlStateNormal];
            [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_pause_pressed.png"] forState:UIControlStateHighlighted];
        }
    }
    else
    {
        if (musicPlayer)
        {
            [musicPlayer stop];
            playMusicImageV.hidden = NO;
            musicPlayer = nil;
        }
        
        currentPosition++;
        if (currentPosition >= AllMusicQueAry.count)
            currentPosition = 0;
        if (currentPosition < AllMusicQueAry.count && currentPosition >= 0)
        {
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"music/%@", [AllMusicQueAry objectAtIndex:currentPosition]]];
            musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
            musicPlayer.delegate = self;
            [musicPlayer prepareToPlay];
            titleLb.text = [[[AllMusicQueAry objectAtIndex:currentPosition] componentsSeparatedByString:@"."] objectAtIndex:0];
        }
        
        [musicPlayer play];
        [gifImageView startAnimating];
        playMusicImageV.hidden = YES;
        playing = YES;
        [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_pause_normal.png"] forState:UIControlStateNormal];
        [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_pause_pressed.png"] forState:UIControlStateHighlighted];
    }
}

- (void)imply:(NSString*)infoStr
{
    @autoreleasepool {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:infoStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}



#pragma mark - net delegate
- (void)dealloc
{
    
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [gifImageView stopAnimating];
    playMusicImageV.hidden = NO;
}
#pragma mark - net delegate
- (void)didReceiveData:(NSDictionary *)dict
{
    stopAllView.hidden = YES;
    [activeView stopAnimating];
    NSArray *arry = [dict objectForKey:@"data"];
    
    [AllGroupInfoArray replaceObjectAtIndex:TaskMusic withObject:arry];
    
//    for (int i = 0; i < arry.count; i++)
//    {
//        NSDictionary *dict = [arry objectAtIndex:i];
//        LoadSimpleMusicNet *loadSimpleMisicNet = [[LoadSimpleMusicNet alloc] init];
//        [loadSimpleMisicNet loadMusicData:[dict objectForKey:@"music_path"] musicName:[dict objectForKey:@"music_name"]];
//    }
}

- (void)didReceiveErrorCode:(NSError *)ErrorDict
{
    stopAllView.hidden = YES;
    [activeView stopAnimating];
    
}
@end