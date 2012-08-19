# MDCScrollBarLabel [![endorse](http://api.coderwall.com/modocache/endorsecount.png)](http://coderwall.com/modocache)

An animated scroll bar to present extra information
to the used when scrolling on a UIScrollView.

Y'know, like the clock on Path.

## Screenshots

![MDCScrollBarLabel GIF](http://f.cl.ly/items/2U3d0j3G3O2j1W1Q3525/mdcscrollbarlabel.gif)

## Usage

See the example application for usage.

Basically, you have two options. You can:

- Subclass MDCScrollBarViewController and set an MDCScrollBarLabel to its
  scrollBarLabel property.
- Implement a UIViewController which is a UIScrollBarDelegate, then call the
  fade in/out logic for the label as you'd like.

Or copy-paste the fade in/out and positioning logic and re-write
the whole thing to better suit your needs.

## To-do, or How to Contribute

- Check out the Github issues for ideas on what to work on, or create your own for features you'd like to see!

## License

MIT-license. Use it as you please.
