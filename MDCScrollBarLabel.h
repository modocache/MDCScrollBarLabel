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


#import <Foundation/Foundation.h>


@interface MDCScrollBarLabel : UIView

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, readonly) BOOL displayed;
@property (nonatomic, assign) NSTimeInterval clockAnimationDuration;
@property (nonatomic, assign) NSTimeInterval fadeAnimationDuration;
@property (nonatomic, assign) CGFloat horizontalPadding;
@property (nonatomic, assign) CGFloat verticalPadding;

- (id)initWithScrollView:(UIScrollView *)scrollView;
- (void)adjustPositionForScrollView:(UIScrollView *)scrollView;
- (void)setDisplayed:(BOOL)displayed animated:(BOOL)animated afterDelay:(NSTimeInterval)delay;

@end
