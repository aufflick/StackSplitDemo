# StackSplitDemo

Basic sample showing how you can make a split view using an NSStackView, some constraints and a small amount of code.

Note how the left view has a single child, treat it like the content view. It's setup so that it never has to layout with a width of zero
(which is usually impossible), instead the resize drag bar will start to cover over it once it's reached its minimum size. This allows
collapsing, but you probably want the minimum snap size of your left view to match the minimum layout size. Making that automatic
is an exercise left for the reader :)

The constraints are all set up in the nib - this makes things easy to visualise what's going on, but probably better to make a SplitView subclass that handles all the setup internally in code.
