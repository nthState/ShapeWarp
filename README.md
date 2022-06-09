# Chris's SwiftUI Shape Warp

ShapeWarp modifies a `shape` and produces a new `shape` where the control
points have been shifted by an `amount`.
We also provide a `seed` value for pseudo-randomness

## Overview

Warping shapes is straight forward with PathWarp

```
Rectangle()
  .warp(amount: 10, seed: 45678)
```

| Before | After |
|--------|-------|
![Warped](Sources/ShapeWarp/ShapeWarp.docc/Resources/Images/01_RectangleWarp.png)|![Warped](Sources/ShapeWarp/ShapeWarp.docc/Resources/Images/04_RectangleWarp.png)

We've written an extension

```
extension Shape {
  func warp(amount: CGFloat, seed: UInt64, include: PointType = .all) -> some Shape {}
}
```

## Animation

I've spent time getting this package to a point where the shapes themselves animate nicely
between different settings.
This has been done by implementing `VectorArithmetic` on a custom `AnimatablePathElement` type


## Documentation

Doc website here: https://nthstate.github.io/ShapeWarp/documentation/shapewarp/

Building the docs

```
swift build
```

```
swift package --allow-writing-to-directory ./docs \
    generate-documentation --target ShapeWarp \
    --disable-indexing \
    --transform-for-static-hosting \
    --hosting-base-path ShapeWarp \
    --output-path ./docs
 ```
