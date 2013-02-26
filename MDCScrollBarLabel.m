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


#import "MDCScrollBarLabel.h"
#import <QuartzCore/QuartzCore.h>


#undef DEGREES_TO_RADIANS
#define DEGREES_TO_RADIANS(x) M_PI * (x) / 180.0


static CGFloat const kMDCScrollBarLabelWidth = 100.0f;
static CGFloat const kMDCScrollBarLabelHeight = 32.0f;
static CGFloat const kMDCScrollBarLabelClockWidth = 24.0f;
static CGFloat const kMDCScrollBarLabelClockTopMargin = -1.0f;
static CGFloat const kMDCScrollBarLabelClockLeftMargin = 4.0f;
static CGFloat const kMDCScrollBarLabelClockRightMargin = 7.0f;
static NSTimeInterval const kMDCScrollBarLabelDefaultClockAnimationDuration = 0.2f;
static NSTimeInterval const kMDCScrollBarLabelDefaultFadeAnimationDuration = 0.3f;
static CGFloat const kMDCScrollBarLabelDefaultHorizontalPadding = 10.0f;
static CGFloat const kMDCScrollBarLabelDefaultVerticalPadding = 30.0f;


typedef enum {
    MDCClockHandTypeHour = 0,
    MDCClockHandTypeMinute
} MDCClockHandType;


@interface MDCScrollBarLabel ()
@property (nonatomic, strong) NSDate *displayedDate;
@property (nonatomic, strong) UIImageView *clockImageView;
@property (nonatomic, strong) UIImageView *clockCenterImageView;
@property (nonatomic, strong) UIImageView *hourHandImageView;
@property (nonatomic, strong) UIImageView *minuteHandImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *weekdayLabel;

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *weekdayDateFormatter;
@end


@implementation MDCScrollBarLabel


#pragma mark - Object Lifecycle

- (id)initWithScrollView:(UIScrollView *)scrollView {
    CGRect frame = CGRectMake(scrollView.frame.size.width - kMDCScrollBarLabelWidth,
                              kMDCScrollBarLabelDefaultVerticalPadding,
                              kMDCScrollBarLabelWidth,
                              kMDCScrollBarLabelHeight);

    self = [super initWithFrame:frame];
    if (self) {
        _clockAnimationDuration = kMDCScrollBarLabelDefaultClockAnimationDuration;
        _fadeAnimationDuration = kMDCScrollBarLabelDefaultFadeAnimationDuration;
        _horizontalPadding = kMDCScrollBarLabelDefaultHorizontalPadding;
        _verticalPadding = kMDCScrollBarLabelDefaultVerticalPadding;

        _scrollView = scrollView;

        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateFormat = @"h:mm a";

        _weekdayDateFormatter = [NSDateFormatter new];
        _weekdayDateFormatter.dateFormat = @"EEEE";

        self.alpha = 0.0f;
        self.backgroundColor = [UIColor clearColor];

        UIImage *backgroundImage = [UIImage imageNamed:@"label-background.png"];
        backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:15.0f
                                                               topCapHeight:5.0f];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        backgroundImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:backgroundImageView];

        UIImage *clockFaceImage = [UIImage imageNamed:@"clock-face.png"];
        UIImageView *clockImageView = [[UIImageView alloc] initWithImage:clockFaceImage];
        clockImageView.frame = CGRectMake(kMDCScrollBarLabelClockLeftMargin,
                                          floorf((self.frame.size.height - clockImageView.frame.size.height)/2)
                                            + kMDCScrollBarLabelClockTopMargin,
                                          clockImageView.frame.size.width,
                                          clockImageView.frame.size.height);
        [self addSubview:clockImageView];

        UIImage *clockCenterImage = [UIImage imageNamed:@"clock-center.png"];
        UIImageView *clockCenterImageView = [[UIImageView alloc] initWithImage:clockCenterImage];
        clockCenterImageView.center = clockImageView.center;
        [self addSubview:clockCenterImageView];

        UIImage *hourHandImage = [UIImage imageNamed:@"clock-hour-hand.png"];
        self.hourHandImageView = [[UIImageView alloc] initWithImage:hourHandImage];
        self.hourHandImageView.center = clockCenterImageView.center;
        self.hourHandImageView.layer.anchorPoint = CGPointMake(0.5, 1.0);
        [self insertSubview:self.hourHandImageView belowSubview:clockCenterImageView];

        UIImage *minuteHandImage = [UIImage imageNamed:@"clock-minute-hand.png"];
        self.minuteHandImageView = [[UIImageView alloc] initWithImage:minuteHandImage];
        self.minuteHandImageView.center = clockCenterImageView.center;
        self.minuteHandImageView.layer.anchorPoint = CGPointMake(0.5, 1.0);
        [self insertSubview:self.minuteHandImageView belowSubview:self.hourHandImageView];

        CGFloat labelHeight = 12.0f;
        CGFloat labelWidth = self.frame.size.width - kMDCScrollBarLabelClockWidth - kMDCScrollBarLabelClockRightMargin;
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
        self.timeLabel.textColor = [UIColor whiteColor];

        CGRect weekdayLabelRect = CGRectMake(kMDCScrollBarLabelClockWidth + kMDCScrollBarLabelClockRightMargin,
                                             floorf(self.frame.size.height/2),
                                             labelWidth,
                                             labelHeight);
        self.weekdayLabel = [[UILabel alloc] initWithFrame:weekdayLabelRect];
        self.weekdayLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];

        for (UILabel *label in @[self.timeLabel, self.weekdayLabel]) {
            label.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0f];
            label.shadowColor = [UIColor darkTextColor];
            label.shadowOffset = CGSizeMake(0, -1);
            label.textAlignment = UITextAlignmentLeft;
            label.backgroundColor = [UIColor clearColor];
        }
        [self addSubview:self.timeLabel];
        [self insertSubview:self.weekdayLabel belowSubview:self.timeLabel];

        [self setWeekdayLabelHidden:YES animated:NO];
    }
    return self;
}


