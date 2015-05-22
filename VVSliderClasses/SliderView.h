//
//  SliderView.h
//  HorizontalSliderLib
//
//  Created by Vaibhav Kumar on 5/22/15.
//  Copyright (c) 2015 Home. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol VVSliderProtocol <NSObject>

-(UIView *)viewForIndex:(NSIndexPath *)indexOfView;

@end

@interface SliderView : UIView

@property (weak) id<VVSliderProtocol> delegate;

-(instancetype)initWithFrame:(CGRect)frame heading:(NSArray *)headings;

-(void)begin;

@end
