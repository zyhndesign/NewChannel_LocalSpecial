//
//  LoaderViewController.h
//  TongDao
//
//  Created by sunyong on 13-12-9.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoaderViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIView *subViewBg;
    IBOutlet UIView *menuView;
    IBOutlet UIView *loadProgresView;
    
    IBOutlet UILabel *progresLb;
    
    UIScrollView *menuScrolV;
    UIScrollView *progresScrolV;
    NSMutableArray *menuAry;
}

- (IBAction)changeView:(UIButton*)sender;
- (IBAction)hiddenView:(UIButton*)sender;
- (IBAction)stopAllTask:(UIButton*)sender;
- (IBAction)openAllTask:(UIButton*)sender;
- (IBAction)closeAllTask:(UIButton*)sender;
@end

