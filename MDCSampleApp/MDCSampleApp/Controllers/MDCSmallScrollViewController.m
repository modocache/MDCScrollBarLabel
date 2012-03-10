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


#import "MDCSmallScrollViewController.h"

@implementation MDCSmallScrollViewController

@synthesize scrollView = scrollView_;
@synthesize scrollBarLabel = scrollBarLabel_;

#pragma mark - Object Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"UIScrollView";
        self.view.backgroundColor = [UIColor colorWithRed:0x00/255.0
                                                    green:0x8a/255.0
                                                     blue:0xb8/255.0
                                                    alpha:1.0];
        
        // Add a very tall UIScrollView
        CGRect scrollFrame = CGRectMake(50, 50,
                                        self.view.frame.size.width/2 + 50,
                                        self.view.frame.size.height/2);
        self.scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.scrollView.contentSize = CGSizeMake(scrollFrame.size.width,
                                                 self.view.frame.size.height*2);
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                           UIViewAutoresizingFlexibleHeight;
        self.scrollView.delegate = self;
        
        self.scrollBarLabel = [[MDCScrollBarLabel alloc] initWithScrollView:self.scrollView];
        [self.scrollView addSubview:self.scrollBarLabel];
        
        [self.view addSubview:self.scrollView];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark - UIViewController Overrides

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.scrollView release], self.scrollView = nil;
    [self.scrollBarLabel release], self.scrollBarLabel = nil;
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

@end
