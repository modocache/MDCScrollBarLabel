//
//  Copyright (c) 2013 modocache
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


#import "MDCScrollBarViewController.h"


static CGFloat const kMDCScrollBarViewControllerDefaultFadeDelay = 1.0f;


@implementation MDCScrollBarViewController


#pragma mark - Object Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        _scrollBarFadeDelay = kMDCScrollBarViewControllerDefaultFadeDelay;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _scrollBarFadeDelay = kMDCScrollBarViewControllerDefaultFadeDelay;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _scrollBarFadeDelay = kMDCScrollBarViewControllerDefaultFadeDelay;
    }
    return self;
}


#pragma mark - UIViewController Overrides

- (void)viewDidUnload
{
    self.scrollBarLabel.scrollView = nil;
    self.scrollBarLabel = nil;
    
    [super viewDidUnload];
}


#pragma mark - UIScrollViewDelegate Protocol Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.scrollBarLabel adjustPositionForScrollView:scrollView];
    [self.scrollBarLabel setDisplayed:YES animated:YES afterDelay:0.0f];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.scrollBarLabel setDisplayed:NO animated:YES afterDelay:self.scrollBarFadeDelay];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self.scrollBarLabel setDisplayed:NO animated:YES afterDelay:self.scrollBarFadeDelay];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self.scrollBarLabel setDisplayed:NO animated:YES afterDelay:self.scrollBarFadeDelay];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [self.scrollBarLabel setDisplayed:NO animated:YES afterDelay:self.scrollBarFadeDelay];
}

@end
