# MDCScrollBarLabel [![endorse](http://api.coderwall.com/modocache/endorsecount.png)](http://coderwall.com/modocache)

An animated scroll bar to present extra information
to the used when scrolling on a UIScrollView.

Y'know, like the clock on Path.

## Screenshots

- [UIScrollView](http://cl.ly/3i3x1s2n071r050r1t2k)
- [UITableView](http://cl.ly/0F3M2r0h1r2301130C09)
- [UIWebView](http://cl.ly/1447370Q0u023c1S1V2E)

## Usage

See the example application for usage.

Basically, you have two options. You can:

- Subclass MDCScrollBarViewController and set an MDCScrollBarLabel to it's
  scrollBarLabel property.
- Implement a UIViewController which is a UIScrollBarDelegate, then call the
  fade in/out logic for the label as you'd like.

Or copy-paste the fade in/out and positioning logic and re-write
the whole thing to better suit your needs.

## To-do, or How to Contribute

- I'm aware MDCScrollBarLabel isn't the sexiest UI you've ever seen.
  It would be nice to have a cool background image.
  An alternative would be to construct an init method or something
  which allows users to customize their own.
- Animation is wonky when switching between portrait and landscape.

## License

MIT-license. Use it as you please.
