//
//  ViewController.m
//  HorizontalSliderLib
//
//  Created by Vaibhav Kumar on 4/30/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "SliderViewController.h"
#import "MBProgressHUD.h"


#define screenWidth [[UIScreen mainScreen] bounds].size.width
#define screenHeight [[UIScreen mainScreen] bounds].size.height
#define scrollMargin 100
#define txtMargin 20

@interface SliderViewController ()<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UIScrollView *scrollHeader;
    CGFloat offset;
    NSMutableArray *arrViews;
    NSMutableArray *arrButtons;
    MBProgressHUD *progressBar;
    NSArray *arrHeading;
    BOOL isRefresh;
    NSMutableArray *arrViewsLoaded;
}

@end

@implementation SliderViewController

int currentView = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    isRefresh = NO;
    arrViews = [[NSMutableArray alloc]init];
    arrButtons = [[NSMutableArray alloc]init];
    arrViewsLoaded = [[NSMutableArray alloc]init];
    [arrViewsLoaded addObject:[NSNumber numberWithInt:0]];
    
    arrHeading = [[NSArray alloc]initWithObjects:
                  @"heading one",
                  @"heading two",
                  @"heading three",
                  @"heading four",
                  @"heading five",nil];
    
    [self headerScroll];
    
    [self headerContent];
}



-(void)actionHeading:(UIButton *)sender
{
    UIButton *btn = sender;
    int moveXpoint = (int)btn.tag;
    [scrollView setContentOffset:CGPointMake(moveXpoint * screenWidth, scrollMargin) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    [sender setContentOffset: CGPointMake(sender.contentOffset.x,0)];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    offset = scrollView	.contentOffset.x;
    //ensure that the end of scroll is fired.
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.3];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    int currentViewNo =  offset / screenWidth;
    
    if (currentViewNo != currentView) {
        if (isRefresh) {
            [self updateView:currentViewNo];
        }else{
            if (![arrViewsLoaded containsObject:[NSNumber numberWithInt:currentViewNo]]) {
                [self updateView:currentViewNo];
                [arrViewsLoaded addObject:[NSNumber numberWithInt:currentViewNo]];
            }
        }
        for (UIButton *btn in arrButtons) {
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        UIButton *btn = [arrButtons objectAtIndex:currentViewNo];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        currentView = currentViewNo;

        if(btn.frame.origin.x > screenWidth){
            [scrollHeader setContentOffset:CGPointMake(btn.frame.origin.x - (screenWidth*3/10 ), 0) animated:YES];
        }else{
            [scrollHeader setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

#pragma mark -Scroll Methods

-(void)headerScroll
{
    // header
    scrollHeader = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20,screenWidth, 80)];
    scrollHeader.delegate = self;
    [scrollHeader setBackgroundColor:[UIColor blackColor]];
    int lastMargin = 0;
    for (int i=0; i< arrHeading.count; i++) {
        UIButton *btnHeading = [[UIButton alloc]init];
        [btnHeading setBackgroundColor:[UIColor clearColor]];
        [btnHeading setTitle:[arrHeading objectAtIndex:i] forState:UIControlStateNormal];
        [btnHeading.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        btnHeading.tag = i;
        [btnHeading setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        if (i==0) {
            [btnHeading setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [btnHeading addTarget:self action:@selector(actionHeading:) forControlEvents:UIControlEventTouchUpInside];
        [btnHeading setFrame:CGRectMake(txtMargin + lastMargin, 45, btnHeading.intrinsicContentSize.width, 25)];
        lastMargin += btnHeading.intrinsicContentSize.width + 30;
        [arrButtons addObject:btnHeading];
        [scrollHeader addSubview:btnHeading];
    }
    [scrollHeader setContentSize:CGSizeMake(lastMargin, 100)];
    [self.view addSubview:scrollHeader];
}

-(void)headerContent
{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, scrollMargin,screenWidth, screenHeight - scrollMargin)];
    [scrollView setPagingEnabled:YES];
    scrollView.delegate = self;
    [scrollView setContentSize:CGSizeMake(arrHeading.count *screenWidth, 617)];
    for (int i =0; i<arrHeading.count; i++) {
        UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(i * screenWidth, 0,screenWidth, screenHeight - 100)];
        [scrollView addSubview:subView];
        [arrViews addObject:subView];
    }
    [self.view addSubview:scrollView];
    [self updateView:0];
}

#pragma mark - Custom Methods

-(void)updateView:(int)currentViewNo
{
    UIView *subView = [arrViews objectAtIndex:currentViewNo];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    
    [MBProgressHUD showHUDAddedTo:subView animated:YES];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void) {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://loliace.com/wp-content/uploads/2015/03/Mickey-Donald-Minnie-Cartoon-HD-Photo1.jpg"]];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:subView animated:YES];
                imgView.image = image;
                [subView addSubview:imgView];
            });
        }
    });
}

@end
