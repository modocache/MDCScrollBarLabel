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


#import "MDCScrollViewController.h"

@implementation MDCScrollViewController

@synthesize scrollView = scrollView_;
@synthesize scrollBarLabel = scrollBarLabel_;


#pragma mark - Object Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"UIScrollView";
        
        // Add a very tall UIScrollView
        CGRect scrollFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.scrollView = [[[UIScrollView alloc] initWithFrame:scrollFrame] autorelease];
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,
                                                 self.view.frame.size.height*5);
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
        self.scrollView.delegate = self;
        
        self.scrollBarLabel = [[[MDCScrollBarLabel alloc] initWithScrollView:self.scrollView] autorelease];
        [self.scrollView addSubview:self.scrollBarLabel];
        
        [self.view addSubview:self.scrollView];
    }
    return self;
}


#pragma mark - UIViewController Overrides

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)viewDidUnload
{
    [scrollView_ release];
    [scrollBarLabel_ release];
    
    scrollView_ = nil;
    scrollBarLabel_ = nil;
    
    [super viewDidUnload];
}


#pragma mark - UIScrollViewDelegate Protocol Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.scrollBarLabel adjustPositionForScrollView:scrollView];
    [self.scrollBarLabel fadeIn];
    
    // Set label
    float progress = self.scrollView.contentOffset.y / self.scrollView.contentSize.height;
    self.scrollBarLabel.text = [NSString stringWithFormat:@"%f%", progress];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.scrollBarLabel performSelector:@selector(fadeOut)
                              withObject:nil
                              afterDelay:0.5];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self.scrollBarLabel performSelector:@selector(fadeOut)
                                  withObject:nil
                                  afterDelay:0.5];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
    [self.scrollBarLabel performSelector:@selector(fadeOut)
                              withObject:nil
                              afterDelay:0.5];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
    [self.scrollBarLabel performSelector:@selector(fadeOut)
                              withObject:nil
                              afterDelay:0.5];
}


@end
