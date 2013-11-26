//
//  StoryViewContr.m
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "StoryViewContr.h"
#import "SimpleTrationView.h"
#import "SimpleTrationSmallView.h"
#import <QuartzCore/QuartzCore.h>
#import "AllVariable.h"
#import "ProImageLoadNet.h"



@interface StoryViewContr ()

@end

@implementation StoryViewContr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#define PageSize 5
- (void)didReceiveMemoryWarning
{
    if (AllScrollView.contentOffset.y >= 90 + 668*6 && AllScrollView.contentOffset.y < 90 + 668*8)
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
#define StartX 82
#define StartY 134
#define StartSmalX 522
#define Gap 20
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
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    
    [contentScrolV setContentSize:CGSizeMake(1024*page, contentScrolV.frame.size.height)];
    for (int i = 0; i < initAry.count && i < 18; i++)
    {
        page = i/PageSize;
        if (i%PageSize == 0)
        {
            SimpleTrationView *simpleTranView = [[SimpleTrationView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
            [simpleTranView setFrame:CGRectMake(page*1024 + StartX, StartY, simpleTranView.frame.size.width, simpleTranView.frame.size.height)];
            simpleTranView.tag = i + 1;
            [contentScrolV addSubview:simpleTranView];
        }
        else
        {
            int rowX = 0;
            int rowY = 0;
            if (i%PageSize == 1 || i%PageSize == 3)
                rowX = 0;
            else
                rowX = 1;
            if (i%PageSize == 1 || i%PageSize == 2)
                rowY = 0;
            else
                rowY = 1;
            SimpleTrationSmallView *simpleTraSmalView = [[SimpleTrationSmallView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
            [simpleTraSmalView setFrame:CGRectMake(1024*page + StartSmalX + rowX*simpleTraSmalView.frame.size.width + rowX*Gap, StartY + rowY*simpleTraSmalView.frame.size.height + rowY*Gap, simpleTraSmalView.frame.size.width, simpleTraSmalView.frame.size.height)];
            simpleTraSmalView.tag = i + 1;
            [contentScrolV addSubview:simpleTraSmalView];
        }
    }
    
}

- (void)rebuildNewMenuView:(int)midPage
{
    if (initAry.count < PageSize*3)  // 3页之内不做处理，只有内存警告是才删除多余的
        return;
    for (int i = (midPage-2)*PageSize; i < initAry.count && i < (midPage+3)*PageSize; i++)
    {
        if (i < 0)
            continue;
        SimpleTrationSmallView *simpleTraSmalView = (SimpleTrationSmallView*)[contentScrolV viewWithTag:i+1];
        if (!simpleTraSmalView)
        {
            int page = i/PageSize;
            if (i%PageSize == 0)
            {
                SimpleTrationView *simpleTranView = [[SimpleTrationView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
                [simpleTranView setFrame:CGRectMake(page*1024 + StartX, StartY, simpleTranView.frame.size.width, simpleTranView.frame.size.height)];
                [contentScrolV addSubview:simpleTranView];
                simpleTranView.tag = i+1;
            }
            else
            {
                int rowX = 0;
                int rowY = 0;
                if (i%PageSize == 1 || i%PageSize == 3)
                    rowX = 0;
                else
                    rowX = 1;
                if (i%PageSize == 1 || i%PageSize == 2)
                    rowY = 0;
                else
                    rowY = 1;
                SimpleTrationSmallView *simpleTraSmalView = [[SimpleTrationSmallView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
                [simpleTraSmalView setFrame:CGRectMake(1024*page + StartSmalX + rowX*simpleTraSmalView.frame.size.width + rowX*Gap, StartY + rowY*simpleTraSmalView.frame.size.height + rowY*Gap, simpleTraSmalView.frame.size.width, simpleTraSmalView.frame.size.height)];
                [contentScrolV addSubview:simpleTraSmalView];
                simpleTraSmalView.tag = i + 1;
            }

        }
    }
}

- (void)rebulidCurrentPage:(int)currentPage
{
    if (initAry.count < PageSize*3)  // 3页之内不做处理，只有内存警告是才删除多余的
        return;
    int startP = (currentPage-2)*PageSize;
    if (startP < 0)
        startP = 0;
    for (int i = startP; i < initAry.count && i < (currentPage+3)*PageSize; i++)
    {
        if (i < 0)
            continue;
        SimpleTrationSmallView *simpleTraSmalView = (SimpleTrationSmallView*)[contentScrolV viewWithTag:i+1];
        if (!simpleTraSmalView)
        {
            int page = i/PageSize;
            if (i%PageSize == 0)
            {
                SimpleTrationView *simpleTranView = [[SimpleTrationView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
                [simpleTranView setFrame:CGRectMake(page*1024 + StartX, StartY, simpleTranView.frame.size.width, simpleTranView.frame.size.height)];
                [contentScrolV addSubview:simpleTranView];
                simpleTranView.tag = i + 1;
            }
            else
            {
                int rowX = 0;
                int rowY = 0;
                if (i%PageSize == 1 || i%PageSize == 3)
                    rowX = 0;
                else
                    rowX = 1;
                if (i%PageSize == 1 || i%PageSize == 2)
                    rowY = 0;
                else
                    rowY = 1;
                SimpleTrationSmallView *simpleTraSmalView = [[SimpleTrationSmallView alloc] initWithInfoDict:[initAry objectAtIndex:i]];
                [simpleTraSmalView setFrame:CGRectMake(1024*page + StartSmalX + rowX*simpleTraSmalView.frame.size.width + rowX*Gap, StartY + rowY*simpleTraSmalView.frame.size.height + rowY*Gap, simpleTraSmalView.frame.size.width, simpleTraSmalView.frame.size.height)];
                [contentScrolV addSubview:simpleTraSmalView];
                simpleTraSmalView.tag = i + 1;
            }
            
        }

    }
}

- (void)removeRemainMenuView:(int)midPage
{
    if (initAry.count < PageSize*3)  // 3页之内不做处理，只有内存警告是才删除多余的
        return;
    for(UIView *view in [contentScrolV subviews])
    {
        if (view.tag < (midPage - 2)*PageSize || view.tag > (midPage + 3)*PageSize)
        {
            SimpleTrationSmallView *tempV = (SimpleTrationSmallView*)view;
            tempV.proImageLoadNet.delegate = nil;
            [view removeFromSuperview];
        }
    }
}


- (void)dealloc
{
    initAry = nil;
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
    if (!decelerate)
    {
        NSLog(@"-======%f", scrollView.contentOffset.x);
        [self rebulidCurrentPage:(scrollView.contentOffset.x+100)/1024];
    }
    else
    {
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"----%f", scrollView.contentOffset.x);
    [self rebulidCurrentPage:(scrollView.contentOffset.x+100)/1024];
}


@end
