//
//  ViewController.m
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LocalSQL.h"
#import "LoadMusicQue.h"
#import "ActiveView.h"
#import "ImageShowView.h"
#import "AllVariable.h"
#import "SCGIFImageView.h"
#import "ContentView.h"
#import "googleAnalytics/GAIDictionaryBuilder.h"
#import "XMLParser.h"
#import "LoadSimpleMovieNet.h"
#import "QueueVideoHandle.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize videoArray;
@synthesize otherContentV;
@synthesize progressView;
@synthesize implyLb;
@synthesize valueLb;
@synthesize charatLb;

- (void)viewDidLoad
{
    self.screenName = @"社区界面";
    
    [[GAI sharedInstance].defaultTracker set:self.screenName
                                       value:@"Main Screen"];
    
    // Send the screen view.
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];
    [super viewDidLoad];
    
    [activeView startAnimating];
    AllScrollView = _scrollView;
    _scrollView.bounces  = YES;
    otherContentV.hidden = YES;
    stopAllView.hidden   = NO;
    slipLb.backgroundColor = RedColor;
    slipLb.hidden = YES;
    
    [QueueProHanle   init];
    [QueueZipHandle  init];
    
    AllOnceLoad = YES;
    valueLb.hidden = YES;
    charatLb.hidden = YES;
    progressView.hidden = YES;
    
    AllMusicQueAry    = [[NSMutableArray alloc] init];
    videoArray        = [[NSMutableArray alloc] init];
    AllMovieInfoDict  = [[NSMutableDictionary alloc] init];
    allInfoArray      = [[NSMutableArray alloc] init];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[path stringByAppendingString:@"/music"] error:nil];
    [AllMusicQueAry addObjectsFromArray:array];
    [AllMusicQueAry removeObject:@".DS_Store"];
    
    [self performSelector:@selector(MainViewLayerOut) withObject:nil afterDelay:0.3];
    
}

