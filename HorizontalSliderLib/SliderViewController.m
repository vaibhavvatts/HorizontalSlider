//
//  ViewController.m
//  HorizontalSliderLib
//
//  Created by Vaibhav Kumar on 4/30/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import "SliderViewController.h"
#import "SliderView.h"



@interface SliderViewController ()<VVSliderProtocol>
{

}

@end

@implementation SliderViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSArray *myArr = [[NSArray alloc]initWithObjects:@"h1",@"h2",@"h3", nil];
    
    SliderView *sv = [[SliderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height) heading:myArr];
    sv.delegate = self;
    [sv begin];
   
    [self.view addSubview:sv];
}

-(UIView *)viewForIndex:(NSIndexPath *)indexOfView
{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height)];
    
    myView.backgroundColor = [UIColor redColor] ;
    return myView;
    

}


@end
