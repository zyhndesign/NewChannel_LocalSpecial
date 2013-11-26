//
//  StoryViewContr.h
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoryViewContr : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIScrollView *contentScrolV;
    IBOutlet UIImageView *mainImageV;
    
    IBOutlet UIPageControl *pageControl;
    NSArray *initAry;
}
- (void)loadSubview:(NSArray*)ary;

@end
