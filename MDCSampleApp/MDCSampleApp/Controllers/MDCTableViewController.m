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


#import "MDCTableViewController.h"


static CGFloat const kMDCTableViewControllerRowHeight = 100.0f;


@interface MDCTableViewController () <UITableViewDataSource, UITableViewDelegate>

@end


@implementation MDCTableViewController


#pragma mark - UIViewController Overrides

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"UITableView";

    CGSize size = self.view.frame.size;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)
                                                  style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = kMDCTableViewControllerRowHeight;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                      UIViewAutoresizingFlexibleHeight;

    self.scrollBarLabel = [[MDCScrollBarLabel alloc] initWithScrollView:self.tableView];

    [self.view addSubview:self.tableView];
    [self.tableView insertSubview:self.scrollBarLabel atIndex:0];
}


- (void)viewDidUnload
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.tableView = nil;

    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - MDCScrollBarViewController Overrides

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];

    NSInteger rowNumber = self.scrollBarLabel.frame.origin.y / kMDCTableViewControllerRowHeight;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-(60 * 12 * rowNumber)];
    self.scrollBarLabel.date = date;
}


#pragma mark - UITableViewDataSource Protocol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MDCTableViewControllerCellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }

    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-(60 * 12 * indexPath.row)];
    cell.textLabel.text = [date description];

    return cell;
}


#pragma mark - UITableViewDelegate Protocol Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