#define PageSize 668
#define RemainSize 90
- (void)MainViewLayerOut
{
    [_scrollView setContentSize:CGSizeMake(1024, PageSize*11)];
    //  _scrollView.pagingEnabled = YES;
    homePageViewCtr  = [[HomePageViewContr alloc] init];
    [homePageViewCtr.view setFrame:CGRectMake(0, 0, homePageViewCtr.view.frame.size.width, homePageViewCtr.view.frame.size.height)];
    
    landscapeViewCtr = [[LandscapeViewContr alloc] init];
    [landscapeViewCtr.view setFrame:CGRectMake(0, RemainSize + PageSize*2, landscapeViewCtr.view.frame.size.width, landscapeViewCtr.view.frame.size.height)];
    
    humanityViewCtr  = [[HumanityViewContr alloc] init];
    [humanityViewCtr.view setFrame:CGRectMake(0, RemainSize + PageSize*4, humanityViewCtr.view.frame.size.width, humanityViewCtr.view.frame.size.height)];
    
    storyViewCtr     = [[StoryViewContr alloc] init];
    [storyViewCtr.view setFrame:CGRectMake(0, RemainSize + PageSize*6, storyViewCtr.view.frame.size.width, storyViewCtr.view.frame.size.height)];
    
    communityViewCtr = [[CommunityViewContr alloc] init];
    [communityViewCtr.view setFrame:CGRectMake(0, RemainSize + PageSize*8, communityViewCtr.view.frame.size.width, communityViewCtr.view.frame.size.height)];
    
    versionViewCtr = [[VersionViewContr alloc] init];
    [versionViewCtr.view setFrame:CGRectMake(0, RemainSize + PageSize*10, versionViewCtr.view.frame.size.width, versionViewCtr.view.frame.size.height)];
    
    [_scrollView addSubview:homePageViewCtr.view];
    [_scrollView addSubview:landscapeViewCtr.view];
    [_scrollView addSubview:humanityViewCtr.view];
    [_scrollView addSubview:storyViewCtr.view];
    [_scrollView addSubview:communityViewCtr.view];
    [_scrollView addSubview:versionViewCtr.view];
    
    
    UIButton *showLoaderVBt = [UIButton buttonWithType:UIButtonTypeSystem];
    [showLoaderVBt setFrame:CGRectMake(1024-50, 668, 50, 50)];
    [showLoaderVBt setTitle:@"Show" forState:UIControlStateNormal];
    [showLoaderVBt addTarget:self action:@selector(showLoaderView:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:showLoaderVBt];
    
    AllLoaderViewContr = [[LoaderViewController alloc] init];
    [AllLoaderViewContr.view setFrame:CGRectMake(0, 768, AllLoaderViewContr.view.frame.size.width, AllLoaderViewContr.view.frame.size.height)];
    [self.view addSubview:AllLoaderViewContr.view];
    
    LoadMenuInfoNet *loadMenuInfoNet = [[LoadMenuInfoNet alloc] init];
    loadMenuInfoNet.delegate = self;
    [loadMenuInfoNet loadMenuFromUrl];
    
    audioPlayViewCtr = [[AudioPlayerViewCtr alloc] init];
    [audioPlayViewCtr.view setFrame:CGRectMake(0, 0, audioPlayViewCtr.view.frame.size.width, audioPlayViewCtr.view.frame.size.height)];
    [musicView addSubview:audioPlayViewCtr.view];
    AllAudioPlayViewCtr = audioPlayViewCtr;
    
    gifImageView = [[SCGIFImageView alloc] initWithGIFFile:[[NSBundle mainBundle] pathForResource:@"music_entrance" ofType:@"gif"]];
    [gifImageView setFrame:CGRectMake(0, 0, 50, 50)];
    gifImageView.userInteractionEnabled = NO;
    [musicShowBt addSubview:gifImageView];
    [gifImageView stopAnimating];
    
    playMusicImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player.png"]];
    [playMusicImageV setFrame:CGRectMake(0, 0, 50, 50)];
    playMusicImageV.userInteractionEnabled = NO;
    [musicShowBt addSubview:playMusicImageV];
    
    implyLb.text = @"正在加载数据";
    progressView.progressTintColor = RedColor;
    progressView.trackTintColor = [UIColor lightGrayColor];
}

- (void)addMaskView
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)showLoaderView:(UIButton*)sender
{
    
    [UIView animateWithDuration:0.4
                     animations:^(void){
                         AllLoaderViewContr.blackBgView.alpha = 0.2;
                         [AllLoaderViewContr.view setFrame:CGRectMake(0, 0, AllLoaderViewContr.view.frame.size.width, AllLoaderViewContr.view.frame.size.height)];
                     }
                     completion:^(BOOL finish){
                     }];
}
#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 768*5)
        scrollView.backgroundColor = [UIColor blackColor];
    else
        scrollView.backgroundColor = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1];
    if (!isCloseMenuScrol)
    {
        int positionY = 668 - scrollView.contentOffset.y;
        positionY = positionY < 0 ? 0:positionY;
        positionY = positionY > 668 ? 668:positionY;
        [btView setFrame:CGRectMake(0, positionY, btView.frame.size.width, btView.frame.size.height)];
        if (positionY <= 0)
            isCloseMenuScrol = YES;
    }
    if (handleScrol)
        return;
    int tag = (_scrollView.contentOffset.y - 768*2 + _scrollView.frame.size.height/2)/668 + 2;
    tag = tag/2;
    
    UIButton *tempBt = (UIButton *)[btView viewWithTag:tag];
    if ([tempBt isKindOfClass:[UIButton class]])
    {
        if (CurrentBt)
            [CurrentBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tempBt setTitleColor:RedColor forState:UIControlStateNormal];
        CurrentBt = tempBt;
        slipLb.hidden = NO;
        slipLb.center = CGPointMake(tempBt.center.x, slipLb.center.y);
    }
    else
    {
        if (CurrentBt)
        {
            [CurrentBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            CurrentBt = nil;
        }
        
        slipLb.hidden = YES;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    handleScrol = NO;
}

#pragma mark - Event
static BOOL handleScrol;
- (IBAction)selectMenu:(UIButton*)sender
{
    handleScrol = YES;
    [_scrollView setContentOffset:CGPointMake(0, sender.tag*668*2) animated:YES];
    if (CurrentBt)
        [CurrentBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CurrentBt = sender;
    [sender setTitleColor:RedColor forState:UIControlStateNormal];
    if (sender.tag == 0)
    {
        slipLb.hidden = YES;
    }
    else
    {
        slipLb.hidden = NO;
        slipLb.center = CGPointMake(sender.center.x, slipLb.center.y);
    }
}

- (IBAction)musicShow:(UIButton*)sender
{
    if (musicView.frame.origin.x == 0)
    {
        [UIView animateWithDuration:0.3
                         animations:^(void){
                             [musicView setCenter:CGPointMake(1024 + 512, musicView.center.y)];
                         }
                         completion:^(BOOL finish){
                         }];
    }
    else
    {
        [UIView animateWithDuration:0.3
                         animations:^(void){
                             [musicView setCenter:CGPointMake( 512, musicView.center.y)];
                         }
                         completion:^(BOOL finish){
                         }];
    }
}

- (void)imageScaleShow:(NSString*)imageUrl
{
    stopAllView.hidden = NO;
    otherContentV.hidden = NO;
    ImageShowView *imageShowView = [[ImageShowView alloc] initwithURL:imageUrl];
    imageShowView.tag = 1010;
    [otherContentV addSubview:imageShowView];
    [imageShowView setFrame:CGRectMake(0, 768, 1024, 768)];
    [UIView animateWithDuration:0.3
                     animations:^(void){
                         [imageShowView setFrame:CGRectMake(0, 0, 1024, 768)];
                     }
                     completion:^(BOOL finish){
                         stopAllView.hidden = YES;
                     }];
}

- (void)presentViewContr:(NSDictionary*)_infoDict
{
    if (AllOnlyShowPresentOne == 1)
    {
        return;
    }
    AllOnlyShowPresentOne = 1;
    stopAllView.hidden = NO;
    otherContentV.hidden = NO;
    ContentView *contentV = [[ContentView alloc] initWithInfoDict:_infoDict];
    [contentV setFrame:CGRectMake(1024, 0, 1024, 768)];
    [otherContentV addSubview:contentV];
    [UIView animateWithDuration:0.3
                     animations:^(void){
                         [contentV setFrame:CGRectMake(0, 0, 1024, 768)];
                     }
                     completion:^(BOOL finish){
                         stopAllView.hidden = YES;
                     }];
    
}

#pragma mark - net delegate
- (void)didReceiveData:(NSDictionary *)dict
{
    [LocalSQL openDataBase];
    NSArray *backAry = (NSArray*)dict;
    for (int i = 0; i < backAry.count; i++)
    {
        [LocalSQL insertData:[backAry objectAtIndex:i]];
    }
    if (backAry.count > 0)
    {
        NSDictionary *tempDict  = [backAry lastObject];
        NSString *timestampLast = [tempDict objectForKey:@"timestamp"];
        if (timestampLast.length > 0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:timestampLast forKey:@"timestamp"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    NSArray *cateOne = [LocalSQL getHeadline];
    NSArray *cateTwo = [LocalSQL getSectionData:@"13/14"];
    NSArray *cateThr = [LocalSQL getSectionData:@"13/15"];
    NSArray *cateFou = [LocalSQL getSectionData:@"13/16"];
    NSArray *cateFiv = [LocalSQL getSectionData:@"13/17"];
    [LocalSQL closeDataBase];
    
    [allInfoArray addObjectsFromArray:cateTwo];
    [allInfoArray addObjectsFromArray:cateThr];
    [allInfoArray addObjectsFromArray:cateFou];
    [allInfoArray addObjectsFromArray:cateFiv];
    
    [AllGroupInfoArray replaceObjectAtIndex:TaskScence withObject:cateTwo];
    [AllGroupInfoArray replaceObjectAtIndex:TaskHumanity withObject:cateThr];
    [AllGroupInfoArray replaceObjectAtIndex:TaskStory withObject:cateFou];
    [AllGroupInfoArray replaceObjectAtIndex:TaskCommunite withObject:cateFiv];
    
    [homePageViewCtr  loadSubview:cateOne];
    [landscapeViewCtr loadSubview:cateTwo];
    [humanityViewCtr  loadSubview:cateThr];
    [storyViewCtr     loadSubview:cateFou];
    [communityViewCtr loadSubview:cateFiv];
    menuLoadFinish = YES;
    
    if (AllMusicListLoadOver && menuLoadFinish)
    {
        [self showLoaderView:nil];
        [self finishLoad];
    }
   // [self caculateLoadTask];
}

- (void)didReceiveErrorCode:(NSError *)ErrorDict
{
    [LocalSQL openDataBase];
    NSArray *cateOne = [LocalSQL getHeadline];
    NSArray *cateTwo = [LocalSQL getSectionData:@"13/14"];
    NSArray *cateThr = [LocalSQL getSectionData:@"13/15"];
    NSArray *cateFou = [LocalSQL getSectionData:@"13/16"];
    NSArray *cateFiv = [LocalSQL getSectionData:@"13/17"];
    [LocalSQL closeDataBase];
    
    [allInfoArray addObjectsFromArray:cateTwo];
    [allInfoArray addObjectsFromArray:cateThr];
    [allInfoArray addObjectsFromArray:cateFou];
    [allInfoArray addObjectsFromArray:cateFiv];
    
    [homePageViewCtr  loadSubview:cateOne];
    [landscapeViewCtr loadSubview:cateTwo];
    [humanityViewCtr  loadSubview:cateThr];
    [storyViewCtr     loadSubview:cateFou];
    [communityViewCtr loadSubview:cateFiv];
    
    menuLoadFinish = YES;
    if (AllMusicListLoadOver && menuLoadFinish)
    {
        [self showLoaderView:nil];
        [self finishLoad];
    }
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络数据有误，请检查网络连接" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alerView show];
}

- (void)musicListLoadFinish
{
    if (AllMusicListLoadOver && menuLoadFinish)
    {
        [self showLoaderView:nil];
        [self finishLoad];
    }
}

- (void)caculateLoadTask
{
    AllLoad = YES;
    
    NSMutableArray *fileNameArray = [[NSMutableArray alloc] init];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    [fileNameArray addObjectsFromArray:array];
    [fileNameArray removeObject:@".DS_Store"];
    [fileNameArray removeObject:@"BigImage"];
    [fileNameArray removeObject:@"Data.db"];
    [fileNameArray removeObject:@"movie"];
    [fileNameArray removeObject:@"music"];
    [fileNameArray removeObject:@"ProImage"];
    
    AllZipSize = 0;
    AllLoadLenght = 0;
    for (int i = 0; i < allInfoArray.count; i++)
    {
        NSDictionary *infoDict = [allInfoArray objectAtIndex:i];
        NSString *idStr  = [infoDict objectForKey:@"id"];
        NSString *videoS = [infoDict objectForKey:@"hasVideo"];
        if (![self isEixstInArray:fileNameArray content:idStr])
        {
            int simpleSize = [[infoDict objectForKey:@"size"] intValue];
            AllZipSize += simpleSize;
            LoadZipFileNet *loadZipNet = [[LoadZipFileNet alloc] init];
            loadZipNet.delegate = nil;
            loadZipNet.urlStr   = [[infoDict objectForKey:@"url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            loadZipNet.md5Str   = [[infoDict objectForKey:@"md5"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            loadZipNet.zipStr = [infoDict objectForKey:@"id"];
            [QueueZipHandle addTarget:loadZipNet];
        }
        if([videoS isEqualToString:@"true"])
        {
            [videoArray addObject:infoDict];
        }
    }
    [self caculateMovieLoad];
}

- (void)caculateMovieLoad
{
    AllVideoSize = 0;
    AllLoadVideoLenght = 0;
    [AllMovieInfoDict removeAllObjects];
    [QueueVideoHandle clear];
    [XMLParser clear];
    NSMutableArray *fileNameArray = [[NSMutableArray alloc] init];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[path stringByAppendingPathComponent:@"movie"] error:nil];
    [fileNameArray addObjectsFromArray:array];
    [fileNameArray removeObject:@".DS_Store"];
    for (int i = 0; i < videoArray.count; i++)
    {
        NSDictionary *initDict = [videoArray objectAtIndex:i];
        NSString *docXmlPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/doc.xml", [initDict objectForKey:@"id"]]];
        [[XMLParser alloc] initWithFilePath:docXmlPath];
    }
    [self performSelector:@selector(goOnCaculateMovieLoader) withObject:nil afterDelay:0.5f];
}

- (void)goOnCaculateMovieLoader
{
    NSArray *valueArray = [AllMovieInfoDict allValues];
    long existFileSize = 0;
    for (int i = 0; i < valueArray.count; i++)
    {
        NSString *urlStr = [valueArray objectAtIndex:i];
        NSArray *tempAry = [urlStr componentsSeparatedByString:@"/"];
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"movie/%@", [tempAry lastObject]]];
        BOOL dirt = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&dirt])
        {
            NSDictionary *infoDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:Nil];
            long size = [infoDict fileSize];
            existFileSize += size;
        }
        else
        {
            LoadSimpleMovieNet *loadMoiveNet = [[LoadSimpleMovieNet alloc] init];
            loadMoiveNet.urlStr = urlStr;
            loadMoiveNet.Name = [tempAry lastObject];
            [QueueVideoHandle init];
            [QueueVideoHandle addTarget:loadMoiveNet];
        }
    }
    AllVideoSize -= existFileSize;
    
    static BOOL Once = NO;
    if (!Once)
    {
        Once = YES;
        if ([QueueVideoHandle isHaveTask] || [QueueZipHandle isHaveTask])
        {
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有新数据更新，是否一键下载" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alerView show];
        }
        else
        {
            [self finishLoad];
        }
    }
    else
    {
        if ([QueueVideoHandle isHaveTask] && AllVideoSize > 0)
        {
            [self startLoadMovie];
        }
    }
}

