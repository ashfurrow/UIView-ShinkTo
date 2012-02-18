## What it is
This repo contains a UIView category called ShrinkTo which will let you easily shrink any view to a point within another view, much like the iOS Mail app.

[Here's a demo video.] (http://www.youtube.com/watch?v=Xak3xqGKvqc)

## How to Use
Make sure to link against the QuartzCore framework in your build
settings or you'll get linker errors when you try to compile.

Call `shrinkToCenterOfView:` or `shrinkToPoint:inView:` on any UIView instance. The latter method takes a point in the second parameter's view coordinate system that specifies where the shrinking view should shrink to.

Thanks to [Mike Nachbaur](http://nachbaur.com) for guides on Core Animation. 
