//
//  LandscapeViewContr.m
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "LandscapeViewContr.h"
#import "SimpleLandscView.h"
#import "AllVariable.h"
#import "ProImageLoadNet.h"

@interface LandscapeViewContr ()

@end

@implementation LandscapeViewContr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    contentScrolV.backgroundColor = [UIColor colorWithRed:25/255.0 green:25/255.0 blue:25/255.0 alpha:1];

    [super viewDidLoad];
}

#define PageSize 6
- (void)didReceiveMemoryWarning
{
    if (AllScrollView.contentOffset.y >= 90 + 668*2 && AllScrollView.contentOffset.y < 90 + 668*4)
    {
        
    }
    else
    {
        int currentPage = contentScrolV.contentOffset.x/1024 + 1;
        for(UIView *view in [contentScrolV subviews])
        {
            if (view.tag == 0)
                continue;
            if (view.tag <= PageSize*(currentPage-1) || view.tag > PageSize*(currentPage+1))
            {
                [view removeFromSuperview];
            }
        }
    }
    [super didReceiveMemoryWarning];
}


#define StartX 140
#define StartY 105
#define Gap 15
- (void)loadSubview:(NSArray*)ary
{
    initAry = [[NSArray alloc] initWithArray:ary];
    if (initAry.count == 0)
        return;
    int page = initAry.count/PageSize;
    if (initAry.count%PageSize)
        page++;
    if (page == 0)
        page = 1;
    pageControl.numberOfPages = page;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    [contentScrolV setContentSize:CGSizeMake(1024*page, contentScrolV.frame.size.height)];
    for (int i = 0; i < initAry.count && i < PageSize*3; i++)
    {
        SimpleLandscView *simleLandscView = [[SimpleLandscView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
        page = i/PageSize;
        int rowX = (i%PageSize)/2;
        int rowY = i%2;
        [simleLandscView setFrame:CGRectMake(page*1024 + StartX + rowX*Gap + rowX*simleLandscView.frame.size.width, StartY+rowY*Gap+rowY*simleLandscView.frame.size.height, simleLandscView.frame.size.width, simleLandscView.frame.size.height)];
        simleLandscView.tag = i + 1;
        [contentScrolV addSubview:simleLandscView];
    }
}

- (void)rebuildNewMenuView:(int)midPage
{
    if (initAry.count < PageSize*3)
        return;
    
    for (int i = (midPage-2)*PageSize; i < initAry.count && i < (midPage+3)*PageSize; i++)
    {
        if (i < 0)
            continue;
        SimpleLandscView *simpleLandscView = (SimpleLandscView*)[contentScrolV viewWithTag:i+1];
        if (!simpleLandscView)
        {
            SimpleLandscView *simleLandscView = [[SimpleLandscView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
            int page = i/PageSize;
            int rowX = (i%PageSize)/2;
            int rowY = i%2;
            [simleLandscView setFrame:CGRectMake(page*1024 + StartX + rowX*Gap + rowX*simleLandscView.frame.size.width, StartY+rowY*Gap+rowY*simleLandscView.frame.size.height, simleLandscView.frame.size.width, simleLandscView.frame.size.height)];
            simleLandscView.tag = i + 1;
            [contentScrolV addSubview:simleLandscView];
        }
    }
}

- (void)rebulidCurrentPage:(int)currentPage
{
    if (initAry.count < PageSize*3)
        return;
    int startP = (currentPage-2)*PageSize;
    if (startP < 0)
        startP = 0;
    for (int i = startP; i < initAry.count && i < (currentPage+3)*PageSize; i++)
    {
        if (i < 0)
            continue;
        SimpleLandscView *simpleLandscView = (SimpleLandscView*)[contentScrolV viewWithTag:i+1];
        if (!simpleLandscView)
        {
            simpleLandscView = [[SimpleLandscView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
            int page = i/PageSize;
            int rowX = (i%PageSize)/2;
            int rowY = i%2;
            [simpleLandscView setFrame:CGRectMake(page*1024 + StartX + rowX*Gap + rowX*simpleLandscView.frame.size.width, StartY+rowY*Gap+rowY*simpleLandscView.frame.size.height, simpleLandscView.frame.size.width, simpleLandscView.frame.size.height)];
            simpleLandscView.tag = i + 1;
            [contentScrolV addSubview:simpleLandscView];
        }
    }
}

- (void)removeRemainMenuView:(int)midPage
{
    if (initAry.count < PageSize*3)
        return;
    for(UIView *view in [contentScrolV subviews])
    {
        if (view.tag < (midPage - 2)*PageSize || view.tag > (midPage + 3)*PageSize)
        {
            SimpleLandscView *tempV = (SimpleLandscView*)view;
            tempV.proImageLoadNet.delegate = nil;
            [view removeFromSuperview];
        }
    }
}

- (void)dealloc
{
    initAry = nil;
}

- (IBAction)skipPage:(UIButton*)sender
{
//    if (sender == leftBt)
//    {
//        if (contentScrolV.contentOffset.x >= 1024)
//        {
//            float offset = contentScrolV.contentOffset.x - 1024;
//            int page = offset/1024;
//            [self removeRemainMenuView:page];
//            [self rebuildNewMenuView:page];
//            [contentScrolV setContentOffset:CGPointMake(contentScrolV.contentOffset.x - 1024, 0) animated:YES];
//            if(offset < 1000)
//                leftBt.hidden = YES;
//        }
//        rightBg.hidden = NO;
//    }
//    else
//    {
//        if (contentScrolV.contentOffset.x <= contentScrolV.contentSize.width - 1024)
//        {
//            float offset = contentScrolV.contentOffset.x + 1024;
//            int page = offset/1024;
//            [self removeRemainMenuView:page];
//            [self rebuildNewMenuView:page];
//            [contentScrolV setContentOffset:CGPointMake(contentScrolV.contentOffset.x + 1024, 0) animated:YES];
//            if(offset > contentScrolV.contentSize.width - 1040)
//                rightBg.hidden = YES;
//        }
//        leftBt.hidden = NO;
//    }
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPage = scrollView.contentOffset.x/1024;
    pageControl.currentPage = currentPage;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    int page = contentScrolV.contentOffset.x/1024;
    [self removeRemainMenuView:page];
    [self rebuildNewMenuView:page];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    if (!decelerate)
//    {
//        if (scrollView.contentSize.width == 1024)
//        {
//            leftBt.hidden  = YES;
//            rightBg.hidden = YES;
//            return;
//        }
//        if (scrollView.contentOffset.x < 1024 - 100)
//            leftBt.hidden = YES;
//        else
//            leftBt.hidden = NO;
//        
//        if (scrollView.contentOffset.x >= scrollView.contentSize.width - 1024 - 100)
//            rightBg.hidden = YES;
//        else
//            rightBg.hidden = NO;
//    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self rebulidCurrentPage:(scrollView.contentOffset.x+100)/1024];
//    if (scrollView.contentSize.width == 1024)
//    {
//        leftBt.hidden  = YES;
//        rightBg.hidden = YES;
//        return;
//    }
//    if (scrollView.contentOffset.x < 1024 - 100)
//        leftBt.hidden = YES;
//    else
//        leftBt.hidden = NO;
//    
//    if (scrollView.contentOffset.x >= scrollView.contentSize.width - 1024 - 100)
//        rightBg.hidden = YES;
//    else
//        rightBg.hidden = NO;
}

@end
