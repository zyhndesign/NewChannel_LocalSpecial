//
//  HomePageViewContr.h
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkDelegate.h"
@class MovieBgPlayViewCtr;

@interface HomePageViewContr : UIViewController<NetworkDelegate>
{
    IBOutlet UIScrollView *contentScrolV;
    IBOutlet UIImageView *mainImageV;
    IBOutlet UILabel *titleLb;
    IBOutlet UILabel *timeLb;
    IBOutlet UIView *movieView;
    NSArray *initAry;
    
    MovieBgPlayViewCtr *movieBgPlayVC;
    
    BOOL closeMenuScrol;
}
- (void)loadSubview:(NSArray*)ary;

@end
