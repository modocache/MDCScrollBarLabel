//
//  Copyright (c) 2012 modocache
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import "MDCScrollBarLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation MDCScrollBarLabel

@synthesize scrollView = scrollView_;

static float const kHorizontalPadding = 15.0f;
static float const kVerticalPadding = 30.0f;
static float const kLabelWidth = 100.0f;
static float const kLabelHeight = 30.0f;

#pragma mark - Object Lifecycle

- (id)initWithScrollView:(UIScrollView *)scrollView {
    CGRect frame = CGRectMake(scrollView.frame.size.width - kLabelWidth,
                              kVerticalPadding,
                              kLabelWidth,
                              kLabelHeight);
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.scrollView = scrollView;
        self.alpha = 0.0f;
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        self.shadowColor = [UIColor darkTextColor];
        self.shadowOffset = CGSizeMake(0, -1);
        self.textAlignment = UITextAlignmentCenter;
    }
    return self;
}

#pragma mark - Public Interface

- (void)adjustPositionForScrollView:(UIScrollView *)scrollView {
    CGSize size = self.frame.size;
    CGPoint origin = self.frame.origin;
    
    float y = scrollView.contentOffset.y \
    + (scrollView.contentOffset.y/scrollView.contentSize.height) \
    + scrollView.contentOffset.y * (scrollView.frame.size.height/scrollView.contentSize.height)
    + scrollView.frame.size.height/scrollView.contentSize.height;
    
    NSLog(@"%@:%@ -- [%f]", [self class], NSStringFromSelector(_cmd), y);
    
    if (y < kVerticalPadding) {
        y = kVerticalPadding + scrollView.contentOffset.y - size.height/2;
    } else if (y > scrollView.contentSize.height - kVerticalPadding - size.height/2) {
        y = scrollView.contentSize.height - kVerticalPadding \
        + scrollView.frame.size.height - size.height/2 \
        + scrollView.contentOffset.y - scrollView.contentSize.height;
    }
    
    self.layer.frame = CGRectMake(origin.x, y, size.width, size.height);
}

- (void)fadeIn {
    if (self.layer.animationKeys.count > 0 || self.alpha == 1) {
        return;
    }
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    float startPoint = self.layer.position.x;
    float endPoint = self.scrollView.frame.origin.x + self.scrollView.frame.size.width - \
    self.layer.frame.size.width/2 - kHorizontalPadding;
    positionAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:startPoint],
                                [NSNumber numberWithFloat:endPoint],
                                nil];
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.5f + self.alpha],
                               [NSNumber numberWithFloat:1.0f],
                               nil];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, opacityAnimation, nil];
    animationgroup.duration = 0.3;
    animationgroup.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:animationgroup forKey:@"fadeIn"];
    self.layer.position = CGPointMake(endPoint, self.layer.position.y);
    self.alpha = 1.0f;
}

- (void)fadeOut {
    if (self.layer.animationKeys.count > 0 || self.alpha == 0) {
        return;
    }
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    float startPoint = self.layer.position.x;
    float endPoint = self.scrollView.frame.origin.x + self.scrollView.frame.size.width - \
    self.layer.frame.size.width/2;
    positionAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:startPoint],
                                [NSNumber numberWithFloat:endPoint],
                                nil];
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.5f],
                               [NSNumber numberWithFloat:0.0f],
                               nil];
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, opacityAnimation, nil];
    animationgroup.duration = 0.3;
    animationgroup.fillMode = kCAFillModeForwards;
    
    [self.layer addAnimation:animationgroup forKey:@"fadeOut"];
    self.layer.position = CGPointMake(endPoint, self.layer.position.y);
    self.alpha = 0.0f;
}

@end
