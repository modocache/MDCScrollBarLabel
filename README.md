# MDCScrollBarLabel

An animated scroll bar to present extra information to the used when scrolling on a UIScrollView.

Y'know, like the clock on Path.

![MDCScrollBarLabel GIF](http://f.cl.ly/items/2U3d0j3G3O2j1W1Q3525/mdcscrollbarlabel.gif)

## Usage

Basically, you have two options. You can:

- Subclass MDCScrollBarViewController and set an MDCScrollBarLabel to its
  scrollBarLabel property.
- Implement a UIViewController which is a UIScrollBarDelegate, then call the
  fade in/out logic for the label as you'd like.

See the example application for usage.

### Subclassing `MDCScrollBarViewController`

```objc
#pragma mark - Creating the Scroll Bar Label

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create a table view with a row height of 100.f
    CGSize size = self.view.frame.size;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100.f;
    [self.view addSubview:self.tableView];

    // Add a scroll bar label to the table view
    self.scrollBarLabel = [[MDCScrollBarLabel alloc] initWithScrollView:self.tableView];
    [self.tableView addSubview:self.scrollBarLabel];
}

#pragma mark - Updating the Date on the Scroll Bar Label

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];

    // Determine which row the scroll bar label is currently hovering over
    NSInteger rowNumber = CGRectGetMinY(self.scrollBarLabel.frame) / 100.f;

    // Update the date on the label using the model data for that row
    // (here we assume you have a model named `Event`)
    Event *event = self.events[rowNumber];
    self.scrollBarLabel.date = event.date;
}
```

### Subclassing `UIViewController <UIScrollViewDelegate>`

```objc
#pragma mark - Show/Hide the Label Using UIScrollViewDelegate Callbacks

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.scrollBarLabel adjustPositionForScrollView:scrollView];
    [self.scrollBarLabel setDisplayed:YES animated:YES afterDelay:0.0f];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.scrollBarLabel setDisplayed:NO animated:YES afterDelay:self.scrollBarFadeDelay];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
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
```

## License

MIT license. See the LICENSE file for details.