- (void)startLoadMovie
{
    NSString *implyStr = nil;
    [progressView setProgress:0.0 animated:NO];
    if (AllVideoSize/1024/1024/1024 >= 1)
    {
        implyStr = [NSString stringWithFormat:@"%0.2fG", AllVideoSize/1024.0/1024.0/1024.0];
    }
    else if (AllVideoSize/1024/1024 >= 1)
    {
        implyStr = [NSString stringWithFormat:@"%0.2fMB", AllVideoSize/1024.0/1024.0];
    }
    else
    {
        implyStr = [NSString stringWithFormat:@"%0.2fKB", AllVideoSize/1024.0];
    }
    implyLb.text = [NSString stringWithFormat:@"正在下载新的视频数据，共有%@，请耐心等候!", implyStr];
    [QueueVideoHandle startTask];
}

- (BOOL)isEixstInArray:(NSArray*)initAry content:(NSString*)contentStr
{
    for (int i = 0; i < initAry.count; i++)
    {
        NSString *infoStr = [initAry objectAtIndex:i];
        if ([infoStr isEqualToString:contentStr])
        {
            return YES;
        }
    }
    return NO;
}

- (void)finishLoad
{
    AllOnceLoad = NO;
    musicShowBt.hidden = NO;
    [launchImageV removeFromSuperview];
    [activeView   removeFromSuperview];
    stopAllView.hidden = YES;
    [progressView removeFromSuperview];
    [valueLb removeFromSuperview];
    [charatLb removeFromSuperview];
    [implyLb removeFromSuperview];
    progressView = nil;
    valueLb = nil;
    charatLb = nil;
    implyLb = nil;
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [activeView stopAnimating];
        valueLb.hidden      = NO;
        charatLb.hidden     = NO;
        progressView.hidden = NO;
        if ([QueueZipHandle isHaveTask])
        {
            [QueueZipHandle startTask];
            NSString *implyStr = nil;
            if (AllZipSize/1024/1024/1024 >= 1)
            {
                implyStr = [NSString stringWithFormat:@"%0.2fG", AllZipSize/1024.0/1024.0/1024.0];
            }
            else if (AllZipSize/1024/1024 >= 1)
            {
                implyStr = [NSString stringWithFormat:@"%0.2fMB", AllZipSize/1024.0/1024.0];
            }
            else
            {
                implyStr = [NSString stringWithFormat:@"%0.2fKB", AllZipSize/1024.0];
            }
            implyLb.text = [NSString stringWithFormat:@"正在下载新的文章数据，共有%@，请耐心等候!", implyStr];
        }
        else
        {
            [QueueVideoHandle startTask];
            NSString *implyStr = nil;
            if (AllVideoSize/1024/1024/1024 >= 1)
            {
                implyStr = [NSString stringWithFormat:@"%0.2fG", AllVideoSize/1024.0/1024.0/1024.0];
            }
            else if (AllVideoSize/1024/1024 >= 1)
            {
                implyStr = [NSString stringWithFormat:@"%0.2fMB", AllVideoSize/1024.0/1024.0];
            }
            else
            {
                implyStr = [NSString stringWithFormat:@"%0.2fKB", AllVideoSize/1024.0];
            }
            implyLb.text = [NSString stringWithFormat:@"正在下载新的视频数据，共有%@，请耐心等候!", implyStr];
        }
    }
    else
    {
        [self finishLoad];
    }
}

@end
