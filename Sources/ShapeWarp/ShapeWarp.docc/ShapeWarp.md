# ``ShapeWarp``

ShapeWarp modifies a `shape` and produces a new `shape` where the control
points have been shifted by an `amount`.

We also provide a `seed` value for pseudo-randomness

## Overview

Warping shapes is straight forward with ShapeWarp

![Warped](04_RectangleWarp.png)

```
Rectangle()
  .warp(amount: 10, seed: 45678)
```

We've written an extension

```
extension Shape {
  func warp(amount: CGFloat, seed: UInt64, include: PointType = .all) -> some Shape {}
}
```

## Topics

### Guides

- <doc:Getting-Started-with-ShapeWarp>
