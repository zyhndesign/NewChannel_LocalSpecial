//
//  ViewController.h
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageViewContr.h"
#import "LandscapeViewContr.h"
#import "HumanityViewContr.h"
#import "StoryViewContr.h"
#import "CommunityViewContr.h"
#import "LoadMenuInfoNet.h"
#import "AudioPlayerViewCtr.h"
#import "VersionViewContr.h"
#import "LoaderViewController.h"

#import "GAITrackedViewController.h"
#import "GAI.h"

@interface ViewController : GAITrackedViewController<NetworkDelegate, UIScrollViewDelegate, NSXMLParserDelegate, UIAlertViewDelegate>
{
    IBOutlet UIScrollView *_scrollView;
    HomePageViewContr *homePageViewCtr;
    LandscapeViewContr *landscapeViewCtr;
    HumanityViewContr *humanityViewCtr;
    StoryViewContr *storyViewCtr;
    CommunityViewContr *communityViewCtr;
    AudioPlayerViewCtr *audioPlayViewCtr;
    VersionViewContr *versionViewCtr;
    
    NSMutableArray *allInfoArray;
    
    UIButton *CurrentBt;
    
    IBOutlet UILabel *slipLb;    
    IBOutlet UIView *btView;
    IBOutlet UIView *menuImageV;
    IBOutlet UIView *stopAllView;
    
    IBOutlet UIImageView *launchImageV;
    IBOutlet UIView *musicView;
    IBOutlet UIButton *musicShowBt;
    IBOutlet UIActivityIndicatorView *activeView;
    
    BOOL isCloseMenuScrol;
    BOOL menuLoadFinish;
    NSMutableArray *videoArray;
    
}
@property(nonatomic, strong)NSMutableArray *videoArray;;
@property(nonatomic, strong)IBOutlet UIView *otherContentV;
@property(nonatomic, strong)IBOutlet UIProgressView *progressView;
@property(nonatomic, strong)IBOutlet UILabel *valueLb;
@property(nonatomic, strong)IBOutlet UILabel *charatLb;
@property(nonatomic, strong)IBOutlet UILabel *implyLb;

- (IBAction)selectMenu:(UIButton*)sender;
- (IBAction)musicShow:(UIButton*)sender;
- (void)imageScaleShow:(NSString*)imageUrl;
- (void)presentViewContr:(NSDictionary*)_infoDict;

- (void)caculateMovieLoad;
- (void)startLoadMovie;
- (void)finishLoad;
- (void)musicListLoadFinish;
@end
