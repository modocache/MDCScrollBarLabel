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


#import "MDCRootViewController.h"

#import "MDCScrollViewController.h"
#import "MDCSmallScrollViewController.h"
#import "MDCTableViewController.h"
#import "MDCWebViewController.h"


typedef enum {
    MDCRootViewControllerCellTagUIScrollView = 0,
    MDCRootViewControllerCellTagEmbeddedUIScrollView,
    MDCRootViewControllerCellTagUIWebView,
    MDCRootViewControllerCellTagUITableView,
} MDCRootViewControllerCellTag;


@implementation MDCRootViewController


#pragma mark - Object Lifecycle

- (id)init
{
    return [super initWithStyle:UITableViewStylePlain];
}


#pragma mark - UIViewController Overrides

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Examples", nil);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - UITableViewDataSource Protcol Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MDCRootViewControllerCellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:cellIdentifier];
    }

    switch (indexPath.row) {
        case MDCRootViewControllerCellTagUIScrollView:
            cell.textLabel.text = @"UIScrollView";
            break;
        case MDCRootViewControllerCellTagEmbeddedUIScrollView:
            cell.textLabel.text = @"Embedded UIScrollView";
            break;
        case MDCRootViewControllerCellTagUIWebView:
            cell.textLabel.text = @"UIWebView";
            break;
        case MDCRootViewControllerCellTagUITableView:
            cell.textLabel.text = @"UITableView";
            break;
        default:
            break;
    }

    return cell;
}


#pragma mark - UITableViewDelegate Protocol Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case MDCRootViewControllerCellTagUIScrollView: {
            MDCScrollViewController *scrollViewController = [MDCScrollViewController new];
            [self.navigationController pushViewController:scrollViewController animated:YES];
            break;
        }
        case MDCRootViewControllerCellTagEmbeddedUIScrollView: {
            MDCSmallScrollViewController *scrollViewController = [MDCSmallScrollViewController new];
            [self.navigationController pushViewController:scrollViewController animated:YES];
            break;
        }
        case MDCRootViewControllerCellTagUIWebView: {
            MDCWebViewController *webViewController = [MDCWebViewController new];
            [self.navigationController pushViewController:webViewController animated:YES];
            break;
        }
        case MDCRootViewControllerCellTagUITableView: {
            MDCTableViewController *tableViewController = [MDCTableViewController new];
            [self.navigationController pushViewController:tableViewController animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
