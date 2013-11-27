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

@interface ViewController ()

@end

@implementation ViewController
@synthesize otherContentV;


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
    
    AllMusicQueAry = [[NSMutableArray alloc] init];
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
}

- (void)addMaskView
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    
    [homePageViewCtr  loadSubview:cateOne];
    [landscapeViewCtr loadSubview:cateTwo];
    [humanityViewCtr  loadSubview:cateThr];
    [storyViewCtr     loadSubview:cateFou];
    [communityViewCtr loadSubview:cateFiv];
    
    musicShowBt.hidden = NO;
    
    [launchImageV removeFromSuperview];
    [activeView removeFromSuperview];
    stopAllView.hidden = YES;
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
    
    [homePageViewCtr  loadSubview:cateOne];
    [landscapeViewCtr loadSubview:cateTwo];
    [humanityViewCtr  loadSubview:cateThr];
    [storyViewCtr     loadSubview:cateFou];
    [communityViewCtr loadSubview:cateFiv];
    
    musicShowBt.hidden = NO;
    [launchImageV removeFromSuperview];
    [activeView   removeFromSuperview];
    stopAllView.hidden = YES;
}


@end