#pragma mark - Public Interface

- (void)setDate:(NSDate *)date {
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
                             NSWeekdayCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *dateComponents = [self.calendar components:unitFlags fromDate:date];
    NSDateComponents *nowComponents = [self.calendar components:unitFlags fromDate:[NSDate date]];

    if (nowComponents.year > dateComponents.year || nowComponents.month > dateComponents.month || nowComponents.day > dateComponents.day) {
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-(60.0f * 60.0f * 24.0f)];
        NSDateComponents *yesterdayComponents = [self.calendar components:unitFlags fromDate:yesterday];

        if (yesterdayComponents.weekday == dateComponents.weekday) {
            self.weekdayLabel.text = NSLocalizedString(@"Yesterday", nil);
        } else {
            self.weekdayLabel.text = [self.weekdayDateFormatter stringFromDate:date];
        }
        [self setWeekdayLabelHidden:NO animated:YES];
    } else {
        [self setWeekdayLabelHidden:YES animated:YES];
    }

    NSString *dateString = [self.dateFormatter stringFromDate:date];
    self.timeLabel.text = dateString;

    // Grab hour in 12hr format, regardless of user settings.
    NSString *hourString = [[dateString componentsSeparatedByString:@":"] objectAtIndex:0];
    NSUInteger hour = [hourString integerValue];

    BOOL forward = [self.displayedDate compare:date] == NSOrderedAscending;
    [self setClockHandWithType:MDCClockHandTypeHour
                       toValue:hour
                      inFuture:forward
                      animated:YES];
    [self setClockHandWithType:MDCClockHandTypeMinute
                       toValue:dateComponents.minute
                      inFuture:forward
                      animated:YES];

    self.displayedDate = date;
}

- (void)adjustPositionForScrollView:(UIScrollView *)scrollView {
    CGSize size = self.frame.size;
    CGPoint origin = self.frame.origin;
    UIView *indicator = [[scrollView subviews] lastObject];

    float y = \
        scrollView.contentOffset.y \
        + scrollView.contentOffset.y * (scrollView.frame.size.height/scrollView.contentSize.height)
        + scrollView.frame.size.height/scrollView.contentSize.height \
        + (indicator.frame.size.height - size.height)/2;

    float topLimit = self.verticalPadding + scrollView.contentOffset.y;

    if (y < topLimit) {
        y = topLimit;
    }

    self.frame = CGRectMake(origin.x, y, size.width, size.height);
}

- (void)setDisplayed:(BOOL)displayed animated:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    CGFloat end = displayed ? -self.horizontalPadding : 0.0;

    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:animated];
    [UIView animateWithDuration:self.fadeAnimationDuration
                          delay:delay
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, end, 0.0);
                         self.alpha = displayed ? 1.0f : 0.0f;
                     } completion:^(BOOL finished) {
                         if (finished) {
                             self.center = CGPointMake(floorf(self.scrollView.frame.size.width - self.frame.size.width/2),
                                                       self.center.y);
                             _displayed = YES;
                         }
                     }];
    [UIView setAnimationsEnabled:animationsEnabled];
}


#pragma mark - Internal Methods

- (void)setClockHandWithType:(MDCClockHandType)type toValue:(NSUInteger)value inFuture:(BOOL)inFuture animated:(BOOL)animated {
    if (type == MDCClockHandTypeHour && value > 12) {
        return;
    }

    if (type == MDCClockHandTypeMinute && value > 60) {
        return;
    }

    CGFloat angleForValue = type == MDCClockHandTypeHour ? 30.0 : 6.0f;
    __block UIImageView *handImageView =
        type == MDCClockHandTypeHour ? self.hourHandImageView : self.minuteHandImageView;

    CGFloat end = value * DEGREES_TO_RADIANS(angleForValue);
    end = inFuture ? end : -end;

    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:animated];
    [UIView animateWithDuration:self.clockAnimationDuration
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         handImageView.transform = CGAffineTransformMakeRotation(end);
                     }
                     completion:nil];
    [UIView setAnimationsEnabled:animationsEnabled];
}

- (void)setWeekdayLabelHidden:(BOOL)hidden animated:(BOOL)animated {
    CGFloat labelOriginX = kMDCScrollBarLabelClockWidth + kMDCScrollBarLabelClockRightMargin;
    CGFloat labelOriginY = floorf((self.frame.size.height - self.timeLabel.frame.size.height)/2);
    labelOriginY = hidden ? labelOriginY : floorf(labelOriginY - (labelOriginY/2) - 1);
    CGRect labelRect = CGRectMake(labelOriginX,
                                  labelOriginY,
                                  self.timeLabel.frame.size.width,
                                  self.timeLabel.frame.size.height);
    
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:animated];
    [UIView animateWithDuration:self.clockAnimationDuration animations:^{
        self.timeLabel.frame = labelRect;
        self.weekdayLabel.alpha = hidden ? 0 : 1.0f;
    }];
    [UIView setAnimationsEnabled:animationsEnabled];
}

@end
