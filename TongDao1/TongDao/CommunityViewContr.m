//
//  CommunityViewContr.m
//  TongDao
//
//  Created by sunyong on 13-9-15.
//  Copyright (c) 2013年 sunyong. All rights reserved.
//

#import "CommunityViewContr.h"
#import "SimpleHumanityView.h"
#import "AllVariable.h"
#import "ProImageLoadNet.h"

@interface CommunityViewContr ()

@end

@implementation CommunityViewContr

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [contentScrolV setBackgroundColor:[UIColor whiteColor]];
    [super viewDidLoad];
}

#define PageSize 4
- (void)didReceiveMemoryWarning
{
    if (AllScrollView.contentOffset.y >= 90 + 668*8 && AllScrollView.contentOffset.y < 90 + 668*10)
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
#define StartX 72
#define StartY 155
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
    [contentScrolV setContentSize:CGSizeMake(page*1024, contentScrolV.frame.size.height)];
    
    pageLenght = 880/page;
    
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(StartX, contentScrolV.frame.origin.y + StartY - 2, 880, 1)];
    topLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:topLine];
    
    UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(StartX, contentScrolV.frame.origin.y + StartY + 401, 880, 2)];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bottomLine];
    
    progressLb = [[UILabel alloc] initWithFrame:CGRectMake(StartX, contentScrolV.frame.origin.y + StartY + 401, pageLenght, 2)];
    progressLb.backgroundColor = RedColor;
    [self.view addSubview:progressLb];
    
    for (int i = 0; i < initAry.count; i++)
    {
        page = i/PageSize;
        if (i%PageSize)
        {
            UILabel *midLb = [[UILabel alloc] initWithFrame:CGRectMake(page*1024 + StartX + (i%PageSize)*220 -1, StartY + 15, 1, 400 - 30)];
            midLb.backgroundColor = [UIColor lightGrayColor];
            [contentScrolV addSubview:midLb];
        }
    }
    for (int i = 0; i < initAry.count && i < 18; i++)
    {
        page = i/PageSize;
        SimpleHumanityView *simpleHimanView = [[SimpleHumanityView alloc] initWithInfoDict:[initAry objectAtIndex:i] mode:i%2];
        simpleHimanView.frame = CGRectMake(page*1024 + StartX + (i%PageSize)*simpleHimanView.frame.size.width, StartY, simpleHimanView.frame.size.width, simpleHimanView.frame.size.height);
        simpleHimanView.tag = i + 1;
        [contentScrolV addSubview:simpleHimanView];
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
        SimpleHumanityView *simpleHimanView = (SimpleHumanityView*)[contentScrolV viewWithTag:i+1];
        if (!simpleHimanView)
        {
            int page = i/PageSize;
            simpleHimanView = [[SimpleHumanityView alloc] initWithInfoDict:[initAry objectAtIndex:i] mode:i%2];
            simpleHimanView.frame = CGRectMake(page*1024 + StartX + (i%PageSize)*simpleHimanView.frame.size.width, StartY, simpleHimanView.frame.size.width, simpleHimanView.frame.size.height);
            simpleHimanView.tag = i + 1;
            [contentScrolV addSubview:simpleHimanView];
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
        SimpleHumanityView *simpleHimanView = (SimpleHumanityView*)[contentScrolV viewWithTag:i+1];
        if (!simpleHimanView)
        {
            int page = i/PageSize;
            simpleHimanView = [[SimpleHumanityView alloc] initWithInfoDict:[initAry objectAtIndex:i] mode:i%2];
            simpleHimanView.frame = CGRectMake(page*1024 + StartX + (i%4)*simpleHimanView.frame.size.width, StartY, simpleHimanView.frame.size.width, simpleHimanView.frame.size.height);
            simpleHimanView.tag = i + 1;
            [contentScrolV addSubview:simpleHimanView];
        }
    }
}

- (void)removeRemainMenuView:(int)midPage
{
    if (initAry.count < PageSize*3)  // 3页之内不做处理，只有内存警告是才删除多余的
        return;
    for(UIView *view in [contentScrolV subviews])
    {
        if ((view.tag > 0 && view.tag < (midPage - 2)*PageSize + 1) || view.tag > (midPage + 3)*PageSize + 1)
        {
            SimpleHumanityView *tempV = (SimpleHumanityView*)view;
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

}

#pragma mark - scrollview delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    int page = contentScrolV.contentOffset.x/1024;
    [self removeRemainMenuView:page];
    [self rebuildNewMenuView:page];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = (scrollView.contentOffset.x+100)/1024;
    [self rebulidCurrentPage:page + 1];
    [progressLb setFrame:CGRectMake(StartX + page*pageLenght, progressLb.frame.origin.y, progressLb.frame.size.width, progressLb.frame.size.height)];
}


@end
